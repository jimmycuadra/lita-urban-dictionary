require "lita"

module Lita
  module Handlers
    # Looks up words on Urban Dictionary.
    class UrbanDictionary < Handler
      route(
        /^(?:ud|urban\s*dictionary)(?:\s+me)? (.+)/,
        :define,
        command: true,
        help: {
          "ud WORD" => "Get the definition of WORD from Urban Dictionary."
        }
      )

      def define(response)
        term = response.matches[0][0]
        word, definition, example = fetch_definition(term)
        if word
          lines = "#{word}: #{definition}".split("\n")
          lines << "Example: #{example}" if example
          message = message_from_lines(lines, term)
          response.reply(message)
        else
          response.reply("No definition found for #{term}.")
        end
      end

      private

      def fetch_definition(term)
        http_response = http.get(
          "http://api.urbandictionary.com/v0/define",
          term: term
        )

        if http_response.status == 200
          data = MultiJson.load(http_response.body)
          if data["list"] && data["list"].size > 0
            item = data["list"][0]
            [item["word"], item["definition"], item["example"]]
          end
        end
      end

      def message_from_lines(lines, term)
        if lines.size > 20
          lines = lines[0..19]
          lines << <<-TRUNCATION_MESSAGE.chomp
Read the entire definition at: http://www.urbandictionary.com/define.php?term=#{URI.encode(term)}
          TRUNCATION_MESSAGE
        end

        lines.join("\n")
      end
    end

    Lita.register_handler(UrbanDictionary)
  end
end

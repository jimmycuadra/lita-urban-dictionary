require "lita"

module Lita
  module Handlers
    # Looks up words on Urban Dictionary.
    class UrbanDictionary < Handler
      config :max_response_size, types: [Integer, nil], default: 20

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
          lines = "#{word}: #{definition}".split(/\r?\n/)
          if example
            example_lines = example.split(/\r?\n/)
            example_lines[0] = "Example: #{example_lines.first}"
            lines.concat(example_lines)
          end
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

      def determine_max_size(lines)
        if config.max_response_size.nil?
          max_size = lines.size
        else
          max_size = config.max_response_size - 1
        end
        max_size
      end

      def message_from_lines(lines, term)
        max_size = determine_max_size(lines)
        if lines.size > max_size
          lines = lines[0..max_size]
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

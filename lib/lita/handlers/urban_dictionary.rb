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
          message = "#{word}: #{definition}"
          message << "\nExample: #{example}" if example
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
    end

    Lita.register_handler(UrbanDictionary)
  end
end

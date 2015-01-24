# lita-urban-dictionary

[![Build Status](https://travis-ci.org/jimmycuadra/lita-urban-dictionary.png?branch=master)](https://travis-ci.org/jimmycuadra/lita-urban-dictionary)
[![Code Climate](https://codeclimate.com/github/jimmycuadra/lita-urban-dictionary.png)](https://codeclimate.com/github/jimmycuadra/lita-urban-dictionary)
[![Coverage Status](https://coveralls.io/repos/jimmycuadra/lita-urban-dictionary/badge.png)](https://coveralls.io/r/jimmycuadra/lita-urban-dictionary)

**lita-urban-dictionary** is a handler for [Lita](https://github.com/jimmycuadra/lita) looks up the definitions of words on [Urban Dictionary](http://www.urbandictionary.com/).

## Installation

Add lita-urban-dictionary to your Lita instance's Gemfile:

``` ruby
gem "lita-urban-dictionary"
```

## Configuration

### Optional attributes

* **max_response_size** (`Integer` || `nil`) - Sets a ceiling on the response size of the queried defintion. Default: `20` (20 lines of text).  `nil` will set no ceiling on responses.

### Example

This example configuration sets a max response size of 5 lines.

``` ruby
Lita.configure do |config|
  config.handlers.urban_dictionary.max_response_size = 5
end
```

>>>>>>> d050f60... Add max_response_size to config, add corresponding tests, handle case of nil values, document chages in README.
## Usage

To get the definition of a word:

```
Lita: ud WORD
```

## License

[MIT](http://opensource.org/licenses/MIT)

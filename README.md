# lita-urban-dictionary

[![Build Status](https://travis-ci.org/jimmycuadra/lita-urban-dictionary.png)](https://travis-ci.org/jimmycuadra/lita-urban-dictionary)
[![Code Climate](https://codeclimate.com/github/jimmycuadra/lita-urban-dictionary.png)](https://codeclimate.com/github/jimmycuadra/lita-urban-dictionary)
[![Coverage Status](https://coveralls.io/repos/jimmycuadra/lita-urban-dictionary/badge.png)](https://coveralls.io/r/jimmycuadra/lita-urban-dictionary)

**lita-urban-dictionary** is a handler for [Lita](https://github.com/jimmycuadra/lita) that tracks karma points for arbitrary terms. It listens for upvotes and downvotes and keeps a tally of the scores for them in Redis.

## Installation

Add lita-urban-dictionary to your Lita instance's Gemfile:

``` ruby
gem "lita-urban-dictionary"
```

## Usage

To get the definition of a word:

```
Lita: ud WORD
```

## License

[MIT](http://opensource.org/licenses/MIT)

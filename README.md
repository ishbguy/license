# license

An opensource software license generator written in shell script and powered by [GitHub's licenses API](https://developer.github.com/v3/licenses/).

## Features

+ Support all licenses available on GitHub.
+ Less dependences.
+ Generate without network (except on first run).

## Prerequisite

+ `bash`
+ `curl`
+ `jq`
+ `sed`

## Installation

You can get this program with `git`:

```
$ git clone https://github.com/ishbguy/license
```

or only download the `license.sh`:

```
$ curl -fLo license.sh \
         https://raw.githubusercontent.com/ishbguy/license/master/license.sh
```

## Usage

Generate a license:

```
$ license.sh mit
```

or rename a default LICENSE name:

```
$ license.sh -o LICENSE.txt mit
```

or specify the year and the author name:

```
$ license.sh -y 2018 -n "Herbert Shen" mit
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

+ [ishbguy](https://github.com/ishbguy)

## License

[MIT](https://opensource.org/licenses/MIT).

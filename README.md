# [license](https://github.com/ishbguy/license)

An opensource software license generator written in shell script and powered by [GitHub's licenses API](https://developer.github.com/v3/licenses/).

## Table of Contents

+ [Features](#features)
+ [Prerequisite](#prerequisite)
+ [Installation](#installation)
+ [Configuration](#configuration)
+ [Usage](#usage) 
+ [Contributing](#contributing)
+ [Authors](#authors)
+ [License](#license-1)

## Features

+ Support all licenses available on GitHub.
+ Less dependences.
+ Generate without network (except on first run).
+ Configurable.

## Prerequisite

> + [`bash`](https://www.gnu.org/software/bash/bash.html)
> + [`curl`](https://curl.haxx.se/)
> + [`jq`](https://stedolan.github.io/jq/)
> + [`sed`](https://www.gnu.org/software/sed/)

## Installation

You can get this program with `git`:

```
$ git clone https://github.com/ishbguy/license
```

or only download the `license.sh`:

```
$ curl -fLo license.sh \
         https://raw.githubusercontent.com/ishbguy/license/master/license.sh
$ chmod a+x license.sh
```

## Configuration

You can set you own config in `$HOME/.licenserc`:

```
# uncomment to set your own config
# all this three config can write in UPPER-CASE,
# so set AUTHOR, LICENSE_DIR, LICENSE_NAME is OK
author=ishbguy
#license_dir=
#license_name=
```

## Usage

Generate a license:

```
$ license.sh mit
```

Rename a default LICENSE name:

```
$ license.sh -o LICENSE.txt mit
```

Specify the year and the author name:

```
$ license.sh -y 2018 -n ishbguy mit
```

Specify a license directory:

```
$ license.sh -d lic mit
```

Download(if no licenses exist in the specify directory) or update licenses:

```
$ license.sh -d lic -u
```

List all available licenses:

```
$ license.sh -l
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

Released under the terms of the [MIT License](https://opensource.org/licenses/MIT).

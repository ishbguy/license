# [license](https://github.com/ishbguy/license)

An opensource software license generator written in shell script and powered by [GitHub's licenses API](https://developer.github.com/v3/licenses/).

## Table of Contents

+ [:art: Features](#art-features)
+ [:straight_ruler: Prerequisite](#straight_ruler-prerequisite)
+ [:rocket: Installation](#rocket-installation)
+ [:memo: Configuration](#memo-configuration)
+ [:notebook: Usage](#notebook-usage)
+ [:hibiscus: Contributing](#hibiscus-contributing)
+ [:boy: Authors](#boy-authors)
+ [:scroll: License](#scroll-license)

## :art: Features

+ Support all licenses available on GitHub.
+ Less dependences.
+ Generate without network (except on first run).
+ Configurable.

## :straight_ruler: Prerequisite

> + [`bash`](https://www.gnu.org/software/bash/bash.html)
> + [`curl`](https://curl.haxx.se/)
> + [`jq`](https://stedolan.github.io/jq/)
> + [`sed`](https://www.gnu.org/software/sed/)

## :rocket: Installation

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

## :memo: Configuration

You can set you own config in `$HOME/.licenserc`:

```
# uncomment to set your own config
# all this three config can write in UPPER-CASE,
# so set AUTHOR, LICENSE_DIR, LICENSE_NAME is OK

# the name who has the copyright
author=ishbguy

# licenses download directory
license_dir=~/.license

# backgroup jobs when downloading licenses
license_jobs=8
```

## :notebook: Usage

Generate a license to standard output

```
$ license.sh mit
```

Generate a license to a file:

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

## :hibiscus: Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## :boy: Authors

+ [ishbguy](https://github.com/ishbguy)

## :scroll: License

Released under the terms of [MIT License](https://opensource.org/licenses/MIT).

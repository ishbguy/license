# [license](https://github.com/ishbguy/license)

[![Travis][travissvg]][travis] [![Codecov][codecovsvg]][codecov] [![Codacy][codacysvg]][codacy] [![Version][versvg]][ver] [![License][licsvg]][lic]

[travissvg]: https://www.travis-ci.org/ishbguy/license.svg?branch=master
[travis]: https://www.travis-ci.org/ishbguy/license
[codecovsvg]: https://codecov.io/gh/ishbguy/license/branch/master/graph/badge.svg
[codecov]: https://codecov.io/gh/ishbguy/license
[codacysvg]: https://api.codacy.com/project/badge/Grade/03ce339293c24c08870ebde7e0b793e4
[codacy]: https://www.codacy.com/app/ishbguy/license?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ishbguy/license&amp;utm_campaign=Badge_Grade
[versvg]: https://img.shields.io/badge/version-v0.1.0-lightgrey.svg
[ver]: https://img.shields.io/badge/version-v0.1.0-lightgrey.svg
[licsvg]: https://img.shields.io/badge/license-MIT-green.svg
[lic]: https://github.com/ishbguy/baux/blob/master/LICENSE

An opensource software license generator written in shell script base on [baux](https://github.com/ishbguy/baux) and powered by [GitHub's licenses API](https://developer.github.com/v3/licenses/).

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
> + [`coreutils`](https://www.gnu.org/software/coreutils/coreutils.html)
> + [`sed`](https://www.gnu.org/software/sed/)
> + [`curl`](https://curl.haxx.se/)
> + [`jq`](https://stedolan.github.io/jq/)

## :rocket: Installation

You can get this program with `git`:

```
$ git clone https://github.com/ishbguy/license
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

Show information for choosing a license:

```
$ license.sh -c
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

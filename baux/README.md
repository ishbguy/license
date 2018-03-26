# [BAUX](https://github.com/ishbguy/baux)

[![Travis][travissvg]][travis] [![Codacy][codacysvg]][codacy] [![Version][versvg]][ver] [![License][licsvg]][lic]

[travissvg]: https://travis-ci.org/ishbguy/baux.svg?branch=master
[travis]: https://travis-ci.org/ishbguy/baux
[codacysvg]: https://api.codacy.com/project/badge/Grade/9a7820362a97474b87652d1519714e1b
[codacy]: https://www.codacy.com/app/ishbguy/baux?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ishbguy/baux&amp;utm_campaign=Badge_Grade
[versvg]: https://img.shields.io/badge/version-v0.0.1-lightgrey.svg
[ver]: https://img.shields.io/badge/version-v0.0.1-lightgrey.svg
[licsvg]: https://img.shields.io/badge/license-MIT-green.svg
[lic]: https://github.com/ishbguy/baux/blob/master/LICENSE

**BAUX** is a bash auxiliary library for writing script.

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

All the mentioned functions prefix with `baux_` in **BAUX**. Some features are not yet finished.

+ **Helper**
    - Alert: `die()`, `warn()`.
    - Information: `proname()`, `version()`, `help()`.
    - Utility: `cecho()`, `random()`.
+ **Assertion**
    - pre- or post- condition: `ensure()`, `ensure_not_empty()`.
    - Numeric ensure: `ensure_equal()`, `ensure_not_equal()`.
    - String ensure: `ensure_like()`, `ensure_unlike()`, `ensure_is()`, `ensure_isnt()`.
+ **Debugging**
    - Logger: `logger()`.
    - Trace: `callstack()`.
+ **Testing**
    - `is` test: `is_xxx()`.
    - Test suit: `unit_add()`, `unit_run()`, `unit_sum()`, `unit_setup()`, `unit_teardown()`.
+ **Algorithms**
    - Data structure: stack, queue, list, tree, etc.
    - Sort and search: `qsort()`, `bsearch()`.
+ **Numeric**
    - Floating point: add, minus, time, divide, etc.
    - Complex number: add, minus, time, divide, etc.
+ **Exception**
    - `try()`, `catch()`, `throw()`.
+ **Regex**
    - Pattern match: IP, URL, tele-number, etc.

## :straight_ruler: Prerequisite

> + [`bash` > 4.3](https://www.gnu.org/software/bash/bash.html)
> + [`sed`](https://www.gnu.org/software/sed/)

## :rocket: Installation

You can get this program with `git`:

```
$ git clone https://github.com/ishbguy/baux
```

## :memo: Configuration

no.

## :notebook: Usage

You can easily source the repo's `baux.sh` in your script and start to use the functions **BAUX** provide.

```bash
# in your script
source /path/to/bash.sh

[[ -e file ]] || baux_die "file not exist."
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

Released under the terms of the [MIT License](https://opensource.org/licenses/MIT).
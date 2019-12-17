# swpro ![](https://github.com/takanotume24/swpro/workflows/Crystal%20CI/badge.svg)
Crystalによって書かれたUbuntu用HTTPプロキシ設定CLIツールです｡
現在はaptにのみ対応しています｡


## Installation

このレポジトリをクローンし､
```
crystal build src/swtch-proxy.cr
```
を実行すると､実行可能ファイルが生成されます｡
## Usage
![demo](https://raw.githubusercontent.com/takanotume24/swpro/master/gif/simplescreenrecorder-2019-12-15_01.53.59.gif)

```
  proxy setting tool.

  Usage:

    swpro [sub_command] [arguments]

  Options:

    --help                           Show this help.

  Sub Commands:

    enable    enable proxy setting
    disable   disable proxy setting
    set       set configs
```
## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/switch-proxy/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [your-name-here](https://github.com/your-github-user) - creator and maintainer

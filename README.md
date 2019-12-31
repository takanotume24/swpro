# swpro ![](https://github.com/takanotume24/swpro/workflows/Crystal%20CI/badge.svg)
Crystalによって書かれたUbuntu用HTTPプロキシ設定CLIツールです｡    
jsonファイルにコマンドごとの変更点を記述することによって､任意のコマンドのHTTPプロキシ設定をサポートすることができます｡
現在開発中のため､jsonファイル形式などが変更される可能性があります｡

<br/>

## 背景
学校･職場などでのネットワークにHTTPプロキシサーバが設置されている環境下で､Ubuntuマシンを使おうとするとそれぞれのコマンドにHTTPプロキシの設定を適用しなければいけません｡その際､コマンドごとにHTTPプロキシの設定の仕方はまちまちで､設定のたびに設定方法を調べる必要がありました｡swproはその設定方法の差異を吸収し操作を統一します｡

<br/>

## Installation
### [手順1]実行ファイルを用意する
- #### 方法1 : [おすすめ]このレポジトリをクローンする
   ```
   $ git clone https://github.com/takanotume24/swpro.git
   ```
   ``./bin/swpro``が実行ファイルです｡

   以下を実行するとswproアップデートすることができます｡
   ```
   $ git pull
   ```

- #### 方法2 : コンパイル済みバイナリ単体をダウンロードする
   https://github.com/takanotume24/swpro/releases にコンパイル済みバイナリを公開しています｡

- #### 方法3 : ソースコードからビルドする
   このレポジトリをクローンし､
   ```
   $ crystal build src/cli.cr -o bin/swpro
   ```
   を実行すると､実行可能ファイル(bin/swpro)が生成されます｡

### [手順2]コンフィグファイルをダウンロードし､インストールする
   設定済みコンフィグファイルを  [ダウンロード](https://raw.githubusercontent.com/takanotume24/swpro/master/.swpro.json)し､``~/.swpro.json``へコピーします｡
   ```
   $ wget https://raw.githubusercontent.com/takanotume24/swpro/master/.swpro.json -O ~/.swpro.json
   $ ./bin/swpro install
   ```

<br/>


## Usage
### コマンド使用方法


- #### コマンドに対してプロキシサーバを登録する
   ```
   swpro set [command] [url]
   ```
   例:``wget``に``http://proxy.example.com:8080``をHTTPプロキシサーバとして登録する｡  
   ```
   swpro set wget http://proxy.example.com:8080
   ```
- #### コマンドに対してプロキシを無効化する
   ```
   swpro disable [command]
   ```
   例:``wget``のHTTPプロキシを無効化する｡
   ```
   swpro disable wget
   ```
- #### コマンドに対してプロキシを有効化する
   ```
   swpro enable [command]
   ```
   例:``wget``のHTTPプロキシを有効化する｡
   ```
   swpro enable wget
   ```
<br/>


### ``.config.json``のフォーマットについて
以下を参照してください｡  
https://github.com/takanotume24/swpro/blob/master/.swpro.json

<br/>

## Development

TODO: Write development instructions here
<br/>

## Contributing

1. Fork it (<https://github.com/your-github-user/switch-proxy/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
<br/>

## Contributors

- [your-name-here](https://github.com/your-github-user) - creator and maintainer

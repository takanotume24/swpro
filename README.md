日本語のREADMEは https://github.com/takanotume24/swpro/blob/master/README_JA.md を参照してください。

# swpro ![](https://github.com/takanotume24/swpro/workflows/Crystal%20CI/badge.svg)
It is an HTTP proxy setting CLI tool for Ubuntu. It supports any software that describes proxy settings in a configuration file.  
By describing changes for each command in the json file, it is possible to support HTTP proxy settings for any command.  
Since this software is currently under development, the json file format may be changed.  
<br/>

## demo
### wget  
![](https://raw.githubusercontent.com/takanotume24/swpro/master/gif/set.gif)
### apt  
![](https://raw.githubusercontent.com/takanotume24/swpro/master/gif/apt.gif)
<br/>

## Background of development
When using an Ubuntu machine in an environment where an HTTP proxy server is installed in a network such as a school or workplace, the HTTP proxy settings must be applied to each command.   
The way to set the proxy was different, and it was necessary to check the setting method every time. ``swpro`` absorbs the difference of the setting method and unifies the operation.
<br/>

## Installation
### [Step 1] Prepare executable file
- #### Method 1 : [Recommended]Clone this repository
   ```
   $ git clone https://github.com/takanotume24/swpro.git
   ```
   `` ./bin/swpro`` is the executable file.

   You can update swpro by running:
   ```
   $ git pull
   ```

- #### Method 2 : Download the compiled binary
   We publish the compiled binary in https://github.com/takanotume24/swpro/releases

- #### Method 3 : Build from source code
   Clone this repository,
   ```
   $ shards
   $ mkdir bin
   $ crystal build src/cli.cr -o bin/swpro
   ```
   Executing will generate an executable file (``bin/swpro``).

### [Step 2] Download and install config file
   [Download]((https://raw.githubusercontent.com/takanotume24/swpro/master/.swpro.json) the configured config file and copy it to ``~/.swpro.json``.
   ```
   $ wget https://raw.githubusercontent.com/takanotume24/swpro/master/.swpro.json -O ~/.swpro.json
   $ ./bin/swpro install
   ```

<br/>


## Usage
### Command usage


- #### Register a proxy server for commands
   ```
   swpro set [command] [url]
   ```
   An example: Register ``http://proxy.example.com:8080`` as an HTTP proxy server in ``wget``
   ```
   swpro set wget http://proxy.example.com:8080
   ```
- #### Disable proxy for commands
   ```
   swpro disable [command]
   ```
   An example: Disable HTTP proxy for ``wget``
   ```
   swpro disable wget
   ```
- #### Enable proxy for commands
   ```
   swpro enable [command]
   ```
   An example: Enable HTTP proxy for ``wget``
   ```
   swpro enable wget
   ```
<br/>


### About the format of ``.config.json``
Please refer to the following.
- [Sample](https://github.com/takanotume24/swpro/blob/master/.swpro.json)
- [Description rules](https://github.com/takanotume24/swpro/wiki/.swpro.json%E3%81%AE%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)

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

- [takanotume24](https://github.com/takanotume24) - creator and maintainer

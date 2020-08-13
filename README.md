
# swpro ![](https://github.com/takanotume24/swpro/workflows/Crystal%20CI/badge.svg) ![](https://img.shields.io/github/issues/takanotume24/swpro) ![](https://img.shields.io/github/stars/takanotume24/swpro)
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
- ### Method 1 : **[Recommended]** install with compiled binary
   ```
   $ git clone https://github.com/takanotume24/swpro.git
   $ make install
   ```

   [Tips] You can add proxy setting to ``git`` manually by following.
   ```
   $ git config --global http.proxy http://proxy.example.com:8080
   $ git config --global https.proxy http://proxy.example.com:8080
   ```
</br>

- ### Method 2 : Download the compiled binary
   We publish the compiled binary in https://github.com/takanotume24/swpro/releases

</br>


- ### Method 3 : Build from source code
   ```
   $ git clone https://github.com/takanotume24/swpro.git
   $ make install-with-crystal-env
   ```



<br/>


## Usage
### Command usage


- #### Register a proxy server for commands
   ```
   $ swpro set [command] [url]
   ```
   An example: Register ``http://proxy.example.com:8080`` as an HTTP proxy server in ``wget``
   ```
   $ swpro set wget http://proxy.example.com:8080
   ```
   Write proxy settings to all registered commands
   ```
   $ sudo swpro set http://proxy.example.com:8080
   ```
<br/>


- #### Disable proxy for commands
   ```
   $ swpro disable [command]
   ```
   An example: Disable HTTP proxy for ``wget``
   ```
   $ swpro disable wget
   ```
   Disable the proxy settings for all registered commands
   ```
   $ sudo swpro disable all 
   ```
<br/>


- #### Enable proxy for commands
   ```
   $ swpro enable [command]
   ```
   An example: Enable HTTP proxy for ``wget``
   ```
   $ swpro enable wget
   ```
   Enable the proxy settings for all registered commands
   ```
   $ sudo swpro enable all
   ```
<br/>


## Uninstallation
```
$ cd path-to-cloned-folder-of-swpro
$ make uninstall
```
<br/>


### About the format of ``.swpro.json``
Please refer to the following.
- [Sample](https://github.com/takanotume24/swpro/blob/master/.swpro.json)
- [Description rules](https://github.com/takanotume24/swpro/wiki/.swpro.json%E3%81%AE%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)

<br/>

## Development

TODO: Write development instructions here
<br/>

## Contributing

1. Fork it (<https://github.com/takanotume24/swpro/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


<br/>

## Contributors

- [takanotume24](https://github.com/takanotume24) - creator and maintainer

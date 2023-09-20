[web.sh](https://github.com/yxm-dev/web.sh) is a `Bash` function designed to open pages in browsers from a
terminal emulator. Some features include searching on search engines as Google, DuckDuckGo, Bing and
Wikipedia, as well as creating your custom bookmarks.

Install
--------

This `Bash` tool was constructed using [pkg.sh](https://github.com/yxm-dev/pkg.sh), a pure `Bash` package
builder. The building process is quite similar to a package made using `GNU Make`: 

* Clone this repository:
```bash
    git clone https://github.com/yxm-dev/web.sh
```
* Enter in the `install` directory:
```bash
    cd web.sh/install
```
* Execute `./configure` and enter the directory where [web.sh](https://github.com/yxm-dev/web.sh) will be
  installed (the default is `$HOM    0E/.config/web.sh`)
* Then pass a `./install`.
* To uninstall execute the `install/uninstall` script or call `web --uninstall`

Dependencies
---------

The only dependency is `sed` which, if missing, is automatically installed during the building process.

Usage
------

```bash
usage: web [options] [arguments] (general case)
   or: web                       (interactive mode)

options:
    -c, -cgf, --config                enter in the configuration mode
    -h, --help                        display this help message
    -brw, --brw, --browsers           list the configured browsers
    -s, --search                      enter in the search mode 
        [ -l, --list ]                [list the configured search engines]
    -u, -url, --url                   enter in the open url mode
    -a, -add, --add                   add a new bookmark
    -l, --list                        list the existing bookmarks
    -b, --bookmark                    open a bookmark
    -r, --remove                      remove a bookmark
    --uninstall                       uninstall web.sh
```

Related Projects
------------------

* [surfraw](https://gitlab.com/surfraw/Surfraw): a solution for searching in a lot of search engines. Written
  in `POSIX` and `Perl`.
* [s-search](https://github.com/zquestz/s): same scope of [web.sh](https://github.com/yxm-dev/web.sh), but
  written in `Go`.
* [googler](https://github.com/jarun/googler): complete solution for searching in Google from a terminal
  emulator, with color outputs, auto completion, etc. Written in `Python`.
* [ddg](https://github.com/jarun/ddgr): similar to [googler](https://github.com/jarun/googler), but for the
  DuckDuckGo engine. Also written in `Python`. 
* [googliser](https://github.com/teracow/googliser): to search and download images from Google. Written in
  `Bash`.

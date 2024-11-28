# About

`web` is a `bash` function to perform web searches and manage bookmarks from terminal, with configurations in YAML.

# Features

1. autocompletion included
2. bookmarks organized into namespaces
3. search across the main software development and AI search engines
4. easily configurable 
6. no compilation needed: just plug and play

# Dependencies

- [yq(https://github.com/mikefarah/yq) `v4^`

# Install

* Clone this repository:
```bash
git clone https://github.com/ximenesyuri/web your/favorite/location
```
* Source the `web` function in your `.bashrc`:
```bash
echo "source your/favorite/location/web" >> $HOME/.bashrc
```

# Usage

```
USAGE:
  web [options] [arguments]

OPTIONS:
  -a, --add bookmark_name url private(true/false) profile_name
      Add a new bookmark with specified details.

  -s, --search [engine] [search_term]
      Search using a specific engine or default engine if none is specified.

  -l, --list [category]
      List items based on category:
          b, book, bookmarks - List all bookmarks.
          p, prot, protocols - List supported protocols.
          B, brow, browsers  - List supported browsers.
          s, src,  sources   - List available search engines.

  [url]
      Open the specified URL directly.
    
ALIASES:
  wb             = web
  wb ls[b/p/B,s] = web ls bookmarks/protocols/browsers/sources
```

> **Remark.** `web [something]` will look if `[something]` is:
> 1. an option
> 2. a bookmark, opening its url 
> 3. a url with valid protocol, opening it

# Configuration

Global user settings can be defined in the `yml/conf.yml` file.

```yaml
# yml/conf.yml
default:
    browser: ........... default browser
    search: ............ default search engine
    private: ........... if true, open pages in private mode
    
protocols:
    http: .............. if true, allow http urls
    https: ............. if true, allow https urls
    ...
```

# Bookmarks

Bookmarks are categorized by the following arguments:
```
argument        format                             meaning                                    required
--------------------------------------------------------------------------------------------------------
namespace       namespace1:namespace2:...:name     the namespace bookmark string              true
url             protocol://path                    the url to be attached to the bookmark     true
private         true/false                         true to open bookmark in private windown   false
profile         string                             browser profile to open the bookmark       false
```

They are stored in the `yml/bookmarks.yml` file, as follows:

```yaml
# yml/bookmarks.yml
namespace1:
    namespace2:
        ...
            name: 
                url:
                private:
                profile:
```

One can perform the following actions with bookmarks:

```
action             command
----------------------------------
create             web add [namespace] [url] [private] [profile]
remove             web rm  [namespace]
list               web lsb
open               web [namespace]
```

# Engines

Search engines are characterized by:
```
argument        meaning          
--------------------------------------------------
category        engine's category
label           engine's label
query url       the url used to perform the search
aliases         engine's short names
```

They are stored in the `yml/bookmarks.yml` file, as follows:

```yaml
# yml/bookmarks.yml
category:
    label:
        url:
        aliases:
            - alias1
            - ...
```

Currently one has the following registered categories and search engines:

```
category: general
--------------------------------------
engine          | url                                                     | alias
--------------------------------------------------------------------------------------
google          | https://google.com/search?q=...                         | g, ggl
duckduckgo      | https://duckduckgo.com/?q=...                           | ddg, duck
bing            | https://www.bing.com/search?q=...                       | b
yahoo           | https://search.yahoo.com/search?p=...                   | y
ask             | https://ask.com/web?q=...                               | a
ecosia          | https://www.ecosia.org/search?q=...                     | eco
wolframalpha    | https://www.wolframalpha.com/input/?i=...               | wa
wikipedia       | https://en.wikipedia.org/wiki/Special:Search?search=... | wp
reddit          | https://www.reddit.com/search/?q=...                    | r
quora           | https://www.quora.com/search?q=...                      | q
---------------------------------------------------------------------------------------

category: linux
--------------------------------------
engine          | url                                                              | alias
----------------------------------------------------------------------------------------------
archwiki        | https://wiki.archlinux.org/index.php?search=...                  | aw
ubuntuwiki      | https://help.ubuntu.com/community/Search?action=search&value=... | uw
gentoowiki      | https://wiki.gentoo.org/index.php?search=...                     | gw
centoswiki      | https://wiki.centos.org/action/fullsearch/?value=...             | cw
debianwiki      | https://wiki.debian.org/FrontPage?action=fullsearch&value=...    | dw
redhat          | https://access.redhat.com/site/search/site/...                   | rh
slackdocs       | https://docs.slackware.com/start?do=search&id=...                | sd
----------------------------------------------------------------------------------------------

category: packages
--------------------------------------
engine          | url                                          | alias
-----------------------------------------------------------------------------
npm             | https://www.npmjs.com/search?q=...           | np
pypi            | https://pypi.org/search/?q=...               | pyp
dockerhub       | https://hub.docker.com/search?q=...          | dh
cargo           | https://crates.io/search?q=...               | cr
rubygems        | https://rubygems.org/search?query=...        | rg
maven           | https://mvnrepository.com/search?q=...       | mvn
packagist       | https://packagist.org/search/?q=...          | pg
nuget           | https://www.nuget.org/packages?q=...         | ng
aur             | https://aur.archlinux.org/packages?K=...     | aur
--------------------------------------

category: development
--------------------------------------
engine          | url                                          | alias
---------------------------------------------------------------------------
github          | https://github.com/search?q=...              | gh
gitlab          | https://gitlab.com/search?search=...         | gl
bitbucket       | https://bitbucket.org/repo/all?name=...      | bb
stackoverflow   | https://stackoverflow.com/search?q=...       | so
stackexchange   | https://stackexchange.com/search?q=...       | se
devto           | https://dev.to/search?q=...                  | dev
medium          | https://medium.com/search?q=...              | m
---------------------------------------------------------------------------

category: documentation
--------------------------------------
engine          | url                                          | alias
---------------------------------------------------------------------------
mozilla         | https://developer.mozilla.org/search?q=...   | mdn
devdocs         | https://devdocs.io/#q=...                    | dd
techdocs        | https://techdocs.org/search/?query=...       | td
vscodedoc       | https://code.visualstudio.com/docs?q=...     | vsc
python          | https://www.python.org/search/?q=...         | py
numpy           | https://numpy.org/search.html?q=...          | npy
pandas          | https://pandas.pydata.org/search.html?q=...  | pds
---------------------------------------------------------------------------

category: ai
--------------------------------------
engine          | url                                          | alias
----------------------------------------------------------------------------
chatgpt         | https://chatgpt.com?q=...                    | gpt
mistral         | https://chat.mistral.ai/chat?q=...           | mst
iaskai          | https://iask.ai/search?q=...                 | iask
phind           | https://www.phind.com/search?q=...           | ph
perplexity      | https://www.perplexity.ai/?q=...             | px
----------------------------------------------------------------------------
```

# Related Projects

* [surfraw](https://gitlab.com/surfraw/Surfraw): a solution for searching in a lot of search engines. Written in `Perl` following `POSIX` standards.
* [s-search](https://github.com/zquestz/s): same scope of `web`, but written in `Go`.
* [googler](https://github.com/jarun/googler): complete solution for searching in Google from a terminal emulator, with color outputs, auto completion, etc. Written in `Python`.
* [ddg](https://github.com/jarun/ddgr): similar to `googler`, but for the DuckDuckGo engine. Also written in `Python`. 
* [googliser](https://github.com/teracow/googliser): to search and download images from Google. Written in `Bash`.

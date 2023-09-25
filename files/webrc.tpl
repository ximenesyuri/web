#! /bin/bash

# SEARCH ENGINES
    declare -A WEB_search_engine
    WEB_search_engine["duckduckgo"]="duckduckgo"
    WEB_search_engine["google"]="google"
    WEB_search_engine["bing"]="bing"


    declare -A WEB_search_engine_base
    WEB_search_engine_base["duckduckgo"]="https://duckduckgo.com"
    WEB_search_engine_base["google"]="https://google.com/search"
    WEB_search_engine_base["bing"]="https://bing.com/search"

# PROTOCOLS
    declare -a WEB_protocols
    WEB_protocol[0]="http"
    WEB_protocol[1]="htpps"
    WEB_protocol[2]="ftp"
    WEB_protocol[3]="ssh"
    WEB_protocol[4]="file"

# DEFAULT BROWSER AND ENGINE
    WEB_BROWSER="firefox"
    WEB_ENGINE="google"


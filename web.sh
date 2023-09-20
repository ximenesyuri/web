#! /bin/bash

# WEB FUNCTION
function web(){
## Includes
    source ${BASH_SOURCE%/*}/pkgfile
    source $PKG_install_dir/config/browsers
    if [[ -f "$PKG_install_dir/config/config" ]]; then
       source $PKG_install_dir/config/config
        has_config="ok"
       else
        echo "error: A configuration file was not identified."
        echo "Try:"
        echo "* \"web --template\" to create it from a template;"
        echo "* \"web --config\" to generate it with the help of a TUI interface."
        has_config=""
    fi
## Auxiliary Data
    declare -a WEB_options
    WEB_options[0]="-s"
    WEB_options[1]="--search" 
    WEB_options[2]="-c"
    WEB_options[3]="--config"
    WEB_options[4]="-cfg"
    WEB_options[5]="-h"
    WEB_options[6]="--help"
    WEB_options[7]="-u"
    WEB_options[8]="--url"
    WEB_options[9]="-url"
    WEB_options[10]="-a"
    WEB_options[11]="-add"
    WEB_options[12]="--add"
    WEB_options[13]="-b"
    WEB_options[14]="--bookmark"
    WEB_options[15]="-l"
    WEB_options[16]="--list"
    WEB_options[17]="-r"
    WEB_options[18]="--remove"
    WEB_options[19]="--browser"
    WEB_options[20]="-brw"
    WEB_options[21]="--brw"
    WEB_options[22]="--browsers"
    WEB_options[23]="-t"
    WEB_options[24]="-tpl"
    WEB_options[25]="--tpl"
    WEB_options[26]="--template"
    WEB_options[27]="-p"
    WEB_options[28]="--protocol"
    WEB_options[29]="--protocols"

    declare -a WEB_no
    WEB_no[0]="no"
    WEB_no[1]="n"
    WEB_no[2]="No"
    WEB_no[3]="N"
    WEB_no[4]="NO"
    declare -a WEB_yes
    WEB_yes[0]="yes"
    WEB_yes[1]="y"
    WEB_yes[2]="Yes"
    WEB_yes[3]="Y"
    WEB_yes[4]="YES"

    declare -a WEB_dash_browser
    declare -a WEB_dash_dash_browser
    for i in ${!WEB_browser[@]}; do
        WEB_dash_browser[$i]="-${WEB_browser[$i]}"
        WEB_dash_dash_browser[$i]="--${web_browser[$i]}"
    done

    declare -a WEB_dash_search_engine
    declare -a WEB_dash_dash_search_engine
    for i in ${!WEB_search_engine[@]}; do
        WEB_dash_search_engine[$i]="-${WEB_search_engine[$i]}"
        WEB_dash_dash_search_engine[$i]="--${WEB_search_engine[$i]}"
    done

    declare -a WEB_bookmarks
        WEB_bookmarks=()
        while IFS= read -r line; do
            string="$line"
            name=${string%=*}
            WEB_bookmarks+=("$name")
        done < $PKG_install_dir/files/bookmarks

    WEB_error="error: option not defined for \"web()\" function."

## Auxiliary Functions
    function WEB_list_bookmark(){
        if [[ ! -s $PKG_install_dir/files/bookmarks ]]; then
            echo "There is none saved bookmark."
        else
            echo "The following is the list of your bookmark names with corresponding url:"
            while IFS= read -r line; do
                string="$line"
                name=${string%=*}
                url=${string##*=}
                echo "* $name = $url"
            done < $PKG_install_dir/files/bookmarks
        fi
    }
    function WEB_list_browser(){
        echo "The following is the list of configured browsers:"
            for i in ${!WEB_browser[@]}; do
                echo "* ${WEB_browser[$i]}"
            done
    }
    function WEB_list_search_engine(){
        echo "The following is the list of configured search engines:"
            for engine in ${!WEB_search_engine[@]}; do
                echo "* ${WEB_search_engine[$engine]}=${WEB_search_engine_base[$engine]}"
            done
    }
    function WEB_list_protocol(){
        echo "The following is the list of configured protocols:"
            for i in ${!WEB_protocol[@]}; do
                echo "* ${WEB_protocol[$i]}"
            done
    }
    function WEB_bookmark_add(){
        if [[ -z "$1" ]]; then
            read -e -r -p "Enter new bookmark name: " name
            read -e -r -p "Enter bookmark \"$name\" url: " url
            bookmark="$name=$url"
            echo $bookmark >> $PKG_install_dir/files/bookmarks
            echo "A new bookmark was added." 
        elif  [[ "${WEB_bookmarks[@]}" =~ "$1" ]]; then
            echo "error: There already exists a bookmark named \"$1\"."
        else
            if [[ -n "$2" ]]; then
                for i in ${!WEB_protocol[@]}; do
                    protocol=${WEB_protocol[$i]}
                    if [[ $2 =~ "^$protocol?://" ]]; then
                        bookmark="$1=$2"
                        echo $bookmark >> $PKG_install_dir/files/bookmarks
                        has_protocol="ok"
                    else
                        has_protocol=""
                    fi
                done
                if [[ -z "$has_protocol" ]]; then
                    echo "error: The url \"$2\" does not follow a valid protocol."
                fi
            else
                echo "error: Please, enter a nonempty url."
            fi
        fi
    }
    function WEB_bookmark_open(){
        while IFS= read -r line; do
            string="$line"
            name=${string%=*}
            url=${string##*=}
            if [[ "$1" == "$name" ]]; then
                WEB_${WEB_BROWSER}_browser_function $url
                var="ok"
                break
            else
                var=""
            fi
        done < $PKG_install_dir/files/bookmarks
        if [[ -z "$var" ]]; then
            echo "error: There is no bookmark with name \"$1\"."
        fi
    }
    function WEB_bookmark_remove_core(){
        while IFS= read -r line; do
            string="$line"
            name=${string%=*}
            url=${string##*=}
            if [[ "$1" == "$name" ]]; then
                sed -i "/$1/d" $PKG_install_dir/files/bookmarks
                var="ok"
                break
            else
                var=""   
            fi
        done < $PKG_install_dir/files/bookmarks
        if [[ -z "$var" ]]; then
            echo "ERROR. There is no bookmark with name \"$1\"."
        fi           
    }
    function WEB_bookmark_remove(){
        if [[ -z $1 ]]; then
            WEB_list_bookmark
            read -e -r -p "Enter the bookmark name to remove: " bookmark_name
            if  [[ ${WEB_bookmarks[@]} =~ "$bookmark_name" ]]; then
                WEB_bookmark_remove_core $bookmark_name
            else
                echo "error: There is no bookmark named \"$bookmark_name\"."
            fi
        else
            if  [[ ${WEB_bookmarks[@]} =~ "$1" ]]; then
                WEB_bookmark_remove_core $1
            else
                echo "error: There is no bookmark named \"1\"."
            fi
        fi
    }
    for i in ${!WEB_browser[@]}; do
        if [[ ${WEB_no[@]} =~ "${WEB_browser_is_term_based[$i]}" ]]; then
            eval "function WEB_${i}_browser_function(){
                ${WEB_browser_cmd[$i]} \$1 & disown && exit
            }"
        elif [[ ${WEB_yes[@]} =~ "${WEB_browser_is_term_based[$i]}" ]]; then
            eval "function WEB_${i}_browser_function(){
                ${WEB_browser_cmd[$i]} \$1
            }"
        fi
    done       
    for i in ${!WEB_search_engine[@]}; do 
        eval "function WEB_${i}_search_engine_function(){
            term=\${1// /+}
            search=${WEB_search_engine_base[$i]}?q=\$term
        }"
    done

## Web Function Properly
    if [[ -z $1 ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        read -e -r -p "Url to open in $WEB_BROWSER: " term
        WEB_${WEB_BROWSER}_browser_function "$term"
    elif [[ "$1" == "-c" ]] || [[ "$1" == "--config" ]] || [[ "$1" == "-cfg" ]]; then
        sh $PKG_install_dir/config/config
    elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        cat $PKG_install_dir/config/help.txt
    elif [[ "$1" == "-t" ]] || [[ "$1" == "--template" ]]; then
        if [[ -f "$PKG_install_dir/config/config" ]]; then
            echo "There already exists a configuration file."
            read -p -r "> " replace_config
            while :
            do
                echo "Want to replace it by a template? (y/n)"
                if [[ "$replace_config" == "yes" ]] || [[ "$replace_config" == "y" ]]; then
                    cp $PKG_install_dir/files/config $PKG_install_dir/config/config
                    break
                elif [[ "$replace_config" == "no" ]] || [[ "$replace_config" == "n" ]]; then
                    Aborting...
                    break
                else
                    echo "Please, write y/yes or n/no."
                    continue
                fi
            done
        else
            cp $PKG_install_dir/files/config $PKG_install_dir/config/config
            echo "A template for the configuration file was created."
        fi
    elif [[ "$1" == "-brw" ]] ||
         [[ "$1" == "--brw" ]] ||
         [[ "$1" == "--browsers" ]] || 
         [[ "$1" == "--browser" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
    elif [[ "$1" == "-a" ]] || [[ "$1" == "--add" ]] || [[ "$1" == "-add" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        WEB_bookmark_add $2 $3
    elif [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        WEB_bookmark_remove $2
### list mode
    elif [[ "$1" == "-l" ]] || [[ "$1" == "--list" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z "$2" ]]; then
            echo "What do you want to list?"
            echo "1. bookmarks;"
            echo "2. browsers;"
            echo "3. search engines;"
            echo "4. protocols."
            while :
            do
                read -r -p "> " which_list
                if [[ "$which_list" == "1" ]] || [[ "$which_list" == "1." ]]; then
                    WEB_list_bookmark
                    break
                elif [[ "$which_list" == "2" ]] || [[ "$which_list" == "2." ]]; then
                    WEB_list_browser
                    break
                elif [[ "$which_list" == "3" ]] || [[ "$which_list" == "3." ]]; then
                    WEB_list_search_engine
                    break
                elif [[ "$which_list" == "4" ]] || [[ "$which_list" == "4." ]]; then
                    WEB_list_protocol
                    break
                else
                    echo "Please, write 1, 2, 3 or 4."
                    continue
                fi
            done
        elif [[ "$2" == "-b" ]] || [[ "$2" == "--bookmark" ]]; then
            WEB_list_bookmark
        elif [[ "$2" == "-brw" ]] || [[ "$2" == "--browser" ]] || [[ "$2" == "--browsers" ]]; then
            WEB_list_browser
        elif [[ "$2" == "-p" ]] || [[ "$2" == "--protocol" ]] || [[ "$2" == "--protocols" ]]; then
            WEB_list_protocol
        fi
### bookmark mode
    elif [[ "$1" == "-b" ]] || [[ "$1" == "--bookmark" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z $2 ]]; then
            WEB_list_bookmark
            read -e -r -p "Enter the bookmark name to open: " bookmark_name
            if [[ -z "$bookmark_name" ]]; then
                return 1
            elif  [[ ${WEB_bookmarks[@]} =~ "$bookmark_name" ]]; then
                WEB_bookmark_open "$bookmark_name"
            else
                echo "error: There is no bookmark named \"$bookmark_name\"."
            fi
        elif [[ "$2" == "-a" ]] || [[ "$2" == "--add" ]]; then
            WEB_bookmark_add $3 $4
        elif [[ "$2" == "-r" ]] || [[ "$2" == "--remove" ]]; then
            WEB_bookmark_remove $3
        elif [[ "$2" == "-l" ]] || [[ "$2" == "--list" ]]; then
            WEB_list_bookmark
        elif [[ "${WEB_bookmarks[@]}" =~ "$2" ]]; then
                WEB_bookmark_open "$2"
        else
            echo "error: There is no bookmark named \"$2\"."
        fi
### search mode
    elif [[ "$1" == "-s" ]] || [[ "$1" == "--search" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        if [[ -z $2 ]]; then
            read -e -r -p "Search in ${WEB_ENGINE} for: " term
            WEB_${WEB_ENGINE}_search_engine_function "$term"
            WEB_${WEB_BROWSER}_browser_function $search
        elif [[ "$2" == "-l" ]] || [[ "$2" == "--list" ]]; then
            WEB_list_search_engine
        elif [[ ${WEB_dash_search_engine[@]} =~ $2 ]] ||
             [[ ${WEB_dash_dash_search_engine[@]} =~ $2 ]] &&
             [[ -z "$3" ]]; then
            var=${2//-/}
            read -e -r -p "Search in $var for: " term
            WEB_${var}_search_engine_function "$term"
            WEB_${WEB_BROWSER}_browser_function $search
        elif [[ ${WEB_dash_browser[@]} =~ $2 ]] ||
             [[ ${WEB_dash_dash_browser[@]} =~ $2 ]] &&
             [[ -z "$3" ]]; then
            var=${2//-/}
            read -e -r -p "Search in $var for: " term
            WEB_${WEB_ENGINE}_search_engine_function "$term"
            WEB_${var}_browser_function $search
        elif ([[ ${WEB_dash_search_engine[@]} =~ $2 ]] ||
             [[ ${WEB_dash_dash_search_engine[@]} =~ $2 ]]) &&
             ([[ ${WEB_dash_browser[@]} =~ $3 ]] ||
              [[ ${WEB_dash_dash_browser[@]} =~ $3 ]]) &&
              [[ -z "$4" ]]; then
            var_engine=${2//-/}
            var_browser=${3//-/}
            read -e -r -p "Search in $var_engine in $var_browser for: " term
            WEB_${var_engine}_search_engine_function "$term"
            WEB_${var_browser}_browser_function $search
        elif ([[ ${WEB_dash_search_engine[@]} =~ $3 ]] ||
              [[ ${WEB_dash_dash_search_engine[@]} =~ $3 ]]) &&
             ([[ ${WEB_dash_browser[@]} =~ $2 ]] ||
              [[ ${WEB_dash_dash_browser[@]} =~ $2 ]]) &&
              [[ -z "$4" ]]; then
            var_engine=${3//-/}
            var_browser=${2//-/}
            read -e -r -p "Search in $var_engine in $var_browser for: " term
            WEB_${var_engine}_search_engine_function "$term"
            WEB_${var_browser}_browser_function $search
        elif [[ ! "${WEB_dash_search_engine[@]}" =~ "$2" ]] && 
             [[ ! "${WEB_dash_dash_search_engine[@]}" =~ "$2" ]] &&
             [[ ! "${WEB_dash_browser[@]}" =~ "$2" ]] &&
             [[ ! "${WEB_dash_dash_browser[@]}" =~ "$2" ]]; then
            declare -a array
            array[0]=$2
            end=$(($#-2))
            for (( i=1; i<=$#; i++ ))
            do
                j=$(($i+2))
                array[$i]="${array[$i-1]} ${!j}"
            done
                var=${array[${end}]}
                var=${var// /+}
                WEB_${WEB_ENGINE}_search_engine_function "$var"
                WEB_${WEB_BROWSER}_browser_function $search
        elif  ([[ "${WEB_dash_browser[@]}" =~ "$2" ]] ||
               [[ "${WEB_dash_dash_browser[@]}" =~ "$2" ]]) &&
               [[ -n "$3" ]] &&
              ([[ ! "${WEB_dash_search_engine[@]}" =~ "$3" ]] ||
               [[ ! "${WEB_dash_dash_search_engine[@]}" =~ "$3" ]]); then
                declare -a array
                array[0]=$3
                end=$(($#-3))
                for (( i=1; i<=$#; i++ ))
                do
                    j=$(($i+3))
                    array[$i]="${array[$i-1]} ${!j}"
                done
                var=${array[${end}]}
                var=${var// /+}
                var_browser=${2//-/}
                WEB_${WEB_ENGINE}_search_engine_function "$var"
                WEB_${var_browser}_browser_function $searc
        elif  ([[ "${WEB_dash_search_engine[@]}" =~ "$2" ]] ||
               [[ "${WEB_dash_dash_search_engine[@]}" =~ "$2" ]]) &&
               [[ -n "$3" ]] &&
              ([[ ! "${WEB_dash_browser[@]}" =~ "$3" ]] ||
               [[ ! "${WEB_dash_dash_browser[@]}" =~ "$3" ]]); then
                declare -a array
                array[0]=$3
                end=$(($#-3))
                for (( i=1; i<=$#; i++ ))
                do
                    j=$(($i+3))
                    array[$i]="${array[$i-1]} ${!j}"
                done
                var=${array[${end}]}
                var=${var// /+}
                var_engine=${2//-/}
                WEB_${var_engine}_search_engine_function "$var"
                WEB_${WEB_BROWSER}_browser_function $search
        else
            echo "error: Wrong syntax or non configured browser or search engine."
        fi
### url mode
    elif ([[ "$1" == "-u" ]] || 
          [[ "$1" == "--url" ]] || 
          [[ "$1" == "-url" ]]) &&
          [[ -n "$2" ]] &&
          [[ -z "$3" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        WEB_${WEB_BROWSER}_browser_function $2
    elif [[ ! ${opt[@]} =~ "$1" ]] && [[ -z "$2" ]]; then
        if [[ -z "$has_config" ]]; then
            return 1
        fi
        WEB_${WEB_BROWSER}_browser_function $1
    else
### error
        echo $WEB_error
    fi
}

# ALIASES
    alias webs="web -s"
    alias webb="web -b"
    alias weba="web -a"
    alias webc="web -c"
    alias webh="web -h"
    alias webl="web -l"



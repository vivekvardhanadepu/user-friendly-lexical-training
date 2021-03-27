#!/usr/bin/bash

# version_comp () {
#     if [[ $1 == $2 ]]
#     then
#         return 0
#     fi
#     # printf "what the yell\n"
#     local IFS=.
#     local i ver1=($1) ver2=($2)
#     # fill empty fields in ver1 with zeros
#     for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
#     do
#         ver1[i]=0
#     done
#     for ((i=0; i<${#ver1[@]}; i++))
#     do
#         if [[ -z ${ver2[i]} ]]
#         then
#             # fill empty fields in ver2 with zeros
#             ver2[i]=0
#         fi
#         if ((10#${ver1[i]} > 10#${ver2[i]}))
#         then
#             return 1
#         fi
#         if ((10#${ver1[i]} < 10#${ver2[i]}))
#         then
#             return 2
#         fi
#     done
#     return 0
# }

parse_config_vars(){
    [[ -f $1 ]] || { echo "$1 is not a file." >&2;return 1;}
    local line key value entry_regex nr=0 key1=python key2=apertium
    local key3=lttoolbox key4=apertium-lex-tools
    entry_regex="^[[:blank:]]*([[:alnum:]_-]+)[[:blank:]]*=[[:blank:]]*('[^']+'|\"[^\"]+\"|[^#]+)"

    while read -r line
    do
        # counting lines
        (( ++nr ))

        # ignore empty lines and comments
        [[ -z "$line" || "$line" = '#'* ]] && continue

        # syntax check
        [[ !($line =~ $entry_regex) ]] && { printf "syntax error in line $nr \n"; return 1; }

        # extracting values
        key=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]#[\'\"]} # strip quotes
        value=${value%[\'\"]}
        value=${value%${value##*[![:blank:]]}} # strip trailing spaces
        
        # checking required pkgs
        case $key in
            $key1|$key2|$key3|$key4)
                version=$(dpkg -s $key | grep '^Version: ')
                # [[ -z "$version" ]] && { $(sudo apt install $key); }
                [[ !($version =~ ^Version:[[:blank:]]([0-9\.]+)[.]*) ]] && { printf "install $key >= $value\n"; }
                Version=${BASH_REMATCH[1]}
                [ "$value" != "`echo -e "$value\n$Version" | sort -V | head -n1`" ] && { printf "install $key >= $value\n"; }
                printf "\"$key\" present version is \"$Version\" \n";;
            *) printf "unknown key $key \n";;
        esac
        # printf '%s' "${key}"
        # printf '=%s\n' "${value}"
    done < <(grep "" $1)

    return 0;
}

parse_config_vars parser_test.toml

# # 2nd parser
# config_file="parser_test2.toml"

# declare key1=foo    # define a default value
# declare -a key2

# parse_config_file() {
#   local line key val nr=0
#   local config_err=()
#   while IFS= read -r line; do
#     # keep a running count of which line we're on
#     (( ++nr ))
#     # ignore empty lines and lines starting with a #
#     [[ -z "$line" || "$line" = '#'* ]] && continue
#     read -r key <<< "${line%% *}"   # grabs the first word and strips trailing whitespace
#     read -r val <<< "${line%#* }"    # grabs everything after the first word and strips trailing whitespace
#     if [[ -z "$val" ]]; then
#       # store errors in an array
#       config_err+=( "missing value for \"$key\" in config file on line $nr" )
#       continue
#     fi
#     printf 'key is "%s"\n' "$key"
#     printf 'key contains "%s"\n' "$value"
    # case "$key" in    # here it actually checks for keys and stores their values
    #   key1)
    #     # test to see if a key matches a specific set of values
    #     if [[ $val =~ ^foo$|^bar$|^baz$ ]]; then
    #       key1="$val"
    #     else
    #       # more error handling
    #       config_err+=( "unknown value \"$val\" for \"$key\" in config file on line $nr" )
    #       config_err+=( '  must be "foo" "bar" or "baz"' )
    #     fi ;;
    #   key2) 
    #   key2+=( "$val" ) ;; # allow multiple keys stored in an array
    #   *) config_err+=( "unknown key \"$key\" in config file on line $nr" )
    # esac
#   done
#   if (( ${#config_err[@]} > 0 )); then
#     printf '%s\n' 'there were errors parsing the config file:' "${config_err[@]}"
#   fi
# }

# [[ -s "$config_file" ]] && parse_config_file < "$config_file"
#!/usr/bin/bash

parse_config_vars(){
    [[ -f $1 ]] || { echo "$1 is not a file." >&2;return 1;}
    local line key value entry_regex
    entry_regex="^[[:blank:]]*([[:alnum:]_-]+)[[:blank:]]*=[[:blank:]]*('[^']+'|\"[^\"]+\"|[^#]+)"
    while read -r line
    do
        [[ -n $line ]] || continue
        [[ $line =~ $entry_regex ]] || continue
        key=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]#[\'\"]} # strip quotes
        value=${value%[\'\"]}
        value=${value%${value##*[![:blank:]]}} # strip trailing spaces
        printf '%s' "${key}"
        printf '=%s\n' "${value}"
    done < "$1"
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
#     case "$key" in    # here it actually checks for keys and stores their values
#       key1)
#         # test to see if a key matches a specific set of values
#         if [[ $val =~ ^foo$|^bar$|^baz$ ]]; then
#           key1="$val"
#         else
#           # more error handling
#           config_err+=( "unknown value \"$val\" for \"$key\" in config file on line $nr" )
#           config_err+=( '  must be "foo" "bar" or "baz"' )
#         fi ;;
#       key2) 
#       key2+=( "$val" ) ;; # allow multiple keys stored in an array
#       *) config_err+=( "unknown key \"$key\" in config file on line $nr" )
#     esac
#   done
#   if (( ${#config_err[@]} > 0 )); then
#     printf '%s\n' 'there were errors parsing the config file:' "${config_err[@]}"
#   fi
# }

# [[ -s "$config_file" ]] && parse_config_file < "$config_file"
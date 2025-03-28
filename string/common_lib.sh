#!/bin/bash
source ./../shared_path.sh

func_shared_path()
{
    echo " Using shared path: $shared_path"
}


# Pattern matching
# @file_path="/home/thonglt/src/shell_script/file_system/unittest/main.sh"
# @filter_name "*.sh"

match() {
    local file_path="${1}";
    local filter_name="${2}";

    file_name=$(echo $file_path | grep -o '[^/]*$')
    rexp="${filter_name//\*/.*\\}"
    echo "$file_name" | grep -E "$rexp"
}

match_with_file() {
    local file_path="${1}";
    local filter_name="${2}";

    file_name=$(basename "$file_path")
    rexp="${filter_name//\*/.*\\}"
    echo "$file_name" | grep -E "$rexp"
}
get_length()
{
  # Take the input string as the first argument
  local string="${1}";
   echo "${#string}" # Use ${#string} to get the length of the string

}
# counter=0
# string="This is a sample string"
# for word in $string; do
#     echo $word
#     let counter=counter+1
# done
# if [ $counter -eq  5 ]; then
#     echo "Passed"
# else
#     echo ""
# fi



# count the number of characters
# echo -n "your_string_here" | wc -m

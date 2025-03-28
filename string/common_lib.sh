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
  local string="${1}";  # Take the input string as the first argument
  echo "${#string}" # Use ${#string} to get the length of the string
}

count_words()
 {
  local string="$1" # Take the input string as the first argument
  echo "$string" | wc -w # Use wc -w to count the words in the string
}
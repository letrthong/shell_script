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

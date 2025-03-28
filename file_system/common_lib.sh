#!/bin/bash
source ./../shared_path.sh

func_shared_path()
{
    echo " Using shared path: $shared_path"

    #Suppress the output of echo
    echo "This will not be displayed" > /dev/null
}


#
# Usage: "exist_file "file_path"
# @return 1 exist  file
#         0 not found
#
exist_file()
{
    local file_path="${1}";
    local return_code=0
    if [ -f "$file_path" ]; then
        return_code=1
    fi
    echo $return_code
}

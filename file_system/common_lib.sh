#!/bin/bash
source ./../shared_path.sh

func_shared_path()
{
    echo " Using shared path: $shared_path"

    #Suppress the output of echo
    echo "This will not be displayed" > /dev/null
}


#
# Usage: exist_file "file_path"
# @return RET_FILE_EXIST exist  file
#         RET_FILE_NOT_EXIST  not found
#
exist_file()
{
    local file_path="${1}";
    local return_code=$RET_FILE_NOT_EXIST
    if [ -f "$file_path" ]; then
        return_code=$RET_FILE_EXIST
    fi
    echo $return_code
}

read_file()
{
    local file_path="${1}";
    data=""
    while IFS= read -r line
    do
      #echo "$line"
	  data="${data}${line}"
    done < "$file_path"
    echo $data

}

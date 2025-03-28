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

write_file()
{
    local file_path="${1}";
    local data="${2}";
    # Create the file and add some content
    echo "$data" > $file_path

    # Verify the file creation
    if [ -f "$file_path" ]; then
        echo "File $file_path created successfully."
    else
        echo "Failed to create file $file_path."
    fi
}

remount_disk()
{
  mount -o remount,rw /
  #mount -o remount,ro /
  # set -e
}

# show_exec mount -o remount,rw /
# print_exec() {
#     echo "+ $@"
#     "$@"
# }


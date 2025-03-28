#!/bin/bash
source ./../common_lib.sh

test_exist_file()
{
  result=$(exist_file "./main.sh")
  assertEquals "$RET_FILE_EXIST" "$result"
}

test_exist_file_not()
{
  result=$(exist_file "./abc.sh")
  assertEquals "$RET_FILE_NOT_EXIST" "$result"
}


test_exist_file_if()
{
  result=$(exist_file "./main.sh")
  if [ "$result" -eq $RET_FILE_EXIST ]; then
    echo "result is equal to 1"
  else
    echo "result is NOT equal to 1"
  fi
  assertEquals "$RET_FILE_EXIST" "$result"
}
 
 . ./../../shunit2/shunit2

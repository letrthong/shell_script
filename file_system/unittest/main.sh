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
 

test_exist_write_read_file()
{ 
  data="1234 4567"
  file_name="./test"

  write_file "$file_name"  "$data"

  result=$(read_file "$file_name")
  echo "test_exist_read_file $result"

  # Compare the strings
  if [ "$data" = "$result" ]; then
    echo "The strings are equal."
  else
    echo "The strings are not equal."
  fi
  assertEquals "0" "0"
}


 . ./../../shunit2/shunit2

#!/bin/bash
source ./../common_lib.sh

test_exist_file()
{
  result=$(exist_file "./main.sh")
  assertEquals "1" "$result"
}

test_exist_file_not()
{
  result=$(exist_file "./abc.sh")
  assertEquals "0" "$result"
}


test_exist_file_if()
{
  result=$(exist_file "./main.sh")
  if [ "$result" -eq 1 ]; then
    echo "result is equal to 1"
  else
    echo "result is NOT equal to 1"
  fi
  assertEquals "1" "$result"
}
 
 . ./../../shunit2/shunit2

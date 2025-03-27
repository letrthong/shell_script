#!/bin/bash
source ./../common_lib.sh

test_func()
{
  func_shared_path
  assertEquals "1" "1"
}

test_match()
{
  file_path="/home/thonglt/src/shell_script/file_system/unittest/main.sh"
  filter_name="*.sh"
  match "$file_path" "$filter_name"
  result=$?
  echo  "test_match result=$result"
  assertEquals "0" "$result"
}

test_match_not()
{
  file_path="/home/thonglt/src/shell_script/file_system/unittest/main.sh"
  filter_name="*.txt"
  match "$file_path" "$filter_name"
  result=$?
  echo  "test_match result=$result"
  assertNotEquals "0" "$result"
}

 . ./../../shunit2/shunit2

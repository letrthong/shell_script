#!/bin/bash
source ./../common_lib.sh

test_func()
{
  func_echo
  func_parameters  value1 value2
  assertEquals "1" "1"
}

test_add()
{
    result=$(func_add 2 3)
    assertEquals "5" "$result"
}

test_subtract()
 {
    result=$(func_subtract 5 3)
    assertEquals "2" "$result"
}


test_return_code_success()
{
    func_return 5
    return_code=$?
    echo  "test_return_code_success return_code=$return_code"
    assertEquals  "0"   "$return_code"
}

test_return_code_failure()
{
    func_return -1
    return_code=$?
    echo  "test_return_code_failure return_code=$return_code"
    assertEquals  "1"   "$return_code"
}



 . ./../../shunit2/shunit2

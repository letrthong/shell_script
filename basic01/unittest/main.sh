#!/bin/bash
source ./../functions.sh

echo "Calling my_function from main.sh"
my_function


my_function_paramters  value1 value2



testAdd() {
    result=$(add 2 3)
    assertEquals "5" "$result"
}



testSubtract() {
    result=$(subtract 5 3)
    assertEquals "2" "$result"
   # assertEquals "1" "$result"
}


testSubtractxxx() {
    my_function_return 5
    status_code=$?
    echo  "status_code=$status_code"

    assertEquals  "0"   "$status_code" 
}


 
 . ./../../shunit2/shunit2

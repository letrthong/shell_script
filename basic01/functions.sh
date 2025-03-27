#!/bin/bash

my_function() {
    echo "This is my_function from functions.sh"
}


my_function_paramters() {
    param1=$1
    param2=$2
    echo "Parameter 1: $param1"
    echo "Parameter 2: $param2"
}



add() {
    echo $(($1 + $2))
}

subtract() {
    echo $(($1 - $2))
}



my_function_return() {
    if [ "$1" -gt 0 ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

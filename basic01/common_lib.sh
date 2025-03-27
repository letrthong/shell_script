#!/bin/bash

func_echo()
{
    echo "This is my_function from func_eho.sh"
}

func_parameters()
{
    param1=$1
    param2=$2
    echo "Parameter 1: $param1"
    echo "Parameter 2: $param2"
}

func_add()
{
    echo $(($1 + $2))
}

func_subtract()
{
    echo $(($1 - $2))
}

func_return()
{
    # https://tldp.org/LDP/abs/html/comparison-ops.html
    # is greater than
    if [ "$1" -gt 0 ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

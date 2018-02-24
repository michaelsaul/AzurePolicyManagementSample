#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2018 Michael Saul
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#Script Name: 01-addServiceAccount.sh
#Author: Michael Saul
#Version 0.1
#Description:
#  

OPTIND=1

#Initialize Variables
subscription_id=""
account=""
role=""

usage="usage: `basename $0` -s subscription_id -a account -r role [-h]"

show_help(){
    printf "
Command
  `basename $0`: Set an account with the specified role on a given subscription.

  ${usage}

Arguments
  -s [Required]: Name or ID of subscription
  -a [Required]: Represent a user, group, or service principal. supported format:
     object id, user sign-in name, or service principal name.
  -r [Required]: Role name or id.  
  
  -h Prints this message.
  
"
}

if ( ! getopts "hs:a:r:" opt ); then
    echo ${usage}
    exit 1
fi

while getopts "hs:a:r:" opt; do
    case ${opt} in
    s) subscription_id=$OPTARG
        ;;
    a) account=$OPTARG
        ;;
    r) role=$OPTARG
        ;;
    h|\?)
        show_help
        exit 0
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" == "--" ] && shift

az account set -s ${subscription_id}
az role assignment create --assignee ${account} --role ${role}
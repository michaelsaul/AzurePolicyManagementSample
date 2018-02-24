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

#Script Name: 02b-createPolicySet.sh
#Author: Michael Saul
#Version 0.1
#Description:
#  

OPTIND=1

#Initialize Variables
subscription_id=""
policy_set_file=""
policy_set_name=""

usage="usage: $(basename $0) -s subscription_id -f policy_set_file -n policy_set_name [-h]"

show_help(){
    printf "
Command
  $(basename $0): Create a new policy set definition.

  ${usage}

Arguments
  -s [Required]: Name or ID of subscription
  -f [Required]: Policy definitions in JSON format.
  -n [Required]: Name of the new policy set definition.
    
  -h Prints this message.
  
  "
}

if ( ! getopts "hs:f:n:" opt ); then
    echo ${usage}
    exit 0
fi

while getopts "hs:f:n:" opt; do
    case ${opt} in
    s) subscription_id=$OPTARG
        ;;
    f) policy_set_file=$OPTARG
        ;;
    n) policy_set_name=$OPTARG
        ;;
    h|\?)
        show_help
        exit 0
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" == "--" ] && shift

#Initialize the rest of the variables
policy_set_display_name=$(jq -cr ".displayName" ${policy_set_file})
policy_set_description=$(jq -cr ".description" ${policy_set_file})
policy_set_definitions=$(jq -cr ".policyDefinitions" ${policy_set_file})

az account set -s ${subscription_id}
az policy set-definition create \
  --name "${policy_set_name}" \
  --definitions "${policy_set_definitions}" \
  --description "${policy_set_description}" \
  --display-name "${policy_set_display_name}"
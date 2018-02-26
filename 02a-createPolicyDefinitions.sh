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

#Script Name: 02a-createPoliciyDefinitions.sh
#Author: Michael Saul
#Version 0.2
#Description:
#  

OPTIND=1

#Initialize Variables
subscription_id=""
policy_file=""
policy_name=""

usage="usage: $(basename $0) -s subscription_id -f policy_file -n policy_name [-h]"

show_help(){
    printf "
Command
  $(basename $0): Create a new policy definition.

  ${usage}

Arguments
  -s [Required]: Name or ID of subscription
  -f [Required]: JSON formatted policy file. Must include relevant name, desription, policyRule, and parameters.
  -n [Required]: Name of the new policy definition.
    
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
    f) policy_file=$OPTARG
        ;;
    n) policy_name=$OPTARG
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
policy_display_name=$(jq -cr ".displayName" ${policy_file})
policy_description=$(jq -cr ".description" ${policy_file})
policy_parameters=$(jq -cr ".parameters" ${policy_file})
policy_rules=$(jq -cr ".policyRule" ${policy_file})

az account set -s ${subscription_id}
az policy definition create \
  --name "${policy_name}" \
  --description "${policy_description}" \
  --display-name "${policy_display_name}" \
  --params "${policy_parameters}" \
  --rules "${policy_rules}"
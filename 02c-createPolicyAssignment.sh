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

#Script Name: 02c-createPolicyAssignment.sh
#Author: Michael Saul
#Version 0.3
#Description:
#  

OPTIND=1

#Initialize Variables
subscription_id=""
policy_assignment_name=""
policy_set_definition=""
assignment_scope=""

usage="usage: $(basename $0) -s subscription_id -n policy_assignment_name -p policy_set_definition [-g resource_group_name] [-h]"

show_help(){
    printf "
Command
  $(basename $0): Create a new policy set definition.

  ${usage}

Arguments
  -s [Required]: Name or ID of subscription.
  -n [Required]: Name of the new assignment.
  -p [Required]: Name or id of the policy set definition.
  -g The resource group where the policy will be applied.
    
  -h Prints this message.
  
  "
}

if ( ! getopts "s:n:p:h" opt ); then
    echo ${usage}
    exit 1
fi

while getopts "s:n:p:g:h" opt; do
    case ${opt} in
    s) subscription_id=$OPTARG
        ;;
    n) policy_assignment_name=$OPTARG
        ;;
    p) policy_set_definition=$OPTARG
        ;;
    g) assignment_scope="/subscriptions/${subscription_id}/resourceGroups/${OPTARG}"
        ;;
    h|\?)
        show_help
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" == "--" ] && shift

if [[ ${assignment_scope} == "" ]]; then
    assignment_scope="/subscriptions/${subscription_id}"
fi

az account set -s ${subscription_id}
az policy assignment create \
 --name ${policy_assignment_name} \
 --policy-set-definition ${policy_set_definition} \
 --scope ${assignment_scope}
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

#Script Name: 00-scaffoldSubscription.sh
#Author: Michael Saul
#Version 0.1
#Description:
#  

OPTIND=1

#Initialize Variables
config_file=""

usage="usage: `basename $0` -f config_file [-h]"

show_help(){
    printf "
Command
  `basename $0`: Scaffold an Azure subscription with policies and a designated account for RBAC.

  ${usage}

Arguments
  -f JSON formatted configuration file.
  
  -h Prints this message.

"
}

if ( ! getopts "f:h" opt ); then
    echo ${usage}
    exit 1
fi

while getopts "hf:" opt; do
    case ${opt} in
    f) config_file=$OPTARG
        ;;
    h|\?)
        show_help
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" == "--" ] && shift

#Initialize more variables
subscription_id="$(jq -cr .subscriptionID ${config_file})"
# account_name="$(jq -cr .serviceAccount.accountName ${config_file})"
# account_role="$(jq -cr .serviceAccount.role ${config_file})"
policy_file="$(jq -cr .policyDefinition[0].policyFile ${config_file})"
policy_name="$(jq -cr .policyDefinition[0].policyName ${config_file})"
policy_set_file="$(jq -cr .policySet.policySetFile ${config_file})"
policy_set_name="$(jq -cr .policySet.policySetName ${config_file})"
policy_assignment_name="$(jq -cr .policyAssignment.policyAssignmentName ${config_file})"
resource_group_name="$(jq -cr .policyAssignment.resourceGroup ${config_file})"

echo "Deleting account roles."
jq -c ".serviceAccount[]" ${config_file} | while IFS='' read results;do
        account_name=$(echo ${results} | jq -r .accountName)
        account_role=$(echo ${results} | jq -r .role)
        az role assignment delete --assignee ${account_name} --role ${account_role}
done

az policy assignment delete --name ${policy_assignment_name} --resource-group ${resource_group_name}
az policy set-definition delete --name ${policy_set_name}
az policy definition delete --name ${policy_name}
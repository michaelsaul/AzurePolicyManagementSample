# AzurePolicyManagementSample

## Content
- [Overview](README.md#overview)
- [Setting Up](README.md#setting_up)
- [ToDo](README.md#todo)

### Overview
This is a sample colelction of scripts that will aid in the deployment and scaffolding of an Azure Subscription.

### Setting Up
To make use of the scripts, simply download the repositry and execute the scripts in your bash environment. Please be sure to see the prerequitites below.

Use the config.json.sample as a template for a config.json file that contains all of your input parameters.

```bash
$ 00-scaffoldSubscription.sh -f config.json
```

Alternatively, all scripts shoudl be able to be run from the [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/).

#### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest)
- [jq](https://stedolan.github.io/jq/)

### ToDo
In the next step, I plan to add the following:
- Build the policy scripts to create _n_ number of policy definitions based on the configuration file.
- Createa an Azure function that will report violations of the policy as defined in the policy configuration file.

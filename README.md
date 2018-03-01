# AzurePolicyManagementSample

## Content
- [Overview](README.md#overview)
- [Setting Up](README.md#setting-up)
- [ToDo](README.md#todo)

### Overview
This is a sample collection of scripts that will aid in the configuration and scaffolding of an Azure Subscription.

For more information about scaffolding an Azure Subscription, pelase see the [Azure Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-subscription-governance).

### Setting Up

> Please be sure to see the [prerequisites](README.md#prerequisites) below.

To make use of the scripts, simply clone the repository, create your own config.json, and execute the scripts in your bash environment.

Use the provided config.json.sample as a template for a config.json file that contains all of your input parameters.

```bash
$ 00-scaffoldSubscription.sh -f config.json
```

Alternatively, all scripts have been tested and run successfully from [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/).

1. Log in to Azure Portal
2. Click the Cloud Shell icon

  ![Cloud Shell icon](https://docs.microsoft.com/en-us/azure/cloud-shell/media/overview/portal-launch-icon.png)

3. Choose Bash shell from the drop down

  ![Bash Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/media/overview/overview-bash-pic.png)

4. Execute the following:
```bash
$ cd clouddrive # Optional
$ git clone https://github.com/michaelsaul/AzurePolicyManagementSample.git
$ cd AzurePolicyManagementSample/
$ cp config.json.sample config.json
$ vi config.json # Make your edits accordingly.
$ ./00-scaffoldSubscription.sh -f config.json
```

#### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest)
- [jq](https://stedolan.github.io/jq/)

### ToDo
In the next step, I plan to add the following:
- Dynamically build a policy set-definition configuration from the policy definitons created from the config.json.
- Create an Azure Function that will report violations of the policy as defined in the policy configuration file.

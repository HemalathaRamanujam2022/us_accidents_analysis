## <ins>Create GCP resources using Terraform scripts</ins>

Change to the terraform directory under the parent folder.

```
~/infrastructure/terraform
```

Ensure that Terraform ("Infrastructure as a Code") tool is installed on
your machine. If not, install it using the script "setup_terraform.sh"
by invoking it from the setup directory under parent folder. This code will install
Terraform for Ubuntu/Debian systems. For other OS, please refer to the
official documentation of Terraform from here -
<https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>
```
setup_terraform.sh
```

Verify the installation using the command
```
terraform -version
```

Verify and update the following parameters in the "variables.tf" under
the above folder.

-  "credentials" -- You do not need to change this parameter as it has
    been set to the folder containing the access key for the service
    account. Ensure the file is available in the following location.
    ```
    ~/us_accidents_analysis/.keys/us_accidents_srvc_acct.json
    ```

-  "project" -- Set it to the name of the GCP project created

-  "region" -- Set it to the region you want to create the resources in

-  "zone" -- Set it to the region you want to create the VM in
  
Note: I tested the project with the following parameters for region and zone respectively -
asia-south1" and "asia-south1-a" .

Run the following commands in order and verify the outputs. The Terraform scripts will plan and create a 
GCP GCE instance (us-accidents-test-machine), a BigQuery dataset (us_accidents_bq) and a GCS bucket (us_accidents_gs) in
the region specified earlier.

```
terraform init
terraform plan --out=main.tfplan
terraform apply main.tfplan
```
If there are any issues in the above process, you can remove all the resources either created or 
in an unstable state using the below command and start over.
```
terraform destroy
```
Note: If you are not planning to move further along in running the
pipeline, please stop the VM instance ("us-accidents-test-machine") on
the GCP console, so that you do not incur charges. You can start it just
before running the Mage orchestration job on the GCP VM machine.

## <ins>Create Dataproc cluster</ins>
We also need to create a Google "Dataproc" cluster on the compute engine
to run the "Pyspark" job which will be executed from the Mage docker container.
Follow the instructions given below to create a "Dataproc" cluster on the
GCP console. You can find the screenshots [here](/static/mage/Dataproc_steps.pdf) .

1.  Add the following roles to the principal which will have principal name as
    <XXXXXXXXXXXX-compute@developer.gserviceaccount.com> where X stands for a digit.

-   Service Account User
-   Storage Admin
-   Storage Object Admin
-   Storage Object Creator

2.  Search for "Dataproc" service on the search box. Choose the option to create a dataproc cluster on compute engine.

3.  Under "Set up cluster" step, use the name
    "us-accidents-dataproc-cluster" for the cluster name. Choose the
    same region you used earlier. Choose the cluster as a single node
    machine. Leave all other as defaults as is.

4.  Under "Configure nodes", choose the series of the machine (N2) to
    what is mentioned below. You should change the machine type to
    "n2-standard-4" and the primary disk size to "30 GB" and leave all
    other defaults as is.

5.  Under "Customize cluster", uncheck the box "Internal IP only" and
    leave all other defaults as is.

Once you press "Create", a new data proc cluster with the specified will be created and running.

Note: If you are not planning to move further along in running the
pipeline, please stop the Dataproc cluster ("us-accidents-dataproc-cluster") on the GCP console, 
so that you do not incur charges. You can start it just before running the Mage
orchestration job.

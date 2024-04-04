# <ins>Mage ETL pipeline orchestration</ins>

We will be using Mage for orchestrating the ETL pipeline and DBT (Data
build tool) to create data warehouse tables in BigQuery and do
transformations and create summary tables which can be visualised on
Google Looker Studio. Pyspark and DBT scripts are integrated into the
Mage Docker container to render an end-to-end ETL pipeline.

## <ins>Clone the project repository</ins>

If you are running the pipeline on the GCP VM, you need to start the
instance and connect to the instance using SSH browser from the GCP
console. Once you are logged into the VM, you need to download the
project folder into the VM using "git clone".
Note: If you are using your local machine (WSL2 on Windows or other OS), you do not need to clone the project as you would have 
already done so during the setup stage. It is advised to run the orchestrator on GCP VM for faster performance and better CPU 
and memory capabilities. Refer to the "README.md" file under [setup](/setup) for git clone instructions.

## <ins>Install Docker</ins>

For running the orchestrator tool using the docker container, it is
mandatory that Docker is installed on the machine (either local or on
GCP VM). To install docker on the machine, execute these steps

```
chmod +x us_accidents_analysis/setup/setup_docker.sh
~/us_accidents_analysis/setup/setup_docker.sh
```
Once the above script completes successfully, you can test if docker is installed on by running the following command on the command
prompt.
```
docker --version
```
We need to make sure that the current user is added to the group to
start the docker engine.
```
sudo groupadd docker
sudo usermod -aG docker \$USER
newgrp docker
docker run hello-world
```

## <ins>Create and download access token from Kaggle</ins>

Make sure you have downloaded the access token for Kaggle. If you do
not have Kaggle account, please create one from the following link. -
https://www.kaggle.com

Once you register, you can generate an access key (access token) to
download datasets from Kaggle using the settings of your Kaggle account.

You can upload your Kaggle and GCP service account keys using the
"UPLOAD FILE" feature on the GCP SSH connection. The file will be
downloaded into the user $HOME folder. Copy the file from the $HOME
folder into the project repository as below.
 
```
sudo mv <UPLOADED_KAGGLE_TOKEN.json> ~/us_accidents_analysis/mage_orchestration/us-accidents-pipeline/.kaggle/kaggle.json
cd ~/us_accidents_analysis/mage_orchestration/us-accidents-pipeline
sudo chmod 600 ./.kaggle/Kaggle.json
```
 
## <ins>Copy the GCP service account keys from the local machine</ins>

You also need to move the Google service account credentials we created
during the setup process to the VM if you are running the orchestration
there. Follow the same procedure to upload that service account access
key JSON file into the VM as you did for the Kaggle account.
 
```
sudo mv <DOWNLOADED_SERVICE_ACCOUNT_KEY.json> ~/us_accidents_analysis/.keys/us_accidents_srvc_acct.json
cd ~/us_accidents_analysis/mage_orchestration/us-accidents-pipeline
sudo chmod 600 ./.keys/us_accidents_srvc_acct.json
```
 
## <ins>Build and run docker containers for Mage</ins>

Now we need to build the docker images to run the pipeline. Change
directory to the orchestration folder and execute the commands as
given.
 
```
 cd ~/us_accidents_analysis/mage_orchestration/us-accidents-pipeline
 docker compose build
```
The first time the docker container is built, it takes a little longer
time to build. Wait for the process to complete. Once the process
completes without any errors, you can run the docker container using
the command.
```
 docker compose up -d
```
Then run the following command to check that the containers are up and
running using the command.
```
docker ps
```
 

## <ins>Add network rule to run docker on the browser</ins>

Configure the network firewall policy to allow incoming (ingress)
traffic on port "6789" and allow all IP address ranges on it as source
filters (0.0.0.0/0). For this you need to choose the "VPC firewall"
policy on the search tab and add a new network firewall rule. Refer to
the picture here -- XXXX to see the settings.

Ensure that Dataproc cluster is started.

## <ins>Run the Mage ETL pipeline on the browser</ins>

-   Connect to Mage on the browser using the url -- http://<EXTERNAL-IP-OF-GCE>:6789 . 

-   On the Mage terminal, run the following command under the "dbt"
    folder to check if DBT files are installed properly.
    ```
    dbt deps
    dbt debg    
    ```
-   Trigger the pipeline "accidents_pipeline" using the "Triggers"
    option from the Mage UI. Monitor the process and resolve if any
    issues that are seen in the logs. The status of the pipeline run
    will show as "completed" or "failed".

-   The pipeline process downloads the accidents data from Kaggle,
    exports the raw file into GCS in .csv and parquet formats, extracts
    and stages the raw data, transforms and loads the data into
    partitioned fact and summary tables (dimensions and measures) in BigQuery.

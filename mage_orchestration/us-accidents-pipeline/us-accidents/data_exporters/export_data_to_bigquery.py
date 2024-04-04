import os

from mage_ai.io.file import FileIO
from pandas import DataFrame


if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def transform_custom(*args,**kwargs):

    """
    args:The output from any upstream parent blocks (if applicable)

    Returns:
        Anything (e.g. data frame,dictionary,array,int,str,etc.)

    This script is used to create a partitioned and clustered table on Big Query
    using GCLOUD cli utility and move the data from the paruqet files in GCS to
    Big Query.
    """
    # Specify your custom logic here

    key_file = "/home/src/"+os.environ['GOOGLE_APPLICATION_CREDENTIALS']
    auth_key = f'gcloud auth activate-service-account --key-file={key_file}'
    os.system(f'{auth_key}')
    gcp_project_id = os.environ['GCP_PROJECT_ID']
    os.system(f'gcloud config set project {gcp_project_id}')


    bq_ds = os.environ['DBT_DATASET_BQ']
    print("bq_ds : ", bq_ds)

    # os.system("bq show --format=prettyjson us_accidents_2016_2023.accidents_data")

    # We are creating the bigquery dataset as part of Terraform
    #  os.system(f'bq mk --dataset {bq_ds}')
    
    os.system(f'bq mk  \
              --table  \
              --schema scripts/accidents_schema.json  \
              --time_partitioning_field Start_Time  \
              --time_partitioning_type DAY  \
               {bq_ds}.accidents_data')

  
    os.system(f'bq update --clustering_fields=Severity,State {bq_ds}.accidents_data')

    gcp_bucket = os.environ['GCP_BUCKET']
    os.system(f"bq load \
                --replace=true \
                --source_format=PARQUET  \
                {bq_ds}.accidents_data \
                gs://{gcp_bucket}/pq/Start_Year_Month*")
  
    return 'success'

@test
def test_output(output,*args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None,'The load into Big Query failed.'
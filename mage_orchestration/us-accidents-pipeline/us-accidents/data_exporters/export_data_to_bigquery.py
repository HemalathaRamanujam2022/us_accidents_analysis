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
    """
    # Specify your custom logic here

    key_file = "/home/src/"+os.environ['GCP_SRVC_ACCT_KEY']
    auth_key = f'gcloud auth activate-service-account --key-file={key_file}'
    os.system(f'{auth_key}')
    gcp_project_id = os.environ['GCP_PROJECT_ID']
    os.system(f'gcloud config set project {gcp_project_id}')

    # os.system("bq show --format=prettyjson us_accidents_2016_2023.accidents_data")


    os.system('bq mk --dataset us_accidents_2016_2023')
    
    os.system('bq mk  \
              --table  \
              --schema scripts/accidents_schema.json  \
              --time_partitioning_field Start_Time  \
              --time_partitioning_type DAY  \
               us_accidents_2016_2023.accidents_data')

  
    os.system('bq update --clustering_fields=Severity,State us_accidents_2016_2023.accidents_data')

    gcp_bucket = os.environ['GCP_BUCKET']
    os.system(f"bq load \
                --source_format=PARQUET  \
                us_accidents_2016_2023.accidents_data \
                gs://{gcp_bucket}/pq/Start_Year_Month*")
  
    return 'success'

@test
def test_output(output,*args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None,'The output is undefined'
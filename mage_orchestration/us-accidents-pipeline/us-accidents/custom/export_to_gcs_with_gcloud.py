import os
import pandas as pd

# import pyspark
# from pyspark.sql import types


if 'custom' not in globals():
    from mage_ai.data_preparation.decorators import custom
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@custom
def transform_custom(*args, **kwargs):
    """
    args: The output from any upstream parent blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)

    This script is used to load the US accidents data from the local machine 
    and upload to GCS bucket by using parllel load parameters on gsutil CP command.
    """
    # Specify your custom logic here

    # We have installed the gcloud application inside the docker image
    os.system(f'gcloud version')
    os.system('pwd')
    
    key_file = "/home/src/"+os.environ['GOOGLE_APPLICATION_CREDENTIALS']
    auth_key = f'gcloud auth activate-service-account --key-file={key_file}'
    os.system(f'{auth_key}')
    gcp_project_id = os.environ['GCP_PROJECT_ID']
    os.system(f'gcloud config set project {gcp_project_id}')

    data_filename = args[0]
    gcp_bucket = os.environ['GCP_BUCKET']
    # Uncomment the parallel statement later
    #os.system(f"gsutil -m cp -r { data_filename } gs://{gcp_bucket}/raw/")
    os.system(f"gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp -r data/{data_filename} gs://{gcp_bucket}/raw/")

    # Return the location of the kaggle data file to next process
    raw_data = "gs://"+ gcp_bucket + "/raw/"+ data_filename
    return raw_data
    
@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The data upload to GCS bucket has failed.'

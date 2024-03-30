import os

if 'custom' not in globals():
    from mage_ai.data_preparation.decorators import custom
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform_custom(*args, **kwargs):
    """
    # Template for loading data from a BigQuery warehouse.
    # Specify your configuration settings in 'io_config.yaml'.

    # Docs: https://docs.mage.ai/design/data-loading#bigquery
    """

    gcp_bucket = os.environ['GCP_BUCKET']
    key_file = "/home/src/"+os.environ['GCP_SRVC_ACCT_KEY']
    auth_key = f'gcloud auth activate-service-account --key-file={key_file}'
    os.system(f'{auth_key}')
    gcp_project_id = os.environ['GCP_PROJECT_ID']
    os.system(f'gcloud config set project {gcp_project_id}')

    os.system(f"gsutil cp -r scripts/spark_dataproc_to_gcs.py gs://{gcp_bucket}/code/")

    # os.system(f'gcloud dataproc jobs submit pyspark  \
    # --cluster=us-accidents-dataproc-cluster  \
    # --region=asia-south1 \
    # gs://us-accidents-hrmnjm/code/spark_dataproc_to_gcs.py  --  \
    # --data_filename=gs://us-accidents-hrmnjm/raw/US_Accidents_March23.csv  \
    # --output_path=gs://us-accidents-hrmnjm/pq')

    os.system(f'gcloud dataproc jobs submit pyspark  \
    --cluster=us-accidents-dataproc-cluster  \
    --region=asia-south1 \
    gs://{gcp_bucket}/code/spark_dataproc_to_gcs.py  --  \
    --data_filename=gs://{gcp_bucket}/raw/US_Accidents_March23.csv  \
    --output_path=gs://{gcp_bucket}/pq')


# @test
# def test_output(output, *args) -> None:
#     """
#     Template code for testing the output of the block.
#     """
#     assert output is not None, 'The output is undefined'

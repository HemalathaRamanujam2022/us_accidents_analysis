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

    This command block calls a Dataproc cluster on GCP to process the CSV data 
    stored in GCP_BUCKET and convert them into partitioned parquet files after
    doing some field transformations.

    # Docs: https://docs.mage.ai/design/data-loading#bigquery
    """

    gcp_data_filename = args[0]
    gcp_bucket = os.environ['GCP_BUCKET']
    key_file = "/home/src/"+os.environ['GOOGLE_APPLICATION_CREDENTIALS']
    auth_key = f'gcloud auth activate-service-account --key-file={key_file}'
    os.system(f'{auth_key}')
    gcp_project_id = os.environ['GCP_PROJECT_ID']
    gcp_dataproc_cluster = os.environ['GCP_DATAPROC_CLUSTER']
    gcp_region = os.environ['GCP_REGION']
    os.system(f'gcloud config set project {gcp_project_id}')

    os.system(f"gsutil cp -r scripts/spark_dataproc_to_gcs.py gs://{gcp_bucket}/code/")

    # os.system(f'gcloud dataproc jobs submit pyspark  \
    # --cluster=us-accidents-dataproc-cluster  \
    # --region=asia-south1 \
    # gs://us-accidents-hrmnjm/code/spark_dataproc_to_gcs.py  --  \
    # --data_filename=gs://us-accidents-hrmnjm/raw/US_Accidents_March23.csv  \
    # --output_path=gs://us-accidents-hrmnjm/pq')

    os.system(f'gcloud dataproc jobs submit pyspark  \
    --cluster={gcp_dataproc_cluster}  \
    --region={gcp_region} \
    gs://{gcp_bucket}/code/spark_dataproc_to_gcs.py  --  \
    --data_filename={gcp_data_filename}  \
    --output_path=gs://{gcp_bucket}/pq')

    return 'success'


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'Transformation from CSV to parquet files failed.'

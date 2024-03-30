import io
import pandas as pd
import requests
import os
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """

    # Uncomment the following code later
    # dataset_name = 'sobhanmoosavi/us-accidents'
    # os.system(f'kaggle datasets download -d {dataset_name} -p data')
    # Unzip the downloaded data
    # csv_file = "data/us-accidents.zip"
    # os.system(f'unzip {csv_file} -d data')

    data_filename = 'data/US_Accidents_March23.csv'
    return data_filename

# @test
# def test_output(output, *args) -> None:
#     """
#     Template code for testing the output of the block.
#     """
#     assert output is not None, 'The output is undefined'

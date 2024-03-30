#!/usr/bin/env python
# coding: utf-8

import argparse

import pyspark
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql import types


parser = argparse.ArgumentParser()

parser.add_argument('--data_filename', required=True)
parser.add_argument('--output_path', required=True)

args = parser.parse_args()

data_filename = args.data_filename
output_path = args.output_path

print("data_filename : ", data_filename)
print("output_path : ", output_path)

## Data structure from https://smoosavi.org/datasets/us_accidents
data_schema = types.StructType([
    types.StructField('ID', types.StringType(), True),
    types.StructField('Source', types.StringType(), True),
    types.StructField('Severity', types.IntegerType(), True),
    types.StructField('Start_Time', types.TimestampType(), True),
    types.StructField('End_Time', types.TimestampType(), True),
    types.StructField('Start_Lat', types.DoubleType(), True),
    types.StructField('Start_Lng', types.DoubleType(), True),
    types.StructField('End_Lat', types.DoubleType(), True),
    types.StructField('End_Lng', types.DoubleType(), True),
    types.StructField('Distance_miles', types.DoubleType(), True),
    types.StructField('Description', types.StringType(), True),
    # types.StructField('Number', types.DoubleType(), True),
    types.StructField('Street', types.StringType(), True),
    # types.StructField('Side', types.StringType(), True),
    types.StructField('City', types.StringType(), True),
    types.StructField('County', types.StringType(), True),
    types.StructField('State', types.StringType(), True),
    types.StructField('Zipcode', types.StringType(), True),
    types.StructField('Country', types.StringType(), True),
    types.StructField('Timezone', types.StringType(), True),
    types.StructField('Airport_Code', types.StringType(), True),
    types.StructField('Weather_Timestamp', types.TimestampType(), True),
    types.StructField('Temperature_F', types.DoubleType(), True),
    types.StructField('Wind_Chill_F', types.DoubleType(), True),
    types.StructField('Humidity_perc', types.DoubleType(), True),
    types.StructField('Pressure_inches', types.DoubleType(), True),
    types.StructField('Visibility_miles', types.DoubleType(), True),
    types.StructField('Wind_Direction', types.StringType(), True),
    types.StructField('Wind_Speed_mph', types.DoubleType(), True),
    types.StructField('Precipitation_inches', types.DoubleType(), True),
    types.StructField('Weather_Condition', types.StringType(), True),
    types.StructField('Amenity', types.BooleanType(), True),
    types.StructField('Bump', types.BooleanType(), True),
    types.StructField('Crossing', types.BooleanType(), True),
    types.StructField('Give_Way', types.BooleanType(), True),
    types.StructField('Junction', types.BooleanType(), True),
    types.StructField('No_Exit', types.BooleanType(), True),
    types.StructField('Railway', types.BooleanType(), True),
    types.StructField('Roundabout', types.BooleanType(), True),
    types.StructField('Station', types.BooleanType(), True),
    types.StructField('Stop', types.BooleanType(), True),
    types.StructField('Traffic_Calming', types.BooleanType(), True),
    types.StructField('Traffic_Signal', types.BooleanType(), True),
    types.StructField('Turning_Loop', types.BooleanType(), True),
    types.StructField('Sunrise_Sunset', types.StringType(), True),
    types.StructField('Civil_Twilight', types.StringType(), True),
    types.StructField('Nautical_Twilight', types.StringType(), True),
    types.StructField('Astronomical_Twilight', types.StringType(), True)
    # types.StructField('Start_Date', types.DateType(), True),
    # types.StructField('End_Date', types.DateType(), True),
    # types.StructField('Start_Year_Month', types.StringType(), True)
])


spark = SparkSession.builder \
    .appName('accident_data_to_gcs') \
    .getOrCreate()

df_accidents = spark.read \
    .option("header","true") \
    .schema(data_schema) \
    .csv(data_filename)

# print(df_accidents.schema)

# df_accidents.printSchema()

df_accidents = df_accidents \
    .withColumn('Start_Date', F.to_date(df_accidents.Start_Time)) \
    .withColumn('End_Date', F.to_date(df_accidents.End_Time)) \
    .withColumn('Start_Year_Month', F.date_format(F.to_date(df_accidents.Start_Time, "yyyy-mm-dd"),"yyyyMM")) \
    
# df_accidents \
# .select("ID", "Start_Time", "End_Time", "Start_Date", "End_Date", "Start_Year_Month") \
# .show(5)

# df_accidents \
# .show(5)

# df_accidents \
#     .repartition(24) \
#     .write.parquet(output_path, mode='overwrite')

# df.write.format("parquet").partitionBy("age") \
# .option("path", "gs://my_bucket/my_table")

df_accidents.write.mode("overwrite").format("parquet").partitionBy("Start_Year_Month") \
.option("path",output_path).save()

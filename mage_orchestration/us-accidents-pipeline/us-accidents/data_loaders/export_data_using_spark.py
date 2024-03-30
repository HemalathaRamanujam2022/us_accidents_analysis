import os
import pyspark
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext
from pyspark.sql import functions as F
from pyspark.sql import types
from pyspark.sql.functions import col

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    """
    Template code for loading data from any source.

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your data loading logic here

    # spark = kwargs.get('spark')
    # print(spark.sql('select 1'))
    #data_filename = args[0]
    #data_filename = 'data/US_Accidents_March23.csv'
   
    gcp_bucket = os.environ['GCP_BUCKET']
    data_filename = "gs://"+gcp_bucket+"/raw/"+"US_Accidents_March23.csv"
    output_path = "gs://"+gcp_bucket+"/pq"
    print("data_filename : ", data_filename)
    print("output_path :", output_path)

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
    types.StructField('Street', types.StringType(), True),
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
])

    credentials_location = os.environ['GOOGLE_APPLICATION_CREDENTIALS']

    spark = kwargs.get('spark')
    conf = spark.sparkContext.getConf().getAll()
    for item in conf: print(item)
   
    spark = kwargs.get('spark')
    sc = spark.sparkContext
    hadoop_conf = sc._jsc.hadoopConfiguration()

    hadoop_conf.set("fs.AbstractFileSystem.gs.impl",  "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")
    hadoop_conf.set("fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
    hadoop_conf.set("fs.gs.auth.service.account.json.keyfile", credentials_location)
    hadoop_conf.set("fs.gs.auth.service.account.enable", "true")

    spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()

    print(spark.sql('select 1'))

    # spark.conf.set("spark.executor.memory", '2g')
    # spark.conf.set("spark.executor.cores", 2)
    # spark.conf.set("spark.default.parallelism", '8')
    # spark.conf.set("spark.sql.shuffle.partitions", '8')

    # print(f"Parallelism : {sc.defaultParallelism}")

    # num_partitions = 200
    
    # df_accidents = spark.read \
    #     .option("header","true") \
    #     .schema(data_schema) \
    #     .csv(data_filename) \

    # # df_accidents = df_accidents.repartition(24)

    # # df_accidents.cache()
    

    # df_accidents = df_accidents \
    #     .withColumn('Start_Date', F.to_date(df_accidents.Start_Time)) \
    #     .withColumn('End_Date', F.to_date(df_accidents.End_Time)) \
    #     .withColumn('Start_Year_Month', F.date_format(F.to_date(df_accidents.Start_Time, "yyyy-mm-dd"),"yyyyMM")) \
      
    # # # udf_hash = F.udf(lambda val: hash(val), types.LongType())
    # # # df_accidents = df_accidents \
    # # #             .withColumn("partition", udf_hash("Start_Year_Month") % num_partitions) 
    # #             # .repartition("partition") 

    # df_accidents.write.mode("overwrite").format("parquet").partitionBy("Start_Year_Month") \
    #             .option("path",output_path).save()

    # # df_accidents.repartition("partition").write.mode("overwrite").format("parquet") \
    # # .option("path",output_path).save()

    
    # # df_accidents.repartitionByRange(20, col("Start_Year_Month"), col("partition")) \
    # #         .write.partitionBy("Start_Year_Month") \
    # #         .mode("overwrite").format("parquet") \
    # #         .option("path",output_path).save()

    spark.stop()



    return 'success'


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

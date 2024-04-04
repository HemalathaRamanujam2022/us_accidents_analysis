# <ins>US Traffic Accident Analysis</ins>

## <ins>Project Description</ins>

This project does an in-depth analysis on the car traffic accidents that
happened since 2016 in the Unites States of America across all the
states. This analysis is important for understanding the various
phenomena and conditions that contribute to these accidents and once
those causes are studied and corrected, the number of accidents can
be drastically reduced.

## <ins>Use cases</ins>

This has many benefits like

-   Drivers become aware of the highways that are more dangerous than
    others to drive on. This will motivate them to drive carefully and
    maintain the speed limits and therefore prevent an accident from
    occurring.

-   Correlating the occurrence of an accident to the prevailing weather
    conditions will help drivers pick days of the week and time of the
    year when there is a low probability of traffic collisions.

-   Drivers can get an estimate on how their travel may be impacted due
    to an accident on a certain route. Depending on the severity of the
    accident, drivers can allocate extra buffer time into their travel.

-   The government agencies responsible for maintenance of the roads and
    highways will get first hand information on vulnerable routes and
    can design alternative highways to ease the traffic.

-   The traffic control department can use this data to predict delays
    on certain highways base on past incidents and possibly deploy more
    patrol cars on accident prone highways.

-   Natural Language Processing ML algorithms can be used on the human
    coded accident description field to extract more patterns on the
    data.

## <ins>Analytics</ins>

The following are some of the few insights and trends that can be
deciphered from the analyzed data.

-   Top states, cities, highways with the highest number of accidents by
    severity.

-   The time of the day and week when these accidents occur.

-   The contribution of weather and environment factors to these
    accidents.

-   The amenities and other point of interest that are available on the
    impacted highways.

-   The growth / decline of accidents across geography over the years.

## <ins>Dataset Used</ins>

This is a countrywide traffic accident dataset, which covers 49 states
of the United States. The data is continuously being collected from
February 2016, using several data providers, including multiple APIs
that provide streaming traffic event data. These APIs broadcast traffic
events captured by a variety of entities, such as the US and state
departments of transportation, law enforcement agencies, traffic
cameras, and traffic sensors within the road-networks. Currently, there
are about 7.73 million accident records in this dataset captured until
March 2023. Check the below descriptions for more detailed information.

Source URL : <https://smoosavi.org/datasets/us_accidents> 

<https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents>

## <ins>Technologies and Tools used</ins>

1.  Google Cloud platform - GCP

-   Google loud storage (GCS) to hold the raw data and parquet files and
    serve as data lake.

-   Google big query data warehouse (DW) with datasets to hold the data
    warehouse tables and views.

-   Google compute engine (GCE) for improved performance and reliability
    of the ETL pipeline.

-   Google Looker Studio for publishing the reports visualized using
    data from the DW.

-   Dataproc cluster inside GCP to run the Pyspark job.

2.  Terraform ( https://www.terraform.io/ ) Infrastructure as a Code
    tool was used for creating the GCP resources to add human error and
    improve deployment operations.

3.  Mage.ai ( <https://www.mage.ai/> ) as the workflow orchestration
    tool for the data.

4.  DBT ( <https://www.getdbt.com/> ) as the data build tool for
modelling the tables and views used in the data warehouse and also for
transforming and exporting the data from staging to production datasets.

## <ins>Architecture</ins>
![Architecture Diagram](static/architecture/Accidents%20pipeline%20architecture%20diagram.png)

## <ins>Pre-requisites for running the project</ins>

Machine running Linux/Ubuntu/Mac OS with minimum of 8 GB RAM.

-   Terraform

-   Docker

-   An active user account on GCP

-   User account on Kaggle with access token to download Kaggle
    dataset

-   "gloud-sdk" tool if running the project on the local machine

-   GitHub account to download the project repository

## <ins>Setup and steps to run the ETL pipeline and generate dashboard</ins>

The project can be run either locally on your machine (Linux or Windows
or Mac OS) or on the GCP VM. I had tested the code on WSL2 (Windows
Subsystem for Linux 2) on Windows 11 machine. For more information on
how to install WSL2 for Linux, use the following link.

<https://learn.microsoft.com/en-us/windows/wsl/install>

## <ins>Project setup</ins>

Go to the setup folder. Follow the instructions under "ReadMe" section
on that page.

> **Terraform**
>
> Follow the instructions on this page "terraform" and execute all the
> steps.
>
> **Orchestration and Data transformation**
>
> Follow the instructions on this page "mage" and execute all the steps.
>
> **Data visualization**
>
> Follow the instructions under the "Visualization" folder and execute
> all the steps.

## <ins>Clean up</ins>

Once you are done testing the project, you need to decommission all the
deployed resources on the GM instance.

1.  Run the command "terraform destroy" under the same folder where you
    applied the resources.

2.  Delete the Dataproc cluster instance on the GCP VM which was created
    manually.

3.  Ensure that no GCP resources are still use under your project. Once
    you confirm it, you can shutdown the GCP project under your account.

4.  Delete the project repository from the local machine.

## <ins>Dashboard</ins>

![Dashboard](static/looker/US%20accident%20analysis%20screenshot.png)

Some of the insights we derive from the dashboard are:

-   The number of accidents seem to be increasing every year with a
    increase of 12% in the year 2022 compared to the year 2021.

-   The state of California recorded the highest number of accidents
    overall followed by Texas.

-   Miami is the city with the highest number of traffic snarls and the
    highway I-95N the most accident prone.

-   Even though most accidents happen during clear weather, cloudy
    conditions come close at the second place.

## <ins>Acknowledgements</ins>

Dataset - Moosavi, Sobhan, Mohammad Hossein Samavatian, Srinivasan
Parthasarathy, and Rajiv Ramnath. "A Countrywide Traffic Accident
Dataset.", 2019

Instructor credits -- The amazing team of <https://datatalks.club/> led
by Alexey Grigorev.

I thank them for their thoughtful compilation and delivery of this
course to inspire and educate data enthusiasts interested in latest
technologies data engineering. I thank them profusely for offering
support and guidance throughout the course.


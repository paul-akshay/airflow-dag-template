from airflow.decorators import dag, task
from datetime import datetime, timedelta

# Define default arguments for the DAG
default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

@dag(
    dag_id="just_a_normal_dag",
    start_date=datetime(2023, 1, 1),
    schedule_interval="@daily",
    default_args=default_args,
    catchup=False,
    description="A sample DAG using the TaskFlow API with decorators",
    tags=["example", "demo"],
)
def sample_taskflow_dag():

    @task()
    def extract():
        # Simulate extracting data (e.g., from a database or file)
        data = [1, 2, 3, 4, 5]
        return data

    @task()
    def transform(data: list):
        # Process the data; here we double each number
        transformed_data = [i * 2 for i in data]
        return transformed_data

    @task()
    def load(data: list):
        # Simulate loading data (e.g., saving to a database)
        print("Loaded data:", data)
        return "Load successful"

    # Define the task pipeline by setting task dependencies
    data = extract()
    transformed_data = transform(data)
    load(transformed_data)

# Instantiate the DAG
dag_instance = sample_taskflow_dag()

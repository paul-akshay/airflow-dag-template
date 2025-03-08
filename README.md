# AIRFLOW STUDIO

Airflow Studio is my personal sandbox for experimenting with various utilities I develop and demo. It’s a space to prototype tools and showcase ideas that enhance workflows and automation.

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Python 3](https://www.python.org/downloads/)
- [pip3](https://pip.pypa.io/en/stable/installation/)


## Set up in local

You can make use of the available **Make** commands to set up the project in local and start the airflow.

### Run
  ```bash
  make help
 ```
to list all the available commands.

## Explore Utilities

### Dynamic DAG Decorator - `@dynamic_dag`
**Dynamic DAGs** allow you to programmatically generate Apache Airflow workflows at runtime using external configuration files. This approach lets you define a single DAG template and dynamically create multiple, logically separated DAGs without duplicating code, enhancing maintainability and leveraging a form of polymorphism.

The `@dynamic_dag` decorator implements this concept in a cleaner and concise way by scanning its directory for YAML configuration files and generating corresponding DAGs.  
You can refer to an example under `/dags/sample_dynamic_dag`.

##### References:
[Dynamic Dags | Apache Airflow](https://airflow.apache.org/docs/apache-airflow/stable/howto/dynamic-dag-generation.html) 

[Dynamic Dags | Astronomer](https://www.astronomer.io/docs/learn/dynamically-generating-dags/).


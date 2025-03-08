import os
import yaml
import inspect
from airflow import DAG
from functools import wraps
from datetime import datetime


def dynamic_dag(default_args=None):
    """
    Decorator to define a DAG template and dynamically generate DAGs
    based on YAML configurations in the same directory as the defining file.
    """

    def decorator(func):
        @wraps(func)
        def wrapper():
            dag_dir = os.path.dirname(inspect.getfile(func))
            dags = {}

            # Load all YAML files in the same directory
            for file in os.listdir(dag_dir):
                if file.endswith(".yaml") or file.endswith(".yml"):
                    yaml_path = os.path.join(dag_dir, file)
                    with open(yaml_path, "r") as f:
                        try:
                            config = yaml.safe_load(f)
                            dag_id = config.get("dag_id")
                            schedule_interval = config.get("schedule_interval")
                            start_date = config.get("start_date", "2024-01-01")

                            if not dag_id:
                                raise ValueError(f"DAG ID is missing in {file}")

                            dag_args = {
                                "default_args": default_args or {},
                                "schedule_interval": schedule_interval,
                                "start_date": datetime.strptime(start_date, "%Y-%m-%d"),
                                "catchup": config.get("catchup", False)
                            }

                            dag = DAG(dag_id, **dag_args)
                            with dag:
                                func(config)

                            dags[dag_id] = dag
                        except Exception as e:
                            print(f"Error processing {file}: {e}")

            globals().update(dags)  # Automatically register DAGs

        return wrapper

    return decorator

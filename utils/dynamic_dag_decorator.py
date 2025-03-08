import os
import yaml
import inspect
from airflow import DAG
from functools import wraps
from datetime import datetime


def dynamic_dag(default_args=None):
    """
    Dynamic DAG Decorator
    =====================

    The `dynamic_dag` decorator is designed to define a single DAG template and dynamically
    generate multiple Apache Airflow DAGs at runtime. It scans the directory where the
    decorated function is defined for YAML configuration files. For each valid YAML file,
    it creates and registers a new DAG with parameters defined in the file.

    This approach minimizes code duplication and promotes maintainability by allowing
    a single function to serve as a blueprint for multiple DAGs—leveraging a form of
    polymorphism where each DAG instance is customized based on its external configuration.

    Usage
    -----
    1. Create one or more YAML files in the same directory as your DAG definition. Each
       YAML file should contain at least the following keys:

           - dag_id (required)
           - schedule_interval
           - start_date (defaults to "2024-01-01" if not provided)
           - catchup (optional; defaults to False)

       Example (example_dag.yaml):

           dag_id: example_dag
           schedule_interval: '@daily'
           start_date: '2024-01-01'
           catchup: false

    2. Define your DAG template using the `@dynamic_dag` decorator:

       from airflow import DAG
       from dynamic_dag import dynamic_dag  # Adjust the import as needed
       
       @dynamic_dag(default_args={'owner': 'airflow'})
        def define_tasks(config):
            from airflow.operators.bash_operator import BashOperator
            # Define tasks for the DAG using the provided config.
            task = BashOperator(
                task_id='print_date',
                bash_command='date'
            )

    3. When Airflow parses your DAG file, the decorator will:
       - Locate and load all YAML files in the directory.
       - Create a separate DAG for each YAML configuration.
       - Execute the `define_tasks` function within the context of each DAG to define tasks.
       - Register each DAG in the global namespace so that Airflow can discover them.

    Parameters
    ----------
    default_args : dict, optional
        A dictionary of default arguments to be applied to each generated DAG.
        If not provided, an empty dictionary is used.

    Internal Workflow
    -----------------
    1. **Directory Inspection:**
       - Uses `inspect.getfile` to determine the file location of the decorated function.
       - Scans the directory for files ending with `.yaml` or `.yml`.

    2. **Configuration Parsing:**
       - Opens and parses each YAML file using `yaml.safe_load`.
       - Extracts necessary parameters such as `dag_id`, `schedule_interval`, and `start_date`.
       - Converts the `start_date` string into a `datetime` object (defaulting to "2024-01-01").

    3. **DAG Creation:**
       - Validates that the configuration contains a `dag_id`. If missing, a `ValueError` is raised.
       - Instantiates a new `DAG` object with the provided configuration and any `default_args`.
       - Executes the decorated function within the context of the newly created DAG to define tasks.
       - Stores the DAG in a dictionary keyed by its `dag_id`.

    4. **Global Registration:**
       - Updates the global namespace with the generated DAGs so that Airflow can automatically
         detect and load them.

    Error Handling
    --------------
    If an error occurs while processing a YAML file (e.g., missing `dag_id`), an error message is
    printed with details about the problematic file, allowing for easier debugging of configuration issues.

    Example
    -------
    Assuming you have a file `example_dag.yaml` in the same directory, the following code:

        @dynamic_dag(default_args={'owner': 'airflow'})
        def define_tasks(config):
            from airflow.operators.bash_operator import BashOperator
            task = BashOperator(
                task_id='print_date',
                bash_command='date'
            )

    will generate a DAG with the `dag_id` provided in the YAML configuration, create tasks as defined,
    and register the DAG with Airflow.
    """
    import os
    import yaml
    import inspect
    from airflow import DAG
    from functools import wraps
    from datetime import datetime

    def dynamic_dag(default_args=None):
        """
        Decorator to define a DAG template and dynamically generate DAGs based on YAML
        configurations in the same directory as the defining file.

        Parameters
        ----------
        default_args : dict, optional
            A dictionary of default arguments to be applied to each DAG. If not provided,
            an empty dictionary is used.

        Returns
        -------
        function
            A decorator function that wraps the DAG template function. When invoked,
            it processes each YAML file in the directory, generates a DAG, and registers
            it globally.
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

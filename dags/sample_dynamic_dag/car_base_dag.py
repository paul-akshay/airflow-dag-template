from airflow.decorators import task

from utils.dynamic_dag_decorator import dynamic_dag


@dynamic_dag(default_args={"owner": "airflow", "retries": 1})
def create_car_dag(config):
    car_model = config.get("car_model", None)

    @task()
    def assemble_car():
        message = f"Assembling the {car_model} chassis..."
        print(message)
        return f"{car_model} chassis assembled"

    @task
    def paint_car(assembly_output):
        message = f"Painting the {car_model} with input: {assembly_output}"
        print(message)
        return f"{car_model} painted"

    @task
    def deliver_car(paint_output):
        message = f"Delivering the {car_model} with final status: {paint_output}"
        print(message)
        return f"{car_model} delivered"

    # Define the task flow
    assembly = assemble_car()
    painting = paint_car(assembly)
    deliver_car(painting)


# Execute the function to trigger DAG generation.
create_car_dag()
FROM apache/airflow:2.8.4-python3.9

COPY requirements.txt /requirements.txt
RUN pip install --user --upgrade pip
#Please retry with deleting .env file if the following step fails for some reason.
RUN pip install --no-cache-dir --user -r /requirements.txt

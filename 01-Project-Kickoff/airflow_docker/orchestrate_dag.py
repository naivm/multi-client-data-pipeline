import os
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago
from dotenv import set_key

# Define default_args for the DAG
default_args = {
    'owner': 'paula',
    'start_date': days_ago(1),
    'retries': 1
}

# Define the DAG
with DAG(
    dag_id='orchestrate_token_dag',
    default_args=default_args,
    description='Run shell script and update .env file with token',
    schedule_interval=None,  # Set as None for manual trigger
) as dag:

    # Task 1: Run the bash script
    run_orchestrate_script = BashOperator(
        task_id='run_orchestrate_script',
        bash_command='bash /path/to/orchestrate.sh',
        do_xcom_push=True  # This pushes the output to Airflow's XCom (cross-communication)
    )

    # Task 2: Python function to update .env file
    def update_env_with_token(**kwargs):
        ti = kwargs['ti']  # Task Instance to get XCom values
        access_token = ti.xcom_pull(task_ids='run_orchestrate_script')  # Get the script output

        # Path to the .env file
        env_file = '/path/to/.env'
        # Update the .env file
        set_key(env_file, "TOKEN", access_token)

    update_env_task = PythonOperator(
        task_id='update_env_with_token',
        python_callable=update_env_with_token,
        provide_context=True
    )

    # Set the task sequence
    run_orchestrate_script >> update_env_task

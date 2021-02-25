from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator
from airflow.contrib.operators.ssh_operator import SSHOperator

from airflow.sensors.s3_key_sensor import S3KeySensor

#slack
from airflow.hooks.base_hook import BaseHook
from airflow.contrib.operators.slack_webhook_operator import SlackWebhookOperator
from airflow.api.common.experimental.trigger_dag import trigger_dag


from datetime import datetime, timedelta
from airflow.models import Variable

#XCOM abbreviation for cross communication
#push and pull

buket = Variable.get('bucket')
pass_rds_postgres = Variable.get('pass_rds_postgres')
host_rds_postgres = Variable.get('host_rds_postgres')
port_rds_postgres = Variable.get('port_rds_postgres')

aws_download = 'aws s3 cp s3://storageairflow/{0}_temp/{1}.csv ~/dbt/datawarehouse/data/'

dbt_seed = 'source venv/dbt/bin/activate && cd ~/dbt/datawarehouse/ && dbt seed --profile sandbox -s {}'

dbt_run_model = """
source venv/dbt/bin/activate && cd ~/dbt/datawarehouse/ && dbt run --profile datawarehouse --vars "{'schema': 'sandbox'}" --model covid 
"""



delete_table_ppostgres = """ 
PGPASSWORD='{0}' psql --host {1} --port {2} --username postgres -d datawarehouse -c "delete from sandbox.{3} where 1=1";
"""

copy_postgres = """
PGPASSWORD='{0}' psql --host {1} --port {2} --username postgres -d datawarehouse -c "\\copy sandbox.{3} from '/home/ec2-user/dbt/datawarehouse/data/{1}.csv' with DELIMITER '{4}' csv header";
"""
validate_remove_caracteres_comand = "iconv -f ISO-8859-1 -t UTF-8 /home/ec2-user/dbt/datawarehouse/data/{0}.csv > /home/ec2-user/dbt/datawarehouse/data/{0}_temp.csv && mv /home/ec2-user/dbt/datawarehouse/data/{0}_temp.csv /home/ec2-user/dbt/datawarehouse/data/{0}.csv"

source_data = [{'data': 'data_covid', 'type': 'postgres', 'delimiter': ','},
               {'data': 'data_covid_uci_bogota', 'type': 'postgres', 'delimiter': ';'},
               {'data': 'data_ciudades', 'type': 'postgres', 'delimiter': ';'}]

default_args = {
    'owner': 'learning',
    'depends_on_past': False,
    'start_date': datetime(2021, 2, 2),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=2),
    'provide_context': True,
}
dag = DAG(
    'process_data', default_args=default_args, schedule_interval=None)

ssh_dbt_run = SSHOperator(
        task_id='ssh_dbt_run',
        ssh_conn_id="ssh_ec2",
        command=dbt_run_model,
        do_xcom_push=True,
        dag=dag
    )

for sensor_file in source_data:
    sensor = S3KeySensor(
            aws_conn_id='s3_conection',
            task_id='sensor_s3_file_{0}'.format(sensor_file['data']),
            bucket_key='{0}_temp/{1}{2}'.format(sensor_file['data'], sensor_file['data'], '.csv'),
            wildcard_match=True,
            bucket_name=buket,
            s3_conn_id='s3://{0}'.format(buket),
            timeout=18 * 60 * 60,
            poke_interval=60,
            dag=dag)

    ssh_download = SSHOperator(
        task_id='ssh_download_{0}'.format(sensor_file['data']),
        ssh_conn_id="ssh_ec2",
        command=aws_download.format(sensor_file['data'], sensor_file['data']),
        do_xcom_push=True,
        dag=dag
    )

    validate_remove_caracteres = SSHOperator(
        task_id='ssh_validate_remove_caracteres_{0}'.format(sensor_file['data']),
        ssh_conn_id="ssh_ec2",
        command=validate_remove_caracteres_comand.format(sensor_file['data']),
        do_xcom_push=True,
        dag=dag
    )

    ssh_delete_table_sandbox = SSHOperator(
        task_id='ssh_delete_tablesandbox_{0}'.format(sensor_file['data']),
        ssh_conn_id="ssh_ec2",
        command=delete_table_ppostgres.format(pass_rds_postgres, host_rds_postgres, port_rds_postgres, sensor_file['data']),
        do_xcom_push=True,
        dag=dag
    )

    command = ""
    if sensor_file['type'] == 'dbt':
        command = dbt_seed.format(sensor_file['data'])
    else:
        command = copy_postgres.format(pass_rds_postgres, host_rds_postgres, port_rds_postgres, sensor_file['data'],
                                       sensor_file['data'], sensor_file['delimiter'])

    ssh_sandbox = SSHOperator(
        task_id='ssh_sandbox_{0}'.format(sensor_file['data']),
        ssh_conn_id="ssh_ec2",
        command=command,
        do_xcom_push=True,
        dag=dag
    )

    sensor >> ssh_download >> validate_remove_caracteres >> ssh_delete_table_sandbox >> ssh_sandbox >> ssh_dbt_run



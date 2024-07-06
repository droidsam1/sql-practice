## Enable slow query log
``find / -name postgresql.conf``

Or use this command

```psql -U user postgres -h localhost -c 'SHOW config_file'```

### Step 1: Find the location of the postgresql.conf file
docker exec -it postgres psql -U user postgres -h localhost -c 'SHOW config_file'

### Step 2: Access the container's shell
docker exec -it postgres /bin/bash

### Inside the container, edit the postgresql.conf file
### You can use nano, vi, or any editor available in the container
nano /path/to/postgresql.conf

### Add or modify the following lines in postgresql.conf
log_min_duration_statement = 300  # Log queries taking longer than 300ms. Adjust as needed.
logging_collector = on  
log_directory = 'log' 
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'

### Exit the container's shell
exit

### Step 3: Restart the PostgreSQL container to apply changes
docker restart postgres

### Step 4: Check the log file for slow queries
docker exec -it postgres tail -f /var/lib/postgresql/data/log/
```
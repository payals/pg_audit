# Global configuration, log directory
PSQL_PATH=$1
PGUSER=$2
PGDATABASE=$3

set -e
set -x

# Get database size
$PSQL_PATH -c "COPY(select datname as database, pg_database_size(datname) as size from pg_database) TO '$HOME/pg_audit/input/db_size.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

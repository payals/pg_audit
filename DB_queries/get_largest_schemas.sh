# Global configuration, log directory
PSQL_PATH=$1
PGUSER=$2
PGDATABASE=$3

set -e
set -x

# Get database size
$PSQL_PATH -c "COPY(SELECT nspname AS "schema", sum(pg_relation_size(C.oid))::bigint AS "size" FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') group by nspname order by sum(pg_relation_size(C.oid))::bigint desc limit 10) TO '$HOME/pg_audit/input/db_size.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

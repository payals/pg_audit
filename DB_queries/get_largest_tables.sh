# Global configuration, log directory
PSQL_PATH=$1
PGUSER=$2
PGDATABASE=$3

set -e
set -x

# Get database size
$PSQL_PATH -c "COPY(SELECT nspname || '.' || relname AS "relation", pg_relation_size(C.oid) AS "size" FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') ORDER BY pg_relation_size(C.oid) DESC LIMIT 20) TO '$HOME/pg_audit/input/largest_tables.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

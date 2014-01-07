# Global configuration, log directory
PSQL_PATH=/opt/pgsql/bin/psql
PGUSER=postgres
PGDATABASE=pgods

set -e
set -x

# Create iostat.csv
sh ~/bin/iostat.sh

# Create vmstat.csv
sh ~/bin/vmstat.sh

# Get security information
$PSQL_PATH -c "COPY(select usename as username, usesuper as superuser, userepl as replication_allowed, case when passwd IS NOT NULL THEN 'yes' ELSE 'no' END as password_protected from pg_shadow) TO '$HOME/security_info.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

# Get checkpoint information
$PSQL_PATH  -c "copy(select * from pg_stat_bgwriter) to '$HOME/checkpoint_info.csv' with (format csv , delimiter ',' , header true)" -U $PGUSER -d $PGDATABASE

# Get 10 largest tables
$PSQL_PATH  -c "copy(SELECT nspname || '.' || relname AS "relation", pg_size_pretty(pg_relation_size(C.oid)) AS "size" FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') ORDER BY pg_relation_size(C.oid) DESC LIMIT 20) TO '$HOME/largest_tables.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

# Get largest databases
$PSQL_PATH  -c "copy(select datname, pg_size_pretty(pg_database_size(datname)) as size from pg_database order by size) TO '$HOME/largest_databases.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

# Get largest schemas
$PSQL_PATH  -c "copy(SELECT nspname AS "schema", pg_size_pretty(sum(pg_relation_size(C.oid))::bigint) AS "size" FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') group by nspname order by sum(pg_relation_size(C.oid))::bigint desc limit 20) TO '$HOME/largest_schemas.csv' WITH (FORMAT csv , DELIMITER ',' , HEADER true)" -U $PGUSER -d $PGDATABASE

# Get duplicate indexes
$PSQL_PATH  -c "copy(SELECT pg_size_pretty(sum(pg_relation_size(idx))::bigint) AS size, (array_agg(idx))[1] AS idx1, (array_agg(idx))[2] AS idx2, (array_agg(idx))[3] AS idx3, (array_agg(idx))[4] AS idx4 FROM (SELECT indexrelid::regclass AS idx, (indrelid::text ||E'\n'|| indclass::text ||E'\n'|| indkey::text ||E'\n'|| coalesce(indexprs::text,'')||E'\n' || coalesce(indpred::text,'')) AS KEY FROM pg_index) sub GROUP BY KEY HAVING count(*)>1 ORDER BY sum(pg_relation_size(idx)) DESC) to '$HOME/duplicate_indexes.csv' with (format csv , delimiter ',' , header true)" -U $PGUSER -d $PGDATABASE

# Get list of unused indexes
$PSQL_PATH  -c "copy(SELECT schemaname || '.' || relname AS table, indexrelname AS index, pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size, idx_scan as index_scans FROM pg_stat_user_indexes ui JOIN pg_index i ON ui.indexrelid = i.indexrelid WHERE NOT indisunique AND idx_scan < 50 AND pg_relation_size(relid) > 5 * 8192 ORDER BY pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) DESC NULLS FIRST, pg_relation_size(i.indexrelid) DESC) to '$HOME/unused_indexes.csv' with (format csv , delimiter ',' , header true)" -U $PGUSER -d $PGDATABASE

# Get total size of all unused indexes
$PSQL_PATH  -c "copy(SELECT pg_size_pretty(sum(pg_relation_size(i.indexrelid))::bigint) AS total_unused_index_size FROM pg_stat_user_indexes ui JOIN pg_index i ON ui.indexrelid = i.indexrelid WHERE NOT indisunique AND idx_scan < 0) to '$HOME/unused_indexes_total_size.csv' with (format csv , delimiter ',' , header true)" -U $PGUSER -d $PGDATABASE

# Possibility of missing indexes
$PSQL_PATH  -c "copy(select schemaname, relname, seq_scan, idx_scan, (seq_scan - coalesce(idx_scan, 0)) as diff from pg_stat_user_tables order by diff desc limit 20) to '$HOME/missing_indexes.csv' with (format csv , delimiter ',' , header true)" -U $PGUSER -d $PGDATABASE

#!/usr/bin/bash

set -e
set -x

# create directory and switch to it
mkdir $HOME/pg_health_audit
cd $HOME/pg_health_audit

git clone https://github.com/dalibo/pgbadger.git

git clone https://github.com/gregs1104/pgtune.git

git clone https://github.com/payals/system_monitoring.git

mkdir boxinfo
cd boxinfo
wget http://bucardo.org/downloads/boxinfo.pl
cd

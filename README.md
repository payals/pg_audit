pg_audit
========

This is a set of scripts that parse and graph system_monitoring logs. 

Right now it only has the capability to create line graphs of a day's worth of logs. The following graphs are available as of now:

1. Memory Used
2. CPU Usage
3. Reads per disk
4. Writes per disk
5. Response and service times
6. Total connection to postgres
7. Locks:

      => Locks by type
      => Locks waiting

Installing:
===========

git clone https://github.com/payals/pg_audit.git

Usage:
======

Modify config options in parse_logs.sh, namely, set the paths for logs location, output location, and complete path to the parsers directory in this repo from your $HOME.

Run parse_logs.sh -h - This will tell you which options to use for graph types.

Run parse_logs.sh with desired options. The parsed files will now be created. 

Move pg_audit/charts/multiline.html to your web server's folder and open it in browser. Choose the parsed file you wish to graph and it will be created. 

Right now the only way to store a graph is to take a screenshot, png download will be added shortly.

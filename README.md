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

LICENCE:
========
pg_viz is under the PostgreSQL License.

Copyright (c) 2014 Payal Singh.

Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without a written agreement is hereby granted, provided that the above copyright notice and this paragraph and the following two paragraphs appear in all copies.

IN NO EVENT SHALL THE AUTHOR BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE AUTHOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

THE AUTHOR SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE AUTHOR HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

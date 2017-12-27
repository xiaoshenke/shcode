#!/bin/bash
sqoop import --connect jdbc:postgresql://xxxxx --username xxx --password xxx --hive-import --table aaa.bbb  --where 'limit 2'  --hive-table test.xxx -m 1 --driver org.postgresql.Driver --create-hive-table






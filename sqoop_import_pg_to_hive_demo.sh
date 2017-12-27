#!/bin/bash

sqoop import --connect jdbc:postgresql://xxxyyyyy --hcatalog-database aaa --hcatalog-table bbb -m 1 --hive-overwrite --username xxxx --password yyyyy --table aaa.bbb --driver org.postgresql.Driver 


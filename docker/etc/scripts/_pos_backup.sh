#!/bin/bash

i=$1
t=$2
e=$3

CAMINHO="/opt/bacula/etc/scripts"

#$CAMINHO/_webacula_update_filesize.sh $i $t $e
$CAMINHO/_send_telegram.sh $1

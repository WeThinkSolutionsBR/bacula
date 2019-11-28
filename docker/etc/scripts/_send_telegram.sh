#!/bin/bash

Cliente="@CLIENTE@"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Config
bconsole=`which bconsole`
curl=`which curl`
# Use @BotFather to create a bot an get the API token
# Telegram config
api_token="@BOT_TOKEN@"
# Send a message to bot and
# Open in browser the url https://api.telegram.org/bot${API_TOKEN}/getUpdates and get the id value os user
id="@ID_DESTINO"
log="/var/log/telegram.log"

Cabecalho="👮 Status do Backup 👮"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Function to convert bytes for human readable
b2h(){
    # spotted script @: http://www.linuxjournal.com/article/9293?page=0,1
    slist=" Bytes, KB, MB, GB, TB, PB, EB, ZB, YB"
    power=1
    val=$( echo "scale=2; $1 / 1" | bc)
    vint=$( echo $val / 1024 | bc )
    while [ ! $vint = "0" ];
      do
       let power=power+1
       val=$( echo "scale=2; $val / 1024" | bc)
       vint=$( echo $val / 1024 | bc )
      done
    echo $val$( echo $slist  | cut -f$power -d, )
}
# end function

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Is necessary to include in the Catalog Resource
# the option "dbdriver" (PostgreSQL or MySQL)
# Catalog {
#   ...
#   dbdriver = "MySQL" or dbdriver = "PostgreSQL"
#   ...
#  }

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# SQL query to get data from Job (MySQL)
query_mysql="select Job.Name, Job.JobId,(select Client.Name from Client where Client.ClientId = Job.ClientId) as Client, Job.JobBytes, Job.JobFiles, case when Job.Level = 'F' then 'Full' when Job.Level = 'I' then 'Incremental' when Job.Level = 'D' then 'Differential' end as Level, (select Pool.Name from Pool where Pool.PoolId = Job.PoolId) as Pool, (select Storage.Name  from JobMedia left join Media on (Media.MediaId = JobMedia.MediaId) left join Storage on (Media.StorageId = Storage.StorageId) where JobMedia.JobId = Job.JobId limit 1 ) as Storage, date_format( Job.StartTime , '%d/%m/%Y %H:%i:%s' ) as StartTime, date_format( Job.EndTime , '%d/%m/%Y %H:%i:%s' ) as EndTime, sec_to_time(TIMESTAMPDIFF(SECOND,Job.StartTime,Job.EndTime)) as Duration, Job.JobStatus, (select Status.JobStatusLong from Status where Job.JobStatus = Status.JobStatus) as JobStatusLong from Job where Job.JobId=$1;"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# SQL query to get data from Job (PostgreSQL)
query_pgsql="select Job.Name, Job.JobId,(select Client.Name from Client where Client.ClientId = Job.ClientId) as Client, Job.JobBytes, Job.JobFiles, case when Job.Level = 'F' then 'Full' when Job.Level = 'I' then 'Incremental' when Job.Level = 'D' then 'Differential' end as Level, (select Pool.Name from Pool where Pool.PoolId = Job.PoolId) as Pool, (select Storage.Name from JobMedia left join Media on (Media.MediaId = JobMedia.MediaId) left join Storage on (Media.StorageId = Storage.StorageId) where JobMedia.JobId = Job.JobId limit 1 ) as Storage, to_char(Job.StartTime, 'DD/MM/YY HH24:MI:SS') as StartTime, to_char(Job.EndTime, 'DD/MM/YY HH24:MI:SS') as EndTime, to_char(endtime-starttime,'HH24:MI:SS') as Duration, Job.JobStatus, (select Status.JobStatusLong from Status where Job.JobStatus = Status.JobStatus) as JobStatusLong from Job where Job.JobId=$1;"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Check database driver (PostgreSQL or MySQL)
check_database=`echo "show catalog" | ${bconsole} | grep -i "pgsql\|postgresql" | wc -l`
if [ $check_database -eq 1 ]; then
   sql_query=$query_pgsql
else
  sql_query=$query_mysql
fi

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Execute command in bconsole
var="$(cat <<EOF
gui on
sqlquery
${sql_query}

exit
EOF
)"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Execute SQL and get data from bconsole
str=`echo "$var" | ${bconsole} |  grep "[\|]" | grep -vi "JobId" | sed 's/[[:space:]]*|[[:space:]]*/|/g' | sed 's/^|//g'`
JobName=`echo ${str} | cut -d"|" -f1`
JobId=`echo ${str} | cut -d"|" -f2`
Client=`echo ${str} | cut -d"|" -f3`
JobBytes=`b2h $(echo ${str} | cut -d"|" -f4 | sed 's/,//g')`
JobFiles=`echo ${str} | cut -d"|" -f5`
Level=`echo ${str} | cut -d"|" -f6`
Pool=`echo ${str} | cut -d"|" -f7`
Storage=`echo ${str} | cut -d"|" -f8`
StartTime=`echo ${str} | cut -d"|" -f9`
EndTime=`echo ${str} | cut -d"|" -f10`
Duration=`echo ${str} | cut -d"|" -f11`
JobStatus=`echo ${str} | cut -d"|" -f12`
Status=`echo ${str} | cut -d"|" -f13`

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Emojis
# OK
# http://emojipedia.org/white-heavy-check-mark/
# Not OK
# http://emojipedia.org/cross-mark/
# Floppy Disk
# http://emojipedia.org/floppy-disk/
# Different header in case of error
if [ "${JobStatus}" == "T" ] ; then
   header="✅ WeThink Backup ✅ /n"  # OK
else
   header="🚨 WeThink Backup 🚨 /n"  # Error
fi

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Format output of message
message="<b>${Cabecalho}</b> /n/n"
message="$message <b>${header}</b>/n"
message="$message 👨🏻‍💻 <b>Cliente: ${Cliente}</b>/n/n"
message="$message <b>Nome:</b> ${JobName}/n"
message="$message <b>Jobid:</b> ${JobId}/n"
message="$message <b>Client:</b> ${Client}/n"
message="$message <b>Tamanho:</b> ${JobBytes}/n"
message="$message <b>Arquivos:</b> ${JobFiles}/n"
message="$message <b>Tipo:</b> ${Level}/n"
message="$message <b>Pool:</b> ${Pool}/n"
message="$message <b>Storage:</b> ${Storage}/n"
message="$message <b>Início:</b> ${StartTime}/n"
message="$message <b>Fim:</b> ${EndTime}/n"
message="$message <b>Duração:</b> ${Duration}/n"
message="$message <b>JobStatus:</b> ${JobStatus}/n"
message="$message <b>Status:</b> ${Status}"

messagelog="Message: JobName=${JobName} | Jobid=${JobId} | Client=${Client} | JobBytes=${JobBytes} | Level=${Level} | Status=${Status}"
message=`echo ${message} | sed 's/\/n/%0A/g'`
message=`echo ${message} | sed 's/ /%20/g'`
url="https://api.telegram.org/bot${api_token}/sendMessage?chat_id=${id}&parse_mode=HTML&text=${message}"


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Loop multiple tries
count=1
while [ ${count} -le 20 ]; do

   echo "$(date +%d/%m/%Y\ %H:%M:%S) - Start message send (attempt ${count}) ..." >> ${log}
   echo "$(date +%d/%m/%Y\ %H:%M:%S) - ${messagelog}" >> ${log}
   ${curl} -s "${url}" > /dev/null
   ret=$?

   if [ ${ret} -eq 0 ]; then
     echo "$(date +%d/%m/%Y\ %H:%M:%S) - Attempt ${count} executed successfully!" >> ${log}
#     url="https://api.telegram.org/bot${api_token}/getUpdates"
#     ${curl} -s "${url}"
     exit 0
   else
     echo "$(date +%d/%m/%Y\ %H:%M:%S) - Attempt ${count} failed!" >> ${log}
     echo "$(date +%d/%m/%Y\ %H:%M:%S) - Waiting 30 seconds before retry ..." >> ${log}
     sleep 30
     (( count++ ))
   fi

done

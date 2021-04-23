
LOGFILE=/home/ubuntu/todays_MCC_servers.logfile
rm -f $LOGFILE

INPUT=${1:-SETUP}

sudo systemctl start docker

# Ensure nothing is running on the moment
while [ `docker ps | wc -l` -ne 1 ] 
do
  PS=`docker ps | tail -1 | awk '{print $1}'`
  docker stop $PS
  docker rm $PS
done

# Ok, lets kick things off
ORIG=`pwd`
cd ~/kaas-bootstrap
. ./sourceme.ksh

if [ `echo "$INPUT" | grep "clean" | wc -l` -eq 1 ]
then
  # CLEANUP
  ./bootstrap.sh cleanup 
else
  # THERE WE GO
  ./bootstrap.sh all | tee $LOGFILE
  echo "----------------------------" >> $LOGFILE
  cat passwords.yaml >> $LOGFILE

  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  cat $LOGFILE
  echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi
cd $ORIG


DATE=`date "+%y%m%d"`

#######################################################
# Install docker first
#######################################################
if [ -f /usr/bin/docker ]
then
  if [ `docker images | grep "REPOSITORY" |wc -l` -eq 1 ]
  then
	  echo "Docker is install correctly"
  else
	  sudo apt-get update
	  sudo apt install docker.io
	  sudo usermod -aG docker $USER
	  echo "Docker is now installed - please logoff, login again and start me for a second time!"
	  exit
  fi
else
	  sudo apt-get update
	  sudo apt install docker.io
	  sudo usermod -aG docker $USER
	  echo "Docker is now installed - please logoff, login again and start me for a second time!"
	  exit
fi


#######################################################
# Other checks
#######################################################
# License file
if [ -f /home/ubuntu/mirantis.lic ] 
then
	echo "Good you have a license file"
else
	echo "No license file found in /home/ubuntu"
	echo "Get a license file at https://www.mirantis.com/download/mirantis-cloud-native-platform/mirantis-container-cloud/"
	exit 1
fi

# Sourceme file
if [[ -f /home/ubuntu/sourceme.ksh && `cat /home/ubuntu/sourceme.ksh | grep "<" | wc -l` -eq 0 ]} 
then
	echo "Great! You have the sourceme.ksh file already "
else
	echo "No sourceme.ksh file found in /home/ubuntu"
	echo "Create a file called /home/ubuntu/sourceme.ksh filled with the following content"
	echo "export KAAS_AWS_ENABLED=true"
	echo "export AWS_DEFAULT_REGION=<YOUR REGION YOU WANT TO DEPLOY>"
	echo "export AWS_ACCESS_KEY_ID=\"<YOUR AWS ACCESSKEY OF bootstrapper user with yourname (See IAM)>\""
	echo "export AWS_SECRET_ACCESS_KEY=\"<YOUR AWS SECRET ACCESSKEY>"\
	exit 1
fi

#######################################################
# Old stuff will be here...
#######################################################
if [ ! -d /home/ubuntu/old ]
then
  mkdir /home/ubuntu/old
fi

#######################################################
# Get latests and greatest
#######################################################
if [ -f get_container_cloud.sh ]
then
	mv get_container_cloud.sh old/get_container_cloud${DATE}.sh
fi

wget https://binary.mirantis.com/releases/get_container_cloud.sh
chmod 755 get_container_cloud.sh
LATEST=`grep "LATEST_KAAS_VERSION=" get_container_cloud.sh `
echo "Latest version we are about to install = $LATEST"


#######################################################
# Install new directory
#######################################################
if [ -d /home/ubuntu/kaas-bootstrap ]
then
	echo "Old directory is still here"
	tar cf kaas-bootstrap_${DATE}.tar kaas-bootstrap/
	mv kaas-bootstrap_${DATE}.tar /home/ubuntu/old/
	rm -rf kaas-bootstrap/
fi
./get_container_cloud.sh


# Plaats licentiefile
cp mirantis.lic kaas-bootstrap/mirantis.lic

# Change AMI
FILE=~/kaas-bootstrap/templates/aws/machines.yaml.template
REPLACEAMI=`cat $FILE | grep "ami-" | cut -f 2 -d":" | awk '{print $1}' `
# FILL IN YOUR AMI ID IN YOUR REGION (AMI number differs per region), and I will do the magic... ;-)!!
TOAMI="ami-0e0102e3ff768559b"

# MAGIC
cat $FILE | sed "s/${REPLACEAMI}/${TOAMI}/g" > ${FILE}.1
mv ${FILE}.1 ${FILE}


# Source the AWS parameters
. ./sourceme.ksh
cp sourceme.ksh kaas-bootstrap/

# Kick start_my_MCC_cluster.ksh script


# The other script
if [ -f /home/ubuntu/start_my_MCC_cluster.ksh ] 
then
     echo "Fantastic! You have the start_my_MCC_sluter.ksh file - Lets start building"
     ./start_my_MCC_cluster.ksh
else
    echo "You are missing the start_my_MCC_cluster.ksh script!"
    echo "Sorry buddy, you have to do the installation manually...."
    exit 1
fi




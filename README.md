# MCC_install_make_easy
Full installation of latests MCC

# Installation of latetst Mirantis Container Cloud by Robert Hartevelt - Presales NEMEA
# Intro
# I'm just 3 weeks in Mirantis and found for a new hire the procedure to install MCC confusing at same times...
# Therefore this script to make things more automated


# Prepare: Please take care of the following things
- You have an ubuntu t3.2xLarge AWS instance (otherwise the Kaas (Kubernetes as a service doesn't run)
- You have collected a mirantis.lic file (license file from our website)
- You have created a sourceme.ksh script with your AWS variables to your bootstrapper user in IAM and create keys to use (if needed)
- You have changed the AMI-id number in the script (TOAMI) to a AMI-id in your region (as AMI-id differ per region in AWS).
- You have docker installed or run the script twice (the first time it will install docker for you).

# And then run the script
./install_MCC_from_scratch.ksh

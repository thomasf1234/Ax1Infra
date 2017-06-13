#!/bin/bash
#######################################
# bootstrap.bash :: TF / SC 
#######################################
export DEBIAN_FRONTEND=noninteractive
BASENAME=`basename $0`
function exit_on_error {
  local EXIT_STATUS=$1

  if [[ $EXIT_STATUS -ne 0 ]]
  then
    exit $EXIT_STATUS
  fi
}

function logit {
  local LOGOUTPUT=$1
  echo "#${BASENAME} :: ${LOGOUTPUT}"
}
#######################################

logit "bootstrap start"
CURRENT_USER=$(whoami)

if [[ "${CURRENT_USER}" != "root" ]]
then
  logit  "Must be run as root"
  exit 1
fi

#updates
apt-get -y update
apt-get -y upgrade

apt-get -y install build-essential linux-headers-$(uname -r) dkms

#update grub timeout to avoid hangs on boot
sed -i 's/.*GRUB_HIDDEN_TIMEOUT=.*/GRUB_HIDDEN_TIMEOUT=0/' /etc/default/grub
sed -i 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
update-grub

#disable unattended upgrades
sed -i 's/.*APT::Periodic::Update-Package-Lists.*/APT::Periodic::Update-Package-Lists "0";/' /etc/apt/apt.conf.d/10periodic

USER=deploy
SUDOFILE=/etc/sudoers.d/${USER}
HOST=$(uname -n)
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFfPCam127dW+J+Dfm2BulVjQ99YE+3IQaIsqk4PZrL0uqrDZ40Mf0T5FvuTSUgCt36WlFF+ot45tMgEuieDmjws5RZ3x9ebcKAIMm+ElPYuCYQsknzM22q59T+RUusJCPizpJbuhRjvVCJIlw82qBpzwFBCNTEpM755Qdtkk8dwq2lZxC/YtTMmxEmqESsCfVNDrzLLUihyTr2gLcvLQd0GnZuJrrjt3J7UMmPJag5QffqXjAZOSSXbAMYdH9HvPp2W83QRyNY4wZYXOUYk8JilkjaJCb7i8+NyMkPr2IwIL5oZlhOyVZgqKZteFLI0obRvUji4p0LklxsxfVQ7Tn ${USER}@${HOST}"

id -u ${USER} > /dev/null 2>&1

#if user does not exist
if [[ $? -ne 0 ]]
then
  logit "add the user and group"
  adduser --disabled-password --gecos "deploy" ${USER}

  #if error adding user
  exit_on_error $?
fi

logit "passwordless sudo for user"
echo "${USER} ALL=(ALL) NOPASSWD:ALL" > ${SUDOFILE}
exit_on_error $?

logit "create .ssh directory"
mkdir -p /home/${USER}/.ssh
exit_on_error $?

logit "correct .ssh permissions"
chmod 0700 /home/${USER}/.ssh
exit_on_error $?
chown ${USER}:${USER} /home/${USER}/.ssh
exit_on_error $?

logit "add the public key"
echo $SSH_PUBLIC_KEY > /home/${USER}/.ssh/authorized_keys
exit_on_error $?

logit "correct .ssh/authorized_keys permissions"
chmod 0600 /home/${USER}/.ssh/authorized_keys
exit_on_error $?
chown ${USER}:${USER} /home/${USER}/.ssh/authorized_keys
exit_on_error $?

#check in future what the latest version of repo(dep)
logit "checking if puppet installed"
/opt/puppetlabs/bin/puppet --version

if [[ $? -ne 0 ]]
then
  logit "puppet not found, attempting to install now"
  logit "downloading and verifying puppet debian package"
  PUPPET_DEBIAN=puppetlabs-release-pc1-xenial.deb
  PUPPET_DEBIAN_SHA256=6ae74052f278d4ee1ba13859d262d28c86f991247c572f0f70d01965d8555667
  wget --quiet --output-document=/tmp/$PUPPET_DEBIAN https://apt.puppetlabs.com/$PUPPET_DEBIAN
  exit_on_error $?
  echo "$PUPPET_DEBIAN_SHA256 /tmp/$PUPPET_DEBIAN" >  /tmp/$PUPPET_DEBIAN_verify.sha256
  sha256sum -c /tmp/$PUPPET_DEBIAN_verify.sha256
  exit_on_error $?

  #install puppet
  dpkg -i /tmp/$PUPPET_DEBIAN
  apt-get update
  apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet-agent
  rm -rf /tmp/$PUPPET_DEBIAN
else
  logit "puppet found... continuing."
fi

logit "disabling default puppet services"
systemctl disable mcollective.service
systemctl disable puppet.service
service puppet stop
service mcollective stop

logit "removing default puppet template"
rm -rf /etc/puppetlabs/*

apt-get -y install openssh-server

#refresh ssh keys because they may not be valid or present
rm -r /etc/ssh/ssh*key
dpkg-reconfigure openssh-server
service ssh restart

apt-get -y install vim
apt-get -y install sudo
apt-get -y install cron

#clean caches
apt-get autoclean
apt-get clean

logit "bootstrap finished"





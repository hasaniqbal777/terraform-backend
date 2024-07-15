#!/bin/bash

source "${BASH_SOURCE%/*}/../common.sh"

################################################################################
# AWS CLI                                                                      #
################################################################################
if [ -z "$(type -p aws)" ] ; then
    c_echo $YELLOW "awscli required... installing via curl"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws
    rm awscliv2.zip 
else
    c_echo $GREEN "awscli is already installed"
fi

################################################################################
# tfenv                                                                        #
################################################################################
if [ -z "$(type -p tfenv)" ] ; then
    c_echo $YELLOW "tfenv required for terraform... installing"
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
    ln -s ~/.tfenv/bin/* /usr/local/bin
else
    c_echo $GREEN "tfenv is already installed"
fi

################################################################################
# terrraform                                                                   #
################################################################################
c_echo $YELLOW "Forcing install and usage of required terraform version..."
pushd $TERRAFORM_PATH
tfenv install min-required
tfenv use min-required
popd

################################################################################
# Setting up terrraform                                                        #
################################################################################
c_echo $YELLOW "Setting terraform workspace for development..."

u=dev$(id -un)
u=$(echo $u | tr '[:upper:]' '[:lower:]')
workspace=${u// /}

pushd $TERRAFORM_PATH
terraform init

if terraform workspace list | grep -q $workspace; then
    c_echo $GREEN "Terraform workspace $workspace already exists"
else
    c_echo $YELLOW "Creating terraform workspace $workspace..."
    terraform workspace new $workspace
fi

c_echo $YELLOW "Setting terraform workspace to $workspace for development..."
terraform workspace select -or-create $ENVIRONMENT

popd

################################################################################
# Setting up config                                                            #
################################################################################
if [[ -f ./configs/$workspace.json ]]; then
    c_echo $GREEN "The config $workspace.json already exists"
else
    c_echo $YELLOW "Creation config for $workspace..."
    cat ./configs/setup-template.json | sed "s/\<workspace\>/$workspace/g" > ./configs/$workspace.json
fi

echo
c_echo $GREEN "Your dev workspace is: $workspace"
echo 
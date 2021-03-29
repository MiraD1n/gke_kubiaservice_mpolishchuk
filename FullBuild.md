############## System prepeare
apt-get update && apt-get install -y curl git software-properties-common
############## Install Terraform
					https://learn.hashicorp.com/tutorials/terraform/install-cli
					--------error---------bash: apt-add-repository: command not found
					apt-get -y install software-properties-common
					------------------------------------------------------------
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get -y update && apt-get -y install terraform
					#terraform -help
############## Install GCloud
					https://cloud.google.com/sdk/docs/install#deb
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get install -y apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update && apt-get install -y google-cloud-sdk
############## Install kubectl
apt-get -y install kubectl
gcloud init
https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
[2] Create a new project
PROJECT_ID
Enable Kubernetes API

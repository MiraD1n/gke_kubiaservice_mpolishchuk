# Prepare Environment
1. [Install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Install GCloudSDK](https://cloud.google.com/sdk/docs/install)
3. [Install Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)
(*do not forget Enable Kubernetes API*)
4. [Create PROJECT](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
5. [Configure cluster access for kubectl](
https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)
5. [Create service account keys JSON](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console)
(~~*better via Console*~~)
6. Rename account key JSON into gcpkey.json and put it in the current project folder
7. Done

# Deploy luksa/kubia service via terraform in GKE
1. Run
   ```
   ./auto_deploy.bash
   ```
2. Enter PROJECT ID
3. Wait until "Smoke test" will show response HTTP code.
9. Done

# Smoke test
After deploying service kubia in GKE, the bash script will check and show HTTP response code from service public IP.

  # Stop cluster
  After work with cluster run
1. Run
   ```
   terraform destroy
   ```
2. PROJECT ID
3. Type
   ```
   Yes
   ```
4. Done

###### PS. Full list of used command contained in [FullBuild.md](https://github.com/MiraD1n/gke_kubiaservice_mpolishchuk/blob/main/FullBuild.md)

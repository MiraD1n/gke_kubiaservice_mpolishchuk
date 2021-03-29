#!/bin/bash
########################### Check HTTP response function
get_srv_status ()
{
set -u
set -e
url=${1:-'http://'$external_ip':8080'}
timeout=${2:-'5'}
#            ^in seconds
flag=${3:-'--status'}
#    curl options, e.g. -L to follow redirects
arg4=${4:-''}
arg5=${5:-''}
arg6=${6:-''}
arg7=${7:-''}
curlops="$arg4 $arg5 $arg6 $arg7"

#      __________ get the CODE which is numeric:
code=`echo $(curl --write-out %{http_code} --silent -S --connect-timeout $timeout \
                  --no-keepalive $curlops --output /dev/null  $url)`
                  #  though curl is --silent, -S will show its errors.


#      __________ get the STATUS (from code) which is human interpretable:
case $code in
     000) status="Not responding within $timeout seconds" ;;
     100) status="Informational: Continue" ;;
     101) status="Informational: Switching Protocols" ;;
     200) status="Successful: OK within $timeout seconds" ;;
     201) status="Successful: Created" ;;
     202) status="Successful: Accepted" ;;
     203) status="Successful: Non-Authoritative Information" ;;
     204) status="Successful: No Content" ;;
     205) status="Successful: Reset Content" ;;
     206) status="Successful: Partial Content" ;;
     300) status="Redirection: Multiple Choices" ;;
     301) status="Redirection: Moved Permanently" ;;
     302) status="Redirection: Found residing temporarily under different URI" ;;
     303) status="Redirection: See Other" ;;
     304) status="Redirection: Not Modified" ;;
     305) status="Redirection: Use Proxy" ;;
     306) status="Redirection: status not defined" ;;
     307) status="Redirection: Temporary Redirect" ;;
     400) status="Client Error: Bad Request" ;;
     401) status="Client Error: Unauthorized" ;;
     402) status="Client Error: Payment Required" ;;
     403) status="Client Error: Forbidden" ;;
     404) status="Client Error: Not Found" ;;
     405) status="Client Error: Method Not Allowed" ;;
     406) status="Client Error: Not Acceptable" ;;
     407) status="Client Error: Proxy Authentication Required" ;;
     408) status="Client Error: Request Timeout within $timeout seconds" ;;
     409) status="Client Error: Conflict" ;;
     410) status="Client Error: Gone" ;;
     411) status="Client Error: Length Required" ;;
     412) status="Client Error: Precondition Failed" ;;
     413) status="Client Error: Request Entity Too Large" ;;
     414) status="Client Error: Request-URI Too Long" ;;
     415) status="Client Error: Unsupported Media Type" ;;
     416) status="Client Error: Requested Range Not Satisfiable" ;;
     417) status="Client Error: Expectation Failed" ;;
     500) status="Server Error: Internal Server Error" ;;
     501) status="Server Error: Not Implemented" ;;
     502) status="Server Error: Bad Gateway" ;;
     503) status="Server Error: Service Unavailable" ;;
     504) status="Server Error: Gateway Timeout within $timeout seconds" ;;
     505) status="Server Error: HTTP Version Not Supported" ;;
     *)   echo " !!  httpstatus: status not defined." && exit 1 ;;
esac
}
############################ Get service ip function
get_ext_ip () {
external_ip=""
while [ -z $external_ip ]; do
  echo "Waiting for end point..."
  external_ip=$(kubectl get svc kubia-service --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$external_ip" ] && sleep 50
done
}
########################### System information return functions
return_ok()
{
	echo -e "Service is UP and running";
  echo -e "Service HTTP Response CODE:" $code
    exit 0
}
return_fail()
{
   echo -e "Service is DOWN"
   echo -e "Tried to check" $external_ip "by port 8080"
	 echo -e "Service HTTP Response CODE:" $code
    exit 1
}

########################## Get PROJECT ID
echo Please insert project id?
read var_projectid
export TF_VAR_project=$var_projectid

########################### Deploy cluster kubia-cluster via terraform
terraform init
terraform apply -auto-approve

########################## Get credentials
gcloud container clusters get-credentials kubia-cluster --zone us-central1

########################### Deploy deployment kubia-deployment and service kubia-service
kubectl apply --filename gcp_deploy.yaml

get_ext_ip;
get_srv_status;
########################### Simplest wmoke test to get 200 http code from service
if [ $code = "200" ]; then
		 return_ok;
fi
return_fail;
exit 1

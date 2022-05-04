	• Kops is a software use to create production ready k8s cluster in a cloud provider like AWS.
	• Kops supports multiple cloud providers
	• Kops compete with managed kubernestes services like EKS, AKS and GKE
	• Kops is cheaper than the others.
	• Kops create production ready K8S.
	• Kops create resources like: LoadBalancers, ASG, Launch Configuration, Worker nodes, Master node (CONTROL PLANE).
	• Kops is IaaC

	1. Create Ubuntu EC2 instance in AWS 
  
	2. Use installation script to install docker, Jenkins, AWS cli, Python3, Kops and kubectl
  
	3. Create an IAM role from AWS Console or CLI with below Policies.
	- AmazonEC2FullAccess 
	- AmazonS3FullAccess
	- IAMFullAccess 
	- AmazonVPCFullAccess


	4. Then Attach IAM role to ubuntu server from Console 
Select KOPS Server --> Actions --> Instance Settings --> Attach/Replace IAM Role --> Select the role which You Created. --> Save.

	5. Create an S3 bucket by executing the command below in the KOPS Server. 
Note: Use a unique bucket name if you get bucket name exists error.
aws s3 mb s3://<bucketname>
aws s3 ls   #this will display the s3 bucket that was created
ex: s3://<bucketname>
 
	6. Expose environment variable:
#Add env variables in bashrc using the command below
vi .bashrc
#Give unique name to the S3 bucket which you created.
export NAME=<name-of-kops>
export KOPS_STATE_STORE=s3://<bucketname>

#refresh .bashrc with the command below

source .bashrc
  
	7. Create sshkeys before creating cluster
  
	8. ssh-keygen

	9. Create kubernetes cluster definitions on S3 bucket. The example below will create 3 nodes in us-east-2c (1 master and 2 workers of instance type t2medium)

kops create cluster --zones us-east-2c --networking weave --master-size t2.medium --master-count 1 --node-size t2.medium --node-count=2 ${NAME}

kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
  
	10. Create kubernetes cluster
 kops update cluster ${NAME} --yes --admin
  
	11. Validate your cluster(KOPS will take some time to create cluster , Execute below command after 3 or 4 mins)
   kops validate cluster
  
	12. Connect to the master node
sh -i ~/.ssh/id_rsa ubuntu@ipAddress   #example below
ssh -i ~/.ssh/id_rsa ubuntu@ec2-54-241-117-61.us-west-1.compute.amazonaws.com
  
	13. To list nodes
  
  kubectl get nodes 
  
	14.  To Delete Cluster
kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE} --yes


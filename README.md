Overview
When an application is deployed in an OCP container, it runs as a user ID generated from a specific range assigned to the project. This overrides the user ID which the application image defines it wants to be run as.  Running the application using a different id might result in it failing to start.


The best solution is to build the application image so it can be run as an arbitrary user ID. This avoids the risks associated with having to run an application as the root user ID, or other fixed user ID which may be shared with applications in other projects.


If an image can't be modified, you can elect to override the default security configuration of OpenShift and have it run as the user the image specifies, but this can only be done by an OpenShift cluster administrator.  This cannot be done by normal developers, nor a project administrator. 


To run the application with a specific user id, these are the steps required:

Create a service account (Optional, but recommended)
Associate the service account with a non-root security context constraint which allows a pod to run using a specific user id.
Associate the service account in the deployment configuration.
Specify the userid in the deployment configuration.

The following sections describe the detailed steps.

1. Create a service account (optional)
A service account in OCP is just like a regular OCP user account. It provides a way to control API access without sharing a regular user’s credentials. It has an associated user name that can be granted with roles, just like a regular user. The user name is derived from its project and name:

system:serviceaccount:<project>:<name>
1.1. Default service accounts
Three service accounts are automatically created in every project:

Service Account
Usage
builder

Used by build pods. It allows pushing images to any image stream in the project using the internal Docker registry.

deployer

Used by deployment pods.  It allows viewing and modifying replication controllers and pods in the project.

default

Used to run all other pods unless they specify a different service account.


To get a list of service accounts in the current project:


oc command to list sa

$ oc get sa

NAME       SECRETS   AGE

builder    2         2d

default    2         2d

deployer   2         2d


As per discussion above, the default service account is used to run all pods in the project.  It is associated with the restricted security context constraint (scc), which only allows pods to run using an assigned random id by OCP.  


For applications need to run using a specific user id, it is recommended to create a service account and use it to run the pod with a specific userid and leave other pods to use the default service account.


To create a new service account:

oc command to create a service account

$ oc create sa non-root-user-id

serviceaccount/non-root-user-id created

2. Associate the service account with a non-root security context constraint
To assign the non-root scc to a service account, you need to have the cluster admin privilege.  A service ticket can be submitted for this request.  


Here is a sample ticket requesting non-root scc assigned to the "non-root-user-id" service account created from the previous step.

3. Associate the service account in the deployment configuration
Once the service account is created, it needs to be configured in the deployment configuration.  The following highlighted lines need to be inserted in deployment configuration template to take the service account as a parameter.  








The service account name is configured in the ocp_params.txt file in the common directory which applies to all the environments from dev to prod.



4. Specify the user id in the deployment configuration
For service account associated with the non-root scc, the userid also needs be configured in the deployment configuration.  The following highlighted lines need to be inserted in deployment configuration template to take the userid as a parameter.






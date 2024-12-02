1. First Created EKS clsuter using terraform HCL script 
**main.tf** file added  this file conatain all EKS configuration as of now things are hardcoded for this task

2. Created deployment, Service, HPA files for kubernetes deployment.
**deployment**  deploy app
**service**     access on defined services (LoadBalancer)
**HPA**         scale the app if load is increaded memeory or cpu utalization is increased.(up to 3 pod/replica)

3. created sample app "hello kubernetes"
**Dockerfile**  created this file will build docker images and pushed to DockerHub repo public access.

4. User can access the service on External LoadBalancer
**LoadBalancer**

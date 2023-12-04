# stop_start_instances  
## Automate the stop & start of EC2 instances to optimize costs    

Lambda runs the actual python functions that start and stop instances, while Eventbridge sets a schedule and triggers the Lambda functions at specified times. With a focus on automation and intelligent strategies, you can effectively reduce AWS expenditure without compromise on performance or functionality.  

![stop_start drawio (1)](https://github.com/Lily-G1/stop_start_instances/assets/104821662/2e0feeee-50d1-45ea-8b51-89d0af1252d2)  

## Prerequisites
- An AWS account  
- Terraform installed on your local system  
- One or more running AWS instances  

## To run:  
- Clone this repo  
- Enter root directory: ```cd stop_start_instances```        
- Enter AWS instances' IDs in .py files  
- Edit the cron expressions in eventbridge.tf to specify your time schedules  
- ```terraform init```
- ```terraform plan```
- ```terraform apply```

## To destroy:  
- ```terraform destroy```

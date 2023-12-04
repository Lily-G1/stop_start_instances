# stop_start_instances  
## Automate the stop & start of EC2 instances to optimize costs    

Lambda runs the actual python functions that start and stop instances, while Eventbridge sets a schedule and triggers the Lambda functions at specified times. With a focus on automation and intelligent strategies, you can effectively reduce AWS expenditure without compromise on performance or functionality.

## Prerequisites
- An AWS account  
- Terraform installed on your local system  
- One or more running AWS instances  

## To run:  
- Clone this repo  
- cd into root directory: ==stop_start_instances==    
- Enter AWS instances' IDs in .py files  
- Edit the cron expressions in eventbridge.tf to specify your time schedules  
- ```terraform init```
- ```terraform plan```
- ```terraform apply```

## To destroy:  
- ```terraform destroy```
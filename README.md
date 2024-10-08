# HTTP Service Deployment Task
## Steps

#### 1- Create IAM Role for EC2
1. Create a token from any repository store and put it in secret manager
![image](https://github.com/user-attachments/assets/4a159f9b-bb25-4ce7-b853-cb491d530d02)
2. Then add your IAM Role 
![image](https://github.com/user-attachments/assets/85b2a70d-3515-4058-a7e8-b3edc68359f9)

#### 2- Create EC2 Template 
1. Name it and Choose Default settings
2. Go to advanced details and Add IAM Role & add ```bash Build.sh file ``` to user data to configure the server for dotnetapp
![image](https://github.com/user-attachments/assets/da398e3d-17fa-4e0c-bc2e-14a7feb4749e)

#### 3- Launch EC2
1. Choose Launch EC2 from Template
![image](https://github.com/user-attachments/assets/252dad1e-e190-4517-8f44-48a0bbf0193b)
2.  It will launch ec2 instance with dotnetapp configurations
![image](https://github.com/user-attachments/assets/b210aab7-6d9f-4fd7-94ab-a340d6700faf)

#### 4- Edit your Security Group
1. Add your IP so you can SSH your instance and check all goes right
![image](https://github.com/user-attachments/assets/59440c94-5f5a-4e14-a1f6-36699394e741)

#### 5- SSH to your Instance
1. going to List all files under /var/log ![image](https://github.com/user-attachments/assets/6f30d0d9-f17a-4342-8b63-3c46551899c3)
2. you will notice ```bash cloud-init-output.log``` this file has all configurations logs you put in user data when create Template you can check if there is any error

#### Final Result
![image](https://github.com/user-attachments/assets/fc7b155b-0ea5-4817-83f7-73ba3728d290)

# HTTP Service Deployment Task
## Steps

#### 1- Create IAM Role for EC2
1- Create a token from any repository store and put it in secret manager
![image](https://github.com/user-attachments/assets/4a159f9b-bb25-4ce7-b853-cb491d530d02)
2. Then add your IAM Role 
![image](https://github.com/user-attachments/assets/85b2a70d-3515-4058-a7e8-b3edc68359f9)

#### 2- Create EC2 Template 
1. Name it and Choose Default settings
2. Go to advanced details and Add IAM Role & add Build.sh to user data to configure the server for dotnetapp
![image](https://github.com/user-attachments/assets/da398e3d-17fa-4e0c-bc2e-14a7feb4749e)

#### 3- Launch EC2
1. Launch EC2 from Template
![image](https://github.com/user-attachments/assets/252dad1e-e190-4517-8f44-48a0bbf0193b)

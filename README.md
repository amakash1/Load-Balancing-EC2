
  

# Creating-EC2-Instances

  

1. Open Up AWS Shell

2. Create a shell file Using the Following Command

3. Excecute the following command `nano createEC2.sh`

4. Provide Executable Permissions to the file `chmod +x create-ec2.sh`

5. Paste the code from Folder *Create-EC2*

6. Output
**Shell Script Output**
![alt text](assets/image.png)
**EC2 Instances Landing Page Post Creation**
![alt text](assets/landing_page.png)
**EC2 Instances Providing NGINX Web App**
![alt text](assets/image-1.png)
![alt text](assets/image-2.png)

  

# Creating-TargetGroups and ALB

  

1. Open Up AWS Shell

2. Create a shell file Using the Following Command

3. Excecute the following command `nano createALB.sh`

4. Provide Executable Permissions to the file `chmod +x create-ec2.sh`

5. Paste the code from Folder *Create-EC2*

6. Output
**Application Load Balancer Landing Page Post Creation**
![alt text](assets/ALB_LandingPage.png)
**Target Groups Landing Page Post Creation**
![alt text](assets/Target_Groups.png)
**ALB Redirecting To Instance-1**
![alt text](assets/FinalOutput-1.png)
**ALB Redirecting To Instance-2**
![alt text](assets/FinalOutput-2.png)
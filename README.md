 # 🚀 Jenkins Installation & Docker Integration on AWS EC2

A hands-on DevOps project demonstrating how to install Jenkins on an AWS EC2 Ubuntu instance and integrate Docker for container-based CI/CD pipelines.

---

## 📌 Project Overview

This project covers the complete setup of:

- AWS EC2
- Ubuntu Server
- Java
- Jenkins
- Docker
- Docker Pipeline Plugin

After completing the setup, Jenkins is capable of executing Docker commands and building Docker-based pipelines.

---

## 🎯 Objective

- Launch an AWS EC2 instance
- Install Java
- Install Jenkins
- Configure AWS Security Groups
- Access Jenkins via browser
- Install Docker
- Configure Docker permissions
- Install Docker Pipeline Plugin
- Prepare Jenkins for Docker-based CI/CD

---

# 🏗️ Architecture

```text
               AWS Cloud
                    │
          Ubuntu EC2 Instance
                    │
             Install Java
                    │
            Install Jenkins
                    │
            Open Port 8080
                    │
         Access Jenkins UI
                    │
          Install Docker
                    │
     Add Jenkins to Docker Group
                    │
      Restart Docker & Jenkins
                    │
     Docker-based CI/CD Ready
```

---

# ⚙️ Tech Stack

| Technology | Purpose |
|------------|---------|
| AWS EC2 | Virtual Server |
| Ubuntu | Operating System |
| Java | Required by Jenkins |
| Jenkins | CI/CD Server |
| Docker | Containerization |
| GitHub | Source Code Repository |

---

# 📖 Project Steps

## 1️⃣ Launch EC2 Instance

- Created an Ubuntu EC2 instance
- Connected using SSH

```bash
ssh -i masterkeyforANSIBLE.pem ubuntu@<Public-IP>
```

---

## 2️⃣ Update Packages

```bash
sudo apt update
```

Updates Ubuntu package information.

---

## 3️⃣ Install Java

```bash
sudo apt install openjdk-25-jre-headless

java --version
```

Jenkins requires Java to run.

---

## 4️⃣ Install Jenkins

Add Jenkins Repository

```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
```

```bash
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
```

Install Jenkins

```bash
sudo apt update
sudo apt install jenkins
```

---

## 5️⃣ Verify Jenkins

```bash
ps -ef | grep jenkins
```

Verify the Jenkins service is running.

---

## 6️⃣ Configure AWS Security Group

Open:

- TCP
- Port 8080

This allows browser access to Jenkins.

---

## 7️⃣ Unlock Jenkins

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the password into the Jenkins setup page.

---

## 8️⃣ Install Docker

```bash
sudo apt install docker.io
```

---

## 9️⃣ Configure Docker Permissions

```bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

sudo systemctl restart docker
sudo systemctl restart jenkins
```

---

## 🔟 Install Docker Pipeline Plugin

Navigate to:

```
Manage Jenkins
    ↓
Plugins
    ↓
Available Plugins
    ↓
Docker Pipeline
```

Install and restart Jenkins.

---

# 📂 Final Environment

```
AWS EC2
   │
Ubuntu
   │
Java
   │
Jenkins
   │
Docker
   │
Docker Pipeline Plugin
   │
Docker-based CI/CD Ready
```

---

# 💻 Important Commands

```bash
sudo apt update

sudo apt install openjdk-25-jre-headless

java --version

sudo apt install jenkins

jenkins --version

ps -ef | grep jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo apt install docker.io

sudo usermod -aG docker jenkins

sudo usermod -aG docker ubuntu

sudo systemctl restart docker

sudo systemctl restart jenkins
```

---

# 📚 Key Learnings

- Jenkins is a Java application.
- AWS Security Groups control inbound traffic.
- Jenkins uses port **8080** by default.
- Docker must be installed separately.
- Jenkins requires Docker permissions to execute Docker commands.
- The Docker Pipeline Plugin enables Docker-based pipelines.

---

## 👩‍💻 Author

**Gayatri Shinde**

Aspiring DevOps Engineer | AWS | Docker | Jenkins | Linux | GitHub

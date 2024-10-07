#!/bin/bash
apt update
echo "install dotnet"
apt install -y aspnetcore-runtime-6.0
apt install -y dotnet-sdk-6.0

#install git
echo "install git"
apt install git
apt install unzip

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install
aws --version
aws secretsmanager get-secret-value --secret-id Github_Credentials --query 'SecretString' --output text


#configure git
sudo -u ubuntu git config --global credential.helper '!aws codecommit credential-helper $@'
sudo -u ubuntu git config --global credential.UseHttpPath true


#clone repo from code commit
cd /home/ubuntu
echo "git clone"
sudo -u ubuntu git clone https://git-codecommit.eu-north-1.amazonaws.com/v1/repos/srv-02
cd srv-02

#build the dot net service
echo "dotnet build"
echo 'DOTNET_CLI_HOME=/temp' >> /etc/environment
export DOTNET_CLI_HOME=/temp
dotnet publish -c Release --self-contained=false --runtime linux-x64


cat >/etc/systemd/system/srv-02.service <<EOL
[Unit]
Description=Dotnet S3 info service

[Service]
ExecStart=/usr/bin/dotnet /home/ubuntu/srv-02/bin/Release/netcoreapp6/linux-x64/srv02.dll
SyslogIdentifier=srv-02

Environment=DOTNET_CLI_HOME=/temp

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload

#run it
systemctl start srv-02

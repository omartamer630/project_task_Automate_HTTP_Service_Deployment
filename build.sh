#!/bin/bash

# Update package lists
apt update

# Install ASP.NET Core runtime and SDK
echo "Installing ASP.NET Core runtime and SDK..."
apt install -y aspnetcore-runtime-6.0 dotnet-sdk-6.0

# Install Git and unzip
echo "Installing Git and unzip..."
apt install -y git unzip jq

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
sudo ./aws/install
aws --version

# Retrieve GitHub token from AWS Secrets Manager
echo "Retrieving GitHub token from AWS Secrets Manager..."
GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id Github_Credentials --query 'SecretString' --output text | jq -r '.GitHubToken')

# Check if the token retrieval was successful
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Failed to retrieve GitHub token."
    exit 1
fi

# Store the GitHub token in Git credentials
git_url="https://omartamer630:$GITHUB_TOKEN@github.com"
echo "$git_url" | sudo -u ubuntu git credential approve

# Configure Git credential helper to cache credentials and use HTTP paths
sudo -u ubuntu git config --global credential.helper cache
sudo -u ubuntu git config --global credential.UseHttpPath true

echo "GitHub token successfully configured for Git operations."


# Clone the repository from GitHub
echo "Cloning repository..."
cd /home/ubuntu
sudo -u ubuntu git clone https://github.com/omartamer630/project_task_Automate_HTTP_Service_Deployment.git

# Change directory to the cloned repo
cd project_task_Automate_HTTP_Service_Deployment || { echo "Failed to change directory"; exit 1; }

# Build the .NET service
echo "Building the .NET service..."
echo 'DOTNET_CLI_HOME=/temp' | sudo tee -a /etc/environment
export DOTNET_CLI_HOME=/temp
dotnet publish -c Release --self-contained=false --runtime linux-x64

# Create a systemd service file for the .NET application
cat >/etc/systemd/system/srv-02.service <<EOL
[Unit]
Description=Dotnet S3 Info Service

[Service]
ExecStart=/usr/bin/dotnet /home/ubuntu/project_task_Automate_HTTP_Service_Deployment/bin/Release/netcoreapp6/linux-x64/srv02.dll
SyslogIdentifier=srv-02
Environment=DOTNET_CLI_HOME=/temp

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service
echo "Reloading systemd..."
systemctl daemon-reload

# Start the .NET service
echo "Starting the service..."
systemctl start srv-02

# Enable the service to start on boot
systemctl enable srv-02

echo "Setup completed successfully."

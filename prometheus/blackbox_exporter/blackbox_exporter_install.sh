#!/bin/bash
echo "script runs on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Install blackbox_exporter on fleet vm"
echo "check the directory first $(pwd).."
# Correct the path check and comparison syntax:
if [ "$(pwd)" = "/home/ubuntu" ]; then
    echo "Good to download the blackbox_exporter tar file.."
    # Download the file (no need to assign to variable unless you want to)
    wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.26.0/blackbox_exporter-0.26.0.linux-amd64.tar.gz
    # Extract the tar.gz file
    tar -xvf blackbox_exporter-0.26.0.linux-amd64.tar.gz
    # Remove the tar.gz archive
    rm -f blackbox_exporter-0.26.0.linux-amd64.tar.gz
    # Rename the extracted directory
    mv blackbox_exporter-0.26.0.linux-amd64 blackbox_exporter-0.26.0
    # Change to the extracted directory
    cd blackbox_exporter-0.26.0
    # Run blackbox_exporter (note the correct executable name)
    ./blackbox_exporter &
else
    echo "Please navigate to /home/ubuntu and then download.."
fi
exit 0

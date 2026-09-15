#!/bin/bash
set -e
echo "Script to run terraform commands..."
echo ""
echo "terraform fmt in progress..."
terraform fmt -recursive

if [ -d "$PWD/.terraform" ]; then
    echo "Terraform already initialized; skipping terraform init."
else
    echo "terraform init in progress..."
    terraform init
fi

echo "terraform validate in progress..."
terraform validate
echo "terraform plan in progress..."
terraform plan
read -r -p "Do you want to run terraform apply? Enter yes or no: " USER_INPUT
case "$USER_INPUT" in
    yes|YES|y|Y)
        echo "Running terraform apply --auto-approve..."
        terraform apply --auto-approve
        ;;
    no|NO|n|N)
        echo "User entered 'no'; skipping terraform apply."
        ;;
    *)
        echo "Invalid input; skipping terraform apply."
        ;;
esac

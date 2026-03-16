# IAM Roles and Secure Access Automation (Group 4)

## Project Overview

This project automates the setup of secure identity and access controls in Microsoft Azure using **Azure CLI**, **Bash scripting**, and **GitHub Actions** for CI/CD automation.

**Objective:** Deploy a resource group, virtual network, subnets, and assign secure role-based access (Reader) to the database subnet, demonstrating automated Azure resource management.

> Note: Azure AD objects (groups, users) are **skipped** due to limitations of personal Microsoft accounts (MSA). Full AD automation requires a work/school account with Global Administrator permissions.

---

## Project Components

1. **Resource Group:** `iam-project-rg`  
2. **Virtual Network:** `iam-vnet` with address prefix `10.0.0.0/16`  
3. **Subnets:**
   - `web-subnet` → `10.0.1.0/24`  
   - `db-subnet` → `10.0.2.0/24`  
4. **Role Assignment:** Assigns **Reader** role on the DB subnet to the designated service principal or MSA user.  
5. **CI/CD Automation:** GitHub Actions workflow triggers on push to `master` and runs `deploy.sh` to automate deployment.

---

## Folder Structure
# IAM Roles and Secure Access Automation (Group 4)

## Project Overview

This project automates the setup of secure identity and access controls in Microsoft Azure using **Azure CLI**, **Bash scripting**, and **GitHub Actions** for CI/CD automation.

**Objective:** Deploy a resource group, virtual network, subnets, and assign secure role-based access (Reader) to the database subnet, demonstrating automated Azure resource management.

> Note: Azure AD objects (groups, users) are **skipped** due to limitations of personal Microsoft accounts (MSA). Full AD automation requires a work/school account with Global Administrator permissions.

---

## Project Components

1. **Resource Group:** `iam-project-rg`  
2. **Virtual Network:** `iam-vnet` with address prefix `10.0.0.0/16`  
3. **Subnets:**
   - `web-subnet` → `10.0.1.0/24`  
   - `db-subnet` → `10.0.2.0/24`  
4. **Role Assignment:** Assigns **Reader** role on the DB subnet to the designated service principal or MSA user.  
5. **CI/CD Automation:** GitHub Actions workflow triggers on push to `master` and runs `deploy.sh` to automate deployment.

---

## Folder Structure
IAM-Automation/
├─ .github/
│ └─ workflows/
│ └─ deploy.yml # GitHub Actions workflow
├─ deploy.sh # Bash script for Azure deployment
├─ README.md # Project documentation


---

## Prerequisites

- Azure Subscription (Pay-As-You-Go or other)  
- GitHub Account  
- Azure CLI installed locally or accessible via Azure Cloud Shell  
- Service Principal with Contributor role for deployment  

---

## Setup Instructions

### 1. Create a Service Principal

Run in Azure Cloud Shell:

```bash
az ad sp create-for-rbac --name github-iam-deployer --role Contributor --scopes /subscriptions/<your-subscription-id>


Save the JSON output; it will be used as a GitHub secret.

2. Configure GitHub Secrets

Go to GitHub → Settings → Secrets and variables → Actions → New repository secret:

Secret Name	Value
AZURE_CREDENTIALS	JSON output from Service Principal creation
3. Workflow Configuration

The workflow is located at:

.github/workflows/deploy.yml

It performs the following steps:

Checks out the repository

Installs Azure CLI

Logs in using the AZURE_CREDENTIALS secret

Runs deploy.sh to create resource group, VNet, subnets, and assign roles

4. Deployment Script (deploy.sh)

Creates the resource group: iam-project-rg

Creates virtual network: iam-vnet

Creates subnets: web-subnet and db-subnet

Assigns Reader role on the DB subnet to the service principal or MSA user

The script is written with set -e to fail fast if any command fails.

Running the Workflow

Push your code to the master branch:

git add .
git commit -m "Add IAM automation workflow"
git push origin master

Open GitHub Actions → IAM Deployment workflow

Monitor the workflow logs for successful resource creation and role assignment

Project Limitations

Azure AD groups and test users are not created due to MSA limitations

Full IAM automation with AD objects requires an organizational account with proper permissions

Author: Ugochukwu Samuel

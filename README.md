## 🧱 IaC Hands-on 3: Load-Balanced Linux VMs with NGINX via Azure Bicep

This project provisions a scalable Azure environment using modular Bicep templates — deploying multiple Linux VMs behind a Load Balancer, each configured with NGINX via Custom Script Extension.

# 🚀 What It Deploys

    ✅ Virtual Network + Subnet + Network Security Group (NSG)

    ✅ Azure Load Balancer (Standard SKU) with TCP probe and rule

    ✅ Static Public IP for Load Balancer frontend

    ✅ Two Ubuntu 22.04 LTS Linux Virtual Machines

    ✅ Custom Script Extension to install and configure NGINX

    ✅ Load-balanced web access with hostname-based response

# 📁 Project Structure

```markdown
iac-hands-on-3/
├── main.bicep              # Orchestrates all module deployments
├── parameters.json         # Input parameters (e.g., SSH public key)
├── scripts/
│   └── install-nginx.sh    # Script executed on each VM
├── modules/
│   ├── network.bicep       # VNet, Subnet, NSG
│   ├── loadbalancer.bicep  # Public IP + LB + probe + rule
│   └── vm-multi.bicep      # Multiple Linux VMs with extensions
├── README.md               # Project documentation
└── CHANGELOG.md            # Version history
```
# 🧪 How to Deploy

Before you start:

    Ensure you have the Azure CLI installed and logged in (az login)

    Make sure your parameters.json file contains a valid SSH public key

Run this command from the root of the project:
```bash
az deployment group create \
  --resource-group rg-iac-lab \
  --template-file main.bicep \
  --parameters @parameters.json
```
# 🌐 Accessing the Application

After deployment, access the public IP output from the deployment:
```bash
curl http://<public-ip>
```
You should see a custom NGINX page showing the instance name (e.g., nginxvm-0, nginxvm-1), confirming load balancing is working.
# 🔐 Security Considerations

    Password login is disabled

    Only SSH public key authentication is allowed

    NSG allows only TCP ports 22 (SSH) and 80 (HTTP)

    No public IPs are assigned to individual VMs

# ⚙️ Parameters File

This project uses parameters.json, which is ignored by Git. Clone the example file below to provide your own inputs:
```bash
cp parameters.example.json parameters.json
```
# 🛠️ Tech Stack

    Azure Bicep (modular architecture)

    Azure CLI

    Ubuntu Server 22.04 LTS

    NGINX via Custom Script Extension

    Azure Load Balancer (Standard SKU)

    SSH key authentication

# 📜 License

MIT License
# GitHub Workflow Configuration

## Secrets Required for Terraform Deployment

### Azure Authentication

To authenticate with Azure, create a service principal and add the following secrets to your GitHub repository:

#### Option 1: Individual Credentials (used by Terraform)

- `ARM_CLIENT_ID`: The Application (client) ID of your service principal
- `ARM_CLIENT_SECRET`: The secret key of your service principal
- `ARM_SUBSCRIPTION_ID`: Your Azure subscription ID
- `ARM_TENANT_ID`: Your Azure tenant ID

#### Option 2: JSON Credentials (used by Azure CLI)

Create a secret named `AZURE_CREDENTIALS` with the following JSON format:

```json
{
  "clientId": "<GUID>",
  "clientSecret": "<STRING>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>"
}
```

### GitHub Container Registry

For accessing GitHub Container Registry:

- `GITHUB_USERNAME`: Your GitHub username
- `GITHUB_TOKEN`: A GitHub personal access token with `read:packages` and `write:packages` scopes

## How to Create a Service Principal

```bash
# Login to Azure
az login

# Create a service principal and configure its access to Azure resources
az ad sp create-for-rbac --name "github-actions-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>" --sdk-auth

# The command will output a JSON object with the credentials for your service principal
# Save this output securely and use it to set up your GitHub secrets
```

## Testing Locally Before GitHub Actions

```bash
# Set environment variables (Linux/macOS)
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
export TF_VAR_github_username="your-github-username"
export TF_VAR_github_token="your-github-token"

# For Windows PowerShell
$env:ARM_CLIENT_ID="your-client-id"
$env:ARM_CLIENT_SECRET="your-client-secret"
$env:ARM_SUBSCRIPTION_ID="your-subscription-id"
$env:ARM_TENANT_ID="your-tenant-id"
$env:TF_VAR_github_username="your-github-username"
$env:TF_VAR_github_token="your-github-token"

# Initialize and apply Terraform locally
cd terraform
terraform init
terraform plan -var="environment=dev"
terraform apply -var="environment=dev"
```

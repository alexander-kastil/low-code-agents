$env = "dev"
$grp = "m365-copilot-$env"
$loc = "westeurope"
$plan = "m365-copilot-plan-$env"
$acct = "m365copilot$env"
$container = "food"

az group create -n $grp -l $loc

az storage account create -l $loc -n $acct -g $grp --sku Standard_LRS
$key = az storage account keys list -n $acct -g $grp --query "[0].value" -o tsv
$key = $key.Trim()
az storage container create -n $container --account-key $key --account-name $acct

az storage blob upload-batch -d $container -s "assets/images" --account-name $acct --account-key $key

az appservice plan create -n $plan -g $grp --sku B1 --is-linux

cd "food-catalog-api"
$webappName = "food-catalog-api-$env"
az webapp up -n $webappName -g $grp -p $plan -l $loc --os-type Linux -r "DOTNETCORE:9.0"
az webapp cors add --allowed-origins "*" --name $webappName --resource-group $grp
cd ..

cd "hr-mcp-server"
$webappName = "hr-mcp-server-$env"
az webapp up -n $webappName -g $grp -p $plan -l $loc --os-type Linux -r "DOTNETCORE:9.0"
az webapp cors add --allowed-origins "*" --name $webappName --resource-group $grp
cd ..

cd "purchasing-service"
$webappName = "purchasing-service-$env"
az webapp up -n $webappName -g $grp -p $plan -l $loc --os-type Linux -r "DOTNETCORE:9.0"
az webapp cors add --allowed-origins "*" --name $webappName --resource-group $grp
cd ..
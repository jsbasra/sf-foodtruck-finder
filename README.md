# sf-foodtruck-finder
App that finds the 5 nearest food trucks in San Francisco based on the user's current location as required by: 
https://github.com/timfpark/take-home-engineering-challenge

The app is accessible at: <a href="https://basra.win">basra.win</a>

The application is hosted on Microsoft Azure and utilizes a <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/web/index.html">static website</a> that is the frontend for the application and an Azure Function that acts as the backend by executing a <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/AzureFunctions/GetSF-foodtrucks/Get-SFFoodTrucks/run.ps1">powershell script</a> located in the Azure Functions folder of this project. 

The backend of the application leverages the data provided by San Francisco's food truck open dataset <a href="https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data" rel="nofollow">located here</a> and an endpoint with a <a href="https://data.sfgov.org/api/views/rqzj-sfat/rows.csv" rel="nofollow">CSV dump of the latest data</a>. A storage account also has a copy for redundancy. 

<h3>Azure Infrastructure</h3>
If you want to deploy your own instance of this application, please look at the ARM Template arm.json in Azure Infrastructure folder. The default value of some parameters will need to be modified especially the hostname basra.win and repository url. After modifiying the parameters, The ARM Template can be deployed in a new resource group. This can be done by the following PowerShell Az cmdlets: <br>
To create a new resource group use: <code>New-AzResourceGroup $RG</code> <br>
and then deploy the ARM template use: <code>New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateFile $Path_to_arm </code>
<br><br>
After creating and deploying the Infrastructure. The Azure Function will need to be configured. Go to the Kudu Console advanced options and configure the Azure Function as follows:
Add a folder named "bin" to "C:\home\site\wwwroot\" and then upload System.Device.dll to "C:\home\site\wwwroot\bin\" so that Get-SFfoodtruck can access it. This dll provides the .NET <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate?view=netframework-4.8">GeoCoordinate</a> Class and its methods. The PowerShell Script in the Azure Function uses the <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate.getdistanceto?view=netframework-4.8">GeoCoordinate.GetDistanceTo </a> method to calculate distances between the user and the food trucks. 

<h3>Future Development</h3>

Future Development will involve resolving errors related to pushpin visability, polish unit testing, and add new features including the ability to manually enter a location as well as incorporation of more food truck datasets so that the application can be used outside San Franciso. If you would like to make a pull request, the <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/.github/workflows/azure-static-web-apps-lemon-bush-0a315f910.yml">CI/CD pipeline</a> is setup using GitHub Actions with PowerShell linting and automated unit testing via PlayWright Test. There are also instructions in /test/localtests/ on setting up a local version and validating local changes.

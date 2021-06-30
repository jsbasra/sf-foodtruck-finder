# sf-foodtruck-finder
App that finds the 5 nearest food trucks in San Francisco based on the user's current location. 

The app is accessible at: <a href="https://basra.win">basra.win</a>

The application is hosted Microsoft Azure and utilizes a <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/index.html">static website</a> that is the frontend for the application and an Azure Function that acts as the backend by executing <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/Get-SFfoodtrucks">powershell script</a> located in the Azure Functions folder. 

The backend of the application leverages the data provided by San Francisco's food truck open dataset <a href="https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data" rel="nofollow">located here</a> and an endpoint with a <a href="https://data.sfgov.org/api/views/rqzj-sfat/rows.csv" rel="nofollow">CSV dump of the latest data</a>. A storage account also has a copy for redundancy. 

<h3>Azure Infrastructure</h3>
To deploy the infrastructure for this application please look at arm.json in Azure Infrastructure folder. Some of the paramters will need to be modified espeically the hostname basra.win if you want to deploy your own instance of this application. 
<br><br>
After creating and deploying the Infrstructure. The Azure Function will need to be configured. Go to the Kudu Console advanced options and configure the Azure Function as follows:
Add a folder named "bin" to "C:\home\site\wwwroot\" and then upload System.Device.dll to "C:\home\site\wwwroot\bin\" so that Get-SFfoodtruck can access it. This dll provides the .NET <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate?view=netframework-4.8">GeoCoordinate</a> Class and its methods. The PowerShell Script in the Azure Function uses the <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate.getdistanceto?view=netframework-4.8">GeoCoordinate.GetDistanceTo </a> method to calculate distances between the user and the food trucks. 

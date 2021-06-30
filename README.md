# sf-foodtruck-finder
App that finds the 5 nearest food trucks in San Francisco based on the user's current location. 

The app is accessiable at: <a href="https://basra.win">basra.win</a>

The application is hosted Microsoft Azure and utilizes a <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/index.html">static website</a> that is the frontend for the application and an Azure Function that acts as the backend by executing <a href="https://github.com/jsbasra/sf-foodtruck-finder/blob/main/Get-SFfoodtrucks">powershell script</a> located in the Azure Functions folder. 

The backend of the application leverages the data provided by San Francisco's food truck open dataset <a href="https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data" rel="nofollow">located here</a> and an endpoint with a <a href="https://data.sfgov.org/api/views/rqzj-sfat/rows.csv" rel="nofollow">CSV dump of the latest data</a>. A storage account also has a copy for redundancy. 

After creating the Azure Function, go to the Kudu Console advanced options and configure the Azure Function as follows:
Add a folder named "bin" to "C:\home\site\wwwroot\" and then upload System.Device.dll to "C:\home\site\wwwroot\bin\" so that Get-SFfoodtruck can access it. This dll provides the .NET <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate?view=netframework-4.8">GeoCoordinate</a> Class and its methods. The PowerShell Script in the Azure Function uses the <a href="https://docs.microsoft.com/en-us/dotnet/api/system.device.location.geocoordinate.getdistanceto?view=netframework-4.8">GeoCoordinate.GetDistanceTo </a> method to calculate distances between the user and the food trucks. 

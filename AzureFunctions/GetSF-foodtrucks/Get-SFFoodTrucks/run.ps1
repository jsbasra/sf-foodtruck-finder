using namespace System.Net
using namespace System.Device.Location


# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
    #$name = $Request.Body.Name
    [Double]$lat = $Request.Body.Lat
    [Double]$long = $Request.Body.long

    Add-Type -Path "C:\home\site\wwwroot\bin\System.Device.dll"
    $foodtruckuri = "https://data.sfgov.org/api/views/rqzj-sfat/rows.csv"
    $foodtruckdata = $(Invoke-WebRequest -Uri $foodtruckuri).content | ConvertFrom-Csv -Delimiter ","
    if($null -eq $foodtruckdata){
        $foodtruckuri = "https://storageaccountmsengb94e.blob.core.windows.net/backupdata/Mobile_Food_Facility_Permit.csv"
        $foodtruckdata = $(Invoke-WebRequest -Uri $foodtruckuri).content | ConvertFrom-Csv -Delimiter ","
    }
    $usercordinate = [GeoCoordinate]::new($lat,$long)
    $hash = @{}

    foreach($truck in $foodtruckdata){
        $truckcordinate = [GeoCoordinate]::new($truck.Latitude,$truck.Longitude)
        $truckdistance = $usercordinate.GetDistanceTo($truckcordinate)
        $hash.Add($truck.locationid,$truckdistance)
    }

    $hash = $hash.GetEnumerator() | Sort-Object -property:Value
    $top5 = $hash | Select-Object -First 5
    $trucks = [System.Collections.ArrayList]@()
    foreach($locid in $top5.Name){
        $truck = $foodtruckdata | ?{$_.locationid -eq $locid}
        $trucks.Add($truck)
    }

$body = $($trucks | ConvertTo-Json)


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

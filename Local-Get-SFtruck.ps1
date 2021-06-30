using namespace System.Net
using namespace System.Device.Location
Add-Type -AssemblyName System.Device

function Get5trucks([Double]$lat,[Double]$long) {
 

    $foodtruckuri = "https://data.sfgov.org/api/views/rqzj-sfat/rows.csv"
    $foodtruckdata = $(Invoke-WebRequest -Uri $foodtruckuri).content | ConvertFrom-Csv -Delimiter ","
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

    return $($trucks | ConvertTo-Json)
}

$lat=39.1512064
$long=-76.74593279999999
$nearest = Get5trucks -lat $lat -long $long
$nearest

using namespace System.Net
using namespace System.Device.Location
Add-Type -AssemblyName System.Device

function Get5trucks([Double]$lat,[Double]$long) {
 

    #$foodtruckuri = "file:////$($pwd -replace "\\","/")/Mobile_Food_Facility_Permit.csv"
    #$foodtruckdata = $(Invoke-WebRequest -Uri $foodtruckuri).content | ConvertFrom-Csv -Delimiter ","
    $foodtruckdata = Import-Csv "$pwd\Mobile_Food_Facility_Permit.csv"
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

$lat=37.754043
$long=-122.452672
$nearest = Get5trucks -lat $lat -long $long
$nearest

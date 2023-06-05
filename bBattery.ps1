powercfg /batteryreport /xml /output batteryreport.xml

$battery = [xml](Get-Content batteryreport.xml)

$health = [pscustomobject]@{
    Time               = $battery.BatteryReport.ReportInformation.ScanTime;
    Type               = $battery.BatteryReport.Batteries.Battery.Id;
    Manufacturer       = $battery.BatteryReport.Batteries.Battery.Manufacturer;
    ManufactureDate    = $battery.BatteryReport.Batteries.Battery.ManufactureDate;
    SerialNumber       = $battery.BatteryReport.Batteries.Battery.SerialNumber;
    DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity;
    FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity;
    MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100
    FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100);
    CycleCount         = $battery.BatteryReport.Batteries.Battery.CycleCount;
}

Write-Host ""
Write-Host "-- bBattery ------------------------------------"
Write-Host "-- github.com/mhqb365/bbatery ------------------"
Write-Host ""
Write-Host "Time: $($health.Time)"
Write-Host "Type: $($health.Type)"
Write-Host "Manufacturer: $($health.Manufacturer)"
Write-Host "Manufacture Date: $($health.ManufactureDate)"
Write-Host "Serial Number: $($health.SerialNumber)"
Write-Host "Design Capacity: $($health.DesignCapacity) mWh"
Write-Host "FullChargeCapacity: $($health.FullChargeCapacity) mWh"
Write-Host "Cycle Count: $($health.CycleCount)"
Write-Host "% Max Capacity: $($health.MaxCapacity)%"
Write-Host "% Failure Capacity: $($health.FailureCapacity)%"
Write-Host ""
Write-Host "-- From mhqb365.com with Love -------------------"
Write-Host ""
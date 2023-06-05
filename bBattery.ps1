powercfg /batteryreport /xml /output batteryreport.xml

$battery = [xml](Get-Content batteryreport.xml)

$health = [pscustomobject]@{
    Time = $battery.BatteryReport.ReportInformation.ScanTime;
    Brands = $battery.BatteryReport.Batteries.Battery.Id;
    Manufacturer = $battery.BatteryReport.Batteries.Battery.Manufacturer;
    ManufactureDate = $battery.BatteryReport.Batteries.Battery.ManufactureDate;
    SerialNumber = $battery.BatteryReport.Batteries.Battery.SerialNumber;
    DesignCapacity = $battery.BatteryReport.Batteries.Battery.DesignCapacity;
    FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity;
    MaxCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100
    FailureCapacity = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity / $battery.BatteryReport.Batteries.Battery.DesignCapacity * 100);
    CycleCount = $battery.BatteryReport.Batteries.Battery.CycleCount;
}

Write-Host ""
Write-Host "-- bBattery ------------------------------------"
Write-Host "-- github.com/mhqb365/bbatery ------------------"
Write-Host ""
Write-Host "Thoi gian kiem tra: $($health.Time)"
Write-Host "Nha san xuat: $($health.Brands) - $($health.Manufacturer)"
Write-Host "Ngay san xuat: $($health.ManufactureDate)"
Write-Host "So serial: $($health.SerialNumber)"
Write-Host "Dung luong thiet ke ban dau: $($health.DesignCapacity) mWh"
Write-Host "Dung luong hien tai: $($health.FullChargeCapacity) mWh"
Write-Host "So lan sac: $($health.CycleCount)"
Write-Host "% dung luong toi da: $($health.MaxCapacity)%"
Write-Host "% do chai pin: $($health.FailureCapacity)%"
Write-Host ""
Write-Host "-- From mhqb365.com with Love -------------------"
Write-Host ""
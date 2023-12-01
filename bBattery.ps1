powercfg /batteryreport /xml /output batteryreport.xml

$battery = [xml](Get-Content batteryreport.xml)

try {
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
    Write-Host "bBattery"
    Write-Host "github.com/mhqb365/bbatery"
    Write-Host ""
    Write-Host "Time: $($health.Time)"
    Write-Host ""
    Write-Host "Type: $($health.Type)"
    Write-Host "Manufacturer: $($health.Manufacturer)"
    Write-Host "Manufacture Date: $($health.ManufactureDate)"
    Write-Host "Serial Number: $($health.SerialNumber)"
    Write-Host "Design Capacity: $($health.DesignCapacity) mWh"
    Write-Host "Full Charge Capacity: $($health.FullChargeCapacity) mWh"
    Write-Host "Cycle Count: $($health.CycleCount)"
    Write-Host "Max Capacity: $($health.MaxCapacity)%"
    Write-Host "Failure Capacity: $($health.FailureCapacity)%"
    Write-Host ""
    Write-Host "From mhqb365.com with Love"
    Write-Host ""

} catch {
    $health1 = [pscustomobject]@{
        Time               = $battery.BatteryReport.ReportInformation.ScanTime;
        Type               = $battery.BatteryReport.Batteries.Battery.Id[0];
        Manufacturer       = $battery.BatteryReport.Batteries.Battery.Manufacturer[0];
        ManufactureDate    = $battery.BatteryReport.Batteries.Battery.ManufactureDate[0];
        SerialNumber       = $battery.BatteryReport.Batteries.Battery.SerialNumber[0];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[0];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[0] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[0] * 100);
        CycleCount         = $battery.BatteryReport.Batteries.Battery.CycleCount[0];
    }

    $health2 = [pscustomobject]@{
        Type               = $battery.BatteryReport.Batteries.Battery.Id[1];
        Manufacturer       = $battery.BatteryReport.Batteries.Battery.Manufacturer[1];
        ManufactureDate    = $battery.BatteryReport.Batteries.Battery.ManufactureDate[1];
        SerialNumber       = $battery.BatteryReport.Batteries.Battery.SerialNumber[1];
        DesignCapacity     = $battery.BatteryReport.Batteries.Battery.DesignCapacity[1];
        FullChargeCapacity = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1];
        MaxCapacity        = $battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100
        FailureCapacity    = 100 - ($battery.BatteryReport.Batteries.Battery.FullChargeCapacity[1] / $battery.BatteryReport.Batteries.Battery.DesignCapacity[1] * 100);
        CycleCount         = $battery.BatteryReport.Batteries.Battery.CycleCount[1];
    }

    Write-Host ""
    Write-Host "bBattery"
    Write-Host "github.com/mhqb365/bbatery"
    Write-Host ""
    Write-Host "Time: $($health1.Time)"
    Write-Host ""
    Write-Host "Battery 1"
    Write-Host "Type: $($health1.Type)"
    Write-Host "Manufacturer: $($health1.Manufacturer)"
    Write-Host "Manufacture Date: $($health1.ManufactureDate)"
    Write-Host "Serial Number: $($health1.SerialNumber)"
    Write-Host "Design Capacity: $($health1.DesignCapacity) mWh"
    Write-Host "Full Charge Capacity: $($health1.FullChargeCapacity) mWh"
    Write-Host "Cycle Count: $($health1.CycleCount)"
    Write-Host "Max Capacity: $($health1.MaxCapacity)%"
    Write-Host "Failure Capacity: $($health1.FailureCapacity)%"
    Write-Host ""
    Write-Host "Battery 2"
    Write-Host "Type: $($health2.Type)"
    Write-Host "Manufacturer: $($health2.Manufacturer)"
    Write-Host "Manufacture Date: $($health2.ManufactureDate)"
    Write-Host "Serial Number: $($health2.SerialNumber)"
    Write-Host "Design Capacity: $($health2.DesignCapacity) mWh"
    Write-Host "Full Charge Capacity: $($health2.FullChargeCapacity) mWh"
    Write-Host "Cycle Count: $($health2.CycleCount)"
    Write-Host "Max Capacity: $($health2.MaxCapacity)%"
    Write-Host "Failure Capacity: $($health2.FailureCapacity)%"
    Write-Host ""
    Write-Host "From mhqb365.com with Love"
    Write-Host ""
}

Read-Host -Prompt "Press any key to exit"
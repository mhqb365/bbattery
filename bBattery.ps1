powercfg /batteryreport /xml /output ./batteryreport.xml

Write-Host ""
Write-Host "bBattery - github.com/mhqb365/bbattery"
Write-Host ""
$formattedTime = (Get-Date -Format "HH:mm dd/MM/yyyy")
Write-Host "ThoiGianKiemTra $formattedTime"


$battery = [xml](Get-Content ./batteryreport.xml)

function Get-BatteryHealth {
    param (
        [xml]$BatteryData
    )

    $healths = @()

    foreach ($battery in $BatteryData.BatteryReport.Batteries.Battery) {
        $healths += [pscustomobject]@{
            Type               = $battery.Id
            Manufacturer       = $battery.Manufacturer
            ManufactureDate    = $battery.ManufactureDate
            SerialNumber       = $battery.SerialNumber
            DesignCapacity     = $battery.DesignCapacity 
            FullChargeCapacity = $battery.FullChargeCapacity
            MaxCapacity        = ($battery.FullChargeCapacity / $battery.DesignCapacity * 100).ToString("F2")
            BatteryWearLevel   = (100 - ($battery.FullChargeCapacity / $battery.DesignCapacity * 100)).ToString("F2")
            CycleCount         = $battery.CycleCount
        }
    }

    return $healths
}

function Display-BatteryHealth {
    param (
        [object[]]$HealthData,
        [string]$ScanTime
    )

    $table = @()
    $index = 1
    foreach ($health in $HealthData) {
        $table += [pscustomobject]@{
            STT              = "Battery $index"
            SoLanSac         = "$($health.CycleCount)"
            DungLuongBanDau  = "$($health.DesignCapacity) mWh"
            DungLuongConLai  = "$($health.FullChargeCapacity) mWh"
            DoChaiPin        = "$($health.BatteryWearLevel)%"
        }
        $index++
    }

    $table | Format-Table -AutoSize
}

try {
    $scanTime = $battery.BatteryReport.ReportInformation.ScanTime
    $batteryHealth = Get-BatteryHealth -BatteryData $battery
    Display-BatteryHealth -HealthData $batteryHealth -ScanTime $scanTime
} catch {
    Write-Host "Co loi trong qua trinh kiem tra" -ForegroundColor Red
}

Read-Host -Prompt "Bam phim bat ki de thoat"

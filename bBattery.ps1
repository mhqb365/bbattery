# Cấu hình mã hóa để tránh lỗi font tiếng Việt và ký tự đặc biệt
# $OutputEncoding = [System.Text.Encoding]::UTF8
# [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Tạo báo cáo pin tạm thời
$xmlPath = "$env:TEMP\batteryreport.xml"
powercfg /batteryreport /xml /output $xmlPath | Out-Null

Write-Host "`n  bBattery - Kiem tra nhanh do chai pin cua may tinh Windows" -ForegroundColor Cyan
Write-Host "  Created by mhqb365.com" -ForegroundColor Cyan
Write-Host "  Open source github.com/mhqb365/bbattery" -ForegroundColor Cyan
# Write-Host ("  " + ("-" * 60)) -ForegroundColor Gray

$timeNow = Get-Date -Format 'HH:mm:ss dd/MM/yyyy'
Write-Host "`n  Thoi gian kiem tra $timeNow" -ForegroundColor Gray

if (Test-Path $xmlPath) {
    try {
        $batteryData = [xml](Get-Content $xmlPath)
        
        # Lấy thông tin từ WMI/CIM
        $wmiBattery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        $statusStr = "Discharging"
        if ($wmiBattery.BatteryStatus -eq 2) { $statusStr = "Charging" }
        $percent = $wmiBattery.EstimatedChargeRemaining
        
        function Draw-ProgressBar {
            param ($percentValue, $width = 20, $foreground = "Green")
            $filled = [math]::Floor($percentValue * $width / 100)
            if ($filled -lt 0) { $filled = 0 }
            if ($filled -gt $width) { $filled = $width }
            $empty = $width - $filled
            $barStr = ("#" * $filled) + ("-" * $empty)
            Write-Host " [" -NoNewline -ForegroundColor Gray
            Write-Host $barStr -NoNewline -ForegroundColor $foreground
            Write-Host "] " -NoNewline -ForegroundColor Gray
            Write-Host "$($percentValue.ToString().PadLeft(3))%" -NoNewline -ForegroundColor White
        }

        foreach ($battery in $batteryData.BatteryReport.Batteries.Battery) {
            $designCap = [double]$battery.DesignCapacity
            $fullCap = [double]$battery.FullChargeCapacity
            $healthPct = [math]::Round(($fullCap / $designCap) * 100, 2)
            $wearLevel = 100 - $healthPct
            
            # Chọn màu dựa trên sức khỏe
            $healthColor = "Green"
            if ($healthPct -lt 80) { $healthColor = "Yellow" }
            if ($healthPct -lt 50) { $healthColor = "Red" }

            Write-Host "`n  [+] PIN $($battery.Id)" -ForegroundColor Magenta
            Write-Host "  +----------------------------------------------------------+" -ForegroundColor Cyan
            
            # Phần 1: Trạng thái & Sức khỏe
            Write-Host ("  | {0,-15}" -f "Trang thai:") -NoNewline -ForegroundColor Cyan
            Draw-ProgressBar -percentValue $percent -width 20 -foreground "Cyan"
            Write-Host " ($statusStr)" -ForegroundColor White

            Write-Host ("  | {0,-15}" -f "Suc khoe:") -NoNewline -ForegroundColor Cyan
            Draw-ProgressBar -percentValue $healthPct -width 20 -foreground $healthColor
            Write-Host "" 

            Write-Host "  +----------------------------------------------------------+" -ForegroundColor Cyan
            
            # Phần 2: Chi tiết
            $labels = @( "Chu ky sac", "Dung luong goc", "Dung luong thuc te", "Do chai pin")
            $values = @("$($battery.CycleCount)", "$designCap mWh", "$fullCap mWh", "$([math]::Round($wearLevel, 2))%")
            $colors = @("Gray", "Gray",  "Gray", "Yellow")

            for ($i = 0; $i -lt $labels.Length; $i++) {
                Write-Host "  | " -NoNewline -ForegroundColor Cyan
                $lineText = "{0,-20} {1,15}" -f $labels[$i], $values[$i]
                Write-Host $lineText -ForegroundColor $colors[$i]
            }
            
            if ($wmiBattery.EstimatedRunTime -and $wmiBattery.EstimatedRunTime -ne 71582788) {
                $totalMinutes = $wmiBattery.EstimatedRunTime
                $days = [math]::Floor($totalMinutes / 1440)
                $hours = [math]::Floor(($totalMinutes % 1440) / 60)
                $mins = $totalMinutes % 60
                
                $timeParts = @()
                if ($days -gt 0) { $timeParts += "$days ngay" }
                if ($hours -gt 0) { $timeParts += "$hours gio" }
                $timeParts += "$mins phut"
                $formattedTime = $timeParts -join " "

                Write-Host "  | " -NoNewline -ForegroundColor Cyan
                $timeText = "{0,-20} {1,15}" -f "Thoi gian su dung", $formattedTime
                Write-Host $timeText -ForegroundColor White
            }
            
            Write-Host "  +----------------------------------------------------------+" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "`n  [!] Loi khi doc du lieu $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        if (Test-Path $xmlPath) { Remove-Item $xmlPath -ErrorAction SilentlyContinue }
    }
} else {
    Write-Host "`n  [!] Khong the tao bao cao pin" -ForegroundColor Red
}

Write-Host " "

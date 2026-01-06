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
        
        # Lấy danh sách tất cả pin từ hệ thống
        $wmiBatteries = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue
        
        function Draw-ProgressBar {
            param ($percentValue, $width = 20, $foreground = "Green")
            $val = [double]$percentValue
            $filled = [math]::Floor($val * $width / 100)
            if ($filled -lt 0) { $filled = 0 }
            if ($filled -gt $width) { $filled = $width }
            $empty = $width - $filled
            $barStr = ("#" * $filled) + ("-" * $empty)
            Write-Host " [" -NoNewline -ForegroundColor Gray
            Write-Host $barStr -NoNewline -ForegroundColor $foreground
            Write-Host "] " -NoNewline -ForegroundColor Gray
            Write-Host "$($val.ToString().PadLeft(3))%" -NoNewline -ForegroundColor White
        }

        $batteryIdx = 0
        foreach ($battery in $batteryData.BatteryReport.Batteries.Battery) {
            # Khớp dữ liệu XML với pin thực tế tương ứng
            $currentWmi = if ($wmiBatteries -is [array]) { $wmiBatteries[$batteryIdx] } else { $wmiBatteries }
            
            $statusStr = "Discharging"
            if ($currentWmi.BatteryStatus -eq 2) { $statusStr = "Charging" }
            $percent = $currentWmi.EstimatedChargeRemaining
            if ($percent -eq $null) { $percent = 0 }

            $designCap = [double]$battery.DesignCapacity
            $fullCap = [double]$battery.FullChargeCapacity
            $healthPct = [math]::Round(($fullCap / $designCap) * 100, 2)
            $wearLevel = 100 - $healthPct
            
            # Chọn màu dựa trên sức khỏe
            $healthColor = "Green"
            if ($healthPct -lt 80) { $healthColor = "Yellow" }
            if ($healthPct -lt 50) { $healthColor = "Red" }

            Write-Host "`n  [+] PIN $($battery.Id) " -NoNewline -ForegroundColor Magenta
            if ($wmiBatteries -is [array]) { Write-Host "(Battery $($batteryIdx + 1))" -ForegroundColor Gray } else { Write-Host "" }
            
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
            $labels = @("Chu ky sac", "Dung luong goc", "Dung luong thuc te", "Do chai pin")
            $values = @("$($battery.CycleCount)", "$designCap mWh", "$fullCap mWh", "$([math]::Round($wearLevel, 2))%")
            $colors = @("Gray", "Gray",  "Gray", "Yellow")

            for ($i = 0; $i -lt $labels.Length; $i++) {
                Write-Host "  | " -NoNewline -ForegroundColor Cyan
                $lineText = "{0,-20} {1,15}" -f $labels[$i], $values[$i]
                Write-Host $lineText -ForegroundColor $colors[$i]
            }
            
            # Hiển thị thời gian sử dụng (thường WMI báo tổng cho cả máy hoặc theo viên pin đang xả)
            if ($currentWmi.EstimatedRunTime -and $currentWmi.EstimatedRunTime -ne 71582788) {
                $totalMinutes = $currentWmi.EstimatedRunTime
                $days = [math]::Floor($totalMinutes / 1440)
                $hours = [math]::Floor(($totalMinutes % 1440) / 60)
                $mins = $totalMinutes % 60
                
                $timeParts = @()
                if ($days -gt 0) { $timeParts += "$days ngay" }
                if ($hours -gt 0) { $timeParts += "$hours gio" }
                $timeParts += "$mins phut"
                $formattedTime = $timeParts -join " "

                Write-Host "  | " -NoNewline -ForegroundColor Cyan
                $timeStr = "{0,-20} {1,15}" -f "Thoi gian su dung", $formattedTime
                Write-Host $timeStr -ForegroundColor White
            }
            
            Write-Host "  +----------------------------------------------------------+" -ForegroundColor Cyan
            $batteryIdx++
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
# Bạn có thể thêm Read-Host hoặc Stop-Process vào đây nếu muốn tự động đóng.


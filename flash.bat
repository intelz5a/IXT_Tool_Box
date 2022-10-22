@echo off
setlocal enabledelayedexpansion
set "Path=%~dp0bin;%Path%"
title flash
echo Detecting if file exist ... | lolcat
echo Detecting 9008 Port | lolcat
set COM=
for /f tokens^=3^,4^,5^ delims^=^(^)^  %%i in ('lsusb') do (
	if /I "%%i"=="QDLoader" (
		if "%%j"=="9008" (
			echo Done... Find 9008 | lolcat
			set "COM=%%k"
			echo 9008 COM port is !COM! | lolcat
		)
	)
)
if not defined COM (
	echo Error ... No port Found ... | lolcat
	pause
	goto :MENU
)
echo Wait 3 second... | lolcat
timeout /t 3 /nobreak > nul
QSaharaServer.exe -s 13:image\prog_emmc_firehose_8909w_ddr.mbn -p \\.\!COM!
fh_loader.exe --port=\\.\!COM! --sendxml=rawprogram0.xml --search_path=%~dp0image
pause
goto :MENU
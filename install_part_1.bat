@echo off
:: To use set /p inside if statements 
:: Variables must now be referenced with a !_!
Setlocal EnableDelayedExpansion 

:: Since this was probably called in admin mode, move to this folder first
cd %~dp0

::
:: Download resources
::

:: Ensure we have the installers downloaded
if not exist downloads (mkdir downloads)

:: Now we need to download the nightly build from Msys2 if they don't already exists
if exist downloads/msys2.exe (
	echo Already downloaded MSys2
) else (
	curl -LJ --output downloads/msys2.exe --url https://github.com/msys2/msys2-installer/releases/download/2022-03-19/msys2-x86_64-20220319.exe
	echo Finished downloading Msys2 
)

:: Check for the error state
if not !errorLevel! == 0 (
	echo failed to download Msys2
	cmd /k
	exit
)

::
:: Msys2 
::

:: Find the location of the Msys uinstaller 
:: That will be are basis for if the location of msys2 has been found
set "MSYS2_PATH="
set "msys2_install="

if exist "C:\Program Files\Msys2\uninstall.exe" (set "MSYS2_PATH=C:\Program Files\Msys2")
if exist "C:\msys64\uninstall.exe" (set "MSYS2_PATH=C:\msys64")

:: We require that users reinstall Msys2 when their install is not located inside 
:: C\:Msys2
if defined MSYS2_PATH (
	echo Do you want to reinstall Msys2 into C:\Msys2? y/n"
	set /p MSYS_UNINSTALL=""

	if /i "!MSYS_UNINSTALL!" == "y" (
		echo Uninstalling Msys2
		call :CheckAdmin
		!MSYS2_PATH!\uninstall.exe pr --confirm-command

		:: Check that the uinstall worked
		if not !errorLevel! == 0 (
			echo failed to uninstall Msys2
			cmd /k
			exit
		) else (
			echo Succesfully uninstalled Msys2
		)

		:: Schedule Msys2 to be installed
		set "MSYS2_PATH=C:\Msys2"
		set "msys2_install=y"

		echo After uninstall we need to wait to let file system update before installing
		timeout /t 2

	) else (
		echo Sorry you need to move your Msys2 install location to C:\Msys2 
		cmd /k 
		exit 
	)
) else (
	if not exist C:\Msys2\uninstall.exe (
		echo No Msys2 install detected 
		:: The user does not have a Msys2 install so set the required paths
		set "MSYS2_PATH=C:\Msys2"
		set "msys2_install=y"
	)
)

if defined msys2_install (
	echo Installing Msys2
	call :CheckAdmin
	downloads\msys2.exe in --confirm-command --accept-messages --root C:/Msys2

	:: We need to change the write privilledges on the Msys folder 
	:: Because we installed it as an admin 
	:: But we want to be able to use pacman without being in an 
	:: admin shell because that's a pain
	echo Adding write permissions for you ...
	call :SetWritePermissions

	if not !errorLevel! == 0 (
		echo Failed to install msys2 
		cmd /k 
		exit 
	) else (
		echo Succesfully installed Msys2
	)
)

::
:: Choco for hyper
::
where /q choco
if not !errorLevel! == 0 (
	:: We need an admin shell for choco
	echo Installing Choco
	call :CheckAdmin
	@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

	if not !errorLevel! == 0 (
		echo Failed to install choco somewhere
		cmd /k 
		exit
	) else (
		echo Installed Choco Succesfully
	)
) else (
	echo Already got choco installed
)

::
:: Use choco to install hyper
::
where /q hyper
if not !errorLevel! == 0 (
	echo Installing Hyper 
	call :CheckAdmin
	choco install hyper -y
	echo Finished installing hyper
) else (
	echo Already got Hyper installed
)


:: 
echo Done installing Lawrence Windots
cmd /k

:CheckAdmin
	net session > nul 2>&1
	if not !errorLevel! == 0 (
		echo Need admin rights for this step
		cmd /k 
		exit 
	)

:SetWritePermissions
	icacls C:\Msys2 /grant Everyone:(OI)(CI)F /T > nul

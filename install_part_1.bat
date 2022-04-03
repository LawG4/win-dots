@echo off
:: To use set /p inside if statements 
:: Variables must now be referenced with a !_!
Setlocal EnableDelayedExpansion 

:: Ensure we have the installers downloaded
if not exist downloads (mkdir downloads)

:: Download the hyper terminal
if exist downloads/hyper.exe (
	echo Already downloaded hyper
) else (
	curl -LJ --output downloads/hyper.exe --url "https://github.com/vercel/hyper/releases/download/v3.2.0/Hyper-Setup-3.2.0.exe"	
	echo Finished downloading Hyper
)

:: Now we need to download the nightly build from Msys2 if they don't already exists
if exist downloads/msys2.exe (
	echo Already downloaded MSys2
) else (
	curl -LJ --output downloads/msys2.exe --url https://github.com/msys2/msys2-installer/releases/download/2022-03-19/msys2-x86_64-20220319.exe
	echo Finished downloading Msys2 
)

:: Check for the error state
if not !errorLevel! == 0 (
	echo failed to download either Msys2 or Hyper installers check downloads folder
	cmd /k
	exit
)

:: Find the location of the Msys uinstaller 
:: That will be are basis for if the location of msys2 has been found
set "MSYS2_PATH="
set "msys2_install="

if exist "C:\Program Files\Msys2\uninstall.exe" (set "MSYS2_PATH=C:\Program Files\Msys2")
if exist "C:\msys64\uninstall.exe" (set "MSYS2_PATH=C:\msys64")
if exist "C:\Msys2\uninstall.exe" (set "MSYS2_PATH=C:\Msys2")

:: Only if an install of msys2 was found then should we ask if they want to reinstall
if defined MSYS2_PATH (
	echo Do you want to reinstall Msys2 into C:\Msys2? y/n"
	set /p MSYS_UNINSTALL=""

	if /i "!MSYS_UNINSTALL!" == "y" (
		echo "Uninstalling Msys2"

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

		:: We have to wait a little bit for the file system to update
		timeout /t 2

	) else (
		echo Not uninstalling Msys2
	)
) else (
	echo No Msys2 install detected 
	:: The user does not have a Msys2 install so set the required paths
	set "MSYS2_PATH=C:\Msys2"
	set "msys2_install=y"
)

if defined msys2_install (
	echo Installing Msys2
	downloads\msys2.exe in --confirm-command --accept-messages --root C:/Msys2

	if not !errorLevel! == 0 (
		echo Failed to install msys2 
		cmd /k 
		exit 
	) else (
		echo Succesfully installed Msys2
	)
)

:: C:\Users\Lawrence\AppData\Local\Programs\Hyper
echo Done installing Lawrence Windots
cmd /k

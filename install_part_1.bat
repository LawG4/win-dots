@echo off

:: We're going to check if Msys2 has been installed and if it has we're going to uninstall it
if exist "C:\Program Files\Msys2\uninstall.exe" (
	echo "Found Msys2"
	"C:\Program Files\Msys2\uninstall.exe" pr --confirm-command
)

if exist "C:\msys64\uninstall.exe" (
	echo "Found Msys2"
	C:\msys64\uninstall.exe pr --confirm-command
)

if %errorLevel% == 0 (
	echo Sucessfully uninstalled Msys2
) else (
	echo Failed to uninstall Msys2
	cmd /k
	exit
)
echo Done installing Lawrence Windots

cmd /k
@echo off

:: First uninstall Msys2 if it was already installed
if exist "C:\Program Files\Msys2\uninstall.exe" (
	echo Found Msys2
	"C:\Program Files\Msys2\uninstall.exe" pr --confirm-command
)

if exist "C:\msys64\uninstall.exe" (
	echo Found Msys2
	C:\msys64\uninstall.exe pr --confirm-command
)

if not %errorLevel% == 0 (
	echo Failed to uninstall Msys2
	cmd /k
	exit
)

:: Ensure we have a place to store our downloads
if not exist downloads (mkdir downloads)

:: Now we need to download the nightly build from Msys2 if they don't already exists
if exist downloads/msys2.exe (
	echo Already downloaded an installer
) else (
	curl --output downloads/msys2.exe --url https://github.com/msys2/msys2-installer/releases/tag/nightly-x86_64
	if not %errorLevel% == 0 (
		echo failed to download msys2 installer
		cmd /k
		exit
	) else (
		echo Finished downloading msys2 
	)
)

echo Done installing Lawrence Windots

cmd /k
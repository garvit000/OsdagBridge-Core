@echo off
setlocal
echo Running post-link script for osdagbridge-core...

set "PY=%PREFIX%\python.exe"

REM The OsdagBridge standalone installer sets this variable and installs
REM openseespy/opsvis itself from wheels bundled inside the installer
REM (no internet needed). Nothing to do here in that case.
if "%OSDAGBRIDGE_OFFLINE_INSTALL%"=="1" (
    echo Standalone installer detected: pip dependencies are installed from bundled wheels.
    exit /b 0
)

REM Already present (e.g. package update / reinstall): skip the network round-trip.
"%PY%" -c "import importlib.util as u, sys; sys.exit(0 if u.find_spec('openseespy') and u.find_spec('opsvis') else 1)" >nul 2>&1
if not errorlevel 1 (
    echo openseespy and opsvis already installed.
    exit /b 0
)

REM Plain "conda install osdagbridge-core": fetch the pip-only dependencies.
REM Short timeout / few retries so an offline machine fails fast instead of hanging.
"%PY%" -m pip install --disable-pip-version-check --no-warn-script-location --timeout 20 --retries 2 "openseespy>=3.2.2.6" opsvis
if errorlevel 1 (
    echo WARNING: Optional pip dependencies failed to install.
    echo Please run manually: pip install openseespy opsvis
)

REM Never fail conda/constructor install because of pip
echo Post-link completed.
exit /b 0

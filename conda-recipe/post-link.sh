#!/bin/bash
echo "Running post-link script for osdagbridge-core..."

PY="$PREFIX/bin/python"

# The OsdagBridge standalone installer sets this variable and installs
# openseespy/opsvis itself from wheels bundled inside the installer
# (no internet needed). Nothing to do here in that case.
if [ "${OSDAGBRIDGE_OFFLINE_INSTALL:-0}" = "1" ]; then
    echo "Standalone installer detected: pip dependencies are installed from bundled wheels."
    exit 0
fi

# Already present (e.g. package update / reinstall): skip the network round-trip.
if "$PY" -c "import importlib.util as u, sys; sys.exit(0 if u.find_spec('openseespy') and u.find_spec('opsvis') else 1)" >/dev/null 2>&1; then
    echo "openseespy and opsvis already installed."
    exit 0
fi

# Plain "conda install osdagbridge-core": fetch the pip-only dependencies.
# Short timeout / few retries so an offline machine fails fast instead of hanging.
if ! "$PY" -m pip install --disable-pip-version-check --no-warn-script-location \
        --timeout 20 --retries 2 "openseespy>=3.2.2.6" opsvis; then
    echo "WARNING: Optional pip dependencies failed."
    echo "Run manually: pip install openseespy opsvis"
fi

# Never fail conda/constructor install because of pip
echo "Post-link completed."
exit 0

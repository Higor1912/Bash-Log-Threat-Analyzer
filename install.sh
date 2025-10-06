#!/usr/bin/env bash
set -e

echo "[+] Construindo pacote LogHawk..."
dpkg-deb --build loghawk

echo "[✔ Pacote criado:loghawk.deb"
echo "[+] para instalar use:"
echo "    sudo dpkg -i loghawk.deb"

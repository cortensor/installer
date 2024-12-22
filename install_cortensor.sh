#!/bin/bash

# Langkah 1: Perbarui Sistem
echo "Memperbarui sistem..."
apt update && apt upgrade -y

# Langkah 2: Pastikan Dependencies Terpasang
echo "Menginstal dependencies..."
apt install -y curl git unzip tar

# Langkah 3: Unduh Installer
echo "Mengunduh installer Cortensor..."
git clone https://github.com/cortensor/installer
cd installer

# Opsional: Unduh Binary
if [ -n "$1" ]; then
  echo "Mengunduh binary dari URL: $1..."
  curl "$1" -o cortensor-installer-latest.tar.gz
  tar xzfv cortensor-installer-latest.tar.gz
  cd installer
fi

# Langkah 4: Instalasi
echo "Menginstal Docker..."
./install-docker.sh

echo "Menginstal IPFS..."
./install-ipfs.sh

echo "Menginstal Cortensord..."
./install.sh

# Verifikasi Instalasi
echo "Verifikasi instalasi..."
ls -al /usr/local/bin/cortensord
ls -al /etc/systemd/system/cortensor.service
docker version
ipfs version

# Langkah 5: Konfigurasi Node
echo "Membuat akun 'deploy'..."
sudo su deploy -c "cd ~/ && /usr/local/bin/cortensord ~/.cortensor/.env tool gen_key"

echo "Whitelist alamat node..."
/usr/local/bin/cortensord ~/.cortensor/.env tool register
/usr/local/bin/cortensord ~/.cortensor/.env tool verify

# Langkah 6: Menjalankan Node
echo "Menjalankan node menggunakan systemd..."
sudo systemctl start cortensor

echo "Node berhasil dijalankan! Untuk menghentikan node gunakan: sudo systemctl stop cortensor"

# Langkah 7: Debugging & Monitoring
echo "Menampilkan log untuk debugging..."
tail -f /var/log/cortensord.log &

# Informasi Tambahan
echo "Periksa ID node Anda:"
/usr/local/bin/cortensord ~/.cortensor/.env tool id

echo "Periksa statistik node Anda:"
/usr/local/bin/cortensord ~/.cortensor/.env tool stats

echo "Instalasi dan konfigurasi selesai!"

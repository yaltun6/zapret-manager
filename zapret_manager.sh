#!/bin/sh

ZAPRET_DIR="/opt/zapret"
BACKUP_FILE="/opt/zapret_backup.tar.gz"

while true; do
  echo "===== ZAPRET YÖNETİCİ ====="
  echo "1) Zapret kur (GitHub)"
  echo "2) Zapret yedekle"
  echo "3) Zapret geri yükle"
  echo "4) Zapret kaldır"
  echo "5) Zapret başlat"
  echo "6) Zapret durdur"
  echo "7) Config düzenle (TTL/hostspell)"
  echo "8) Çıkış"
  echo -n "Seçiminiz: "
  read secim

  case "$secim" in
    1)
      echo ">> Zapret kuruluyor..."
      cd /opt
      if [ ! -d "$ZAPRET_DIR" ]; then
        git clone https://github.com/yaltun6/zapret-manager.git zapret
        chmod +x "$ZAPRET_DIR"/zapret_manager.sh 2>/dev/null
        echo ">> Kurulum tamamlandı."
      else
        echo ">> Zapret zaten kurulmuş."
      fi
      ;;
    2)
      if [ -d "$ZAPRET_DIR" ]; then
        echo ">> Yedek alınıyor..."
        tar -czf "$BACKUP_FILE" "$ZAPRET_DIR"
        echo ">> Yedek: $BACKUP_FILE"
      else
        echo ">> Zapret bulunamadı!"
      fi
      ;;
    3)
      if [ -f "$BACKUP_FILE" ]; then
        echo ">> Geri yükleniyor..."
        rm -rf "$ZAPRET_DIR"
        tar -xzf "$BACKUP_FILE" -C /opt
        echo ">> Geri yükleme tamamlandı."
      else
        echo ">> Yedek dosyası bulunamadı!"
      fi
      ;;
    4)
      if [ -d "$ZAPRET_DIR" ]; then
        echo ">> Zapret kaldırılıyor..."
        rm -rf "$ZAPRET_DIR"
        echo ">> Kaldırıldı."
      else
        echo ">> Zapret bulunamadı!"
      fi
      ;;
    5)
      if [ -f "$ZAPRET_DIR/init.d/sysv/zapret" ]; then
        echo ">> Zapret başlatılıyor..."
        "$ZAPRET_DIR"/init.d/sysv/zapret start
      else
        echo ">> Başlatma betiği bulunamadı!"
      fi
      ;;
    6)
      if [ -f "$ZAPRET_DIR/init.d/sysv/zapret" ]; then
        echo ">> Zapret durduruluyor..."
        "$ZAPRET_DIR"/init.d/sysv/zapret stop
      else
        echo ">> Durdurma betiği bulunamadı!"
      fi
      ;;
    7)
      if [ -f "$ZAPRET_DIR/config" ]; then
        echo ">> Config düzenleniyor..."
        nano "$ZAPRET_DIR/config"
      else
        echo ">> Config dosyası bulunamadı!"
      fi
      ;;
    8)
      echo "Çıkılıyor..."
      exit 0
      ;;
    *)
      echo "Geçersiz seçim!"
      ;;
  esac
done

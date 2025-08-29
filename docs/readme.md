# Zapret Kurulum Rehberi (Asus MerlinWRT + Entware)

**Uyumlu Modeller:** Asus AX88U ve benzeri MerlinWRT cihazlar
**Gereksinimler:** Entware kurulumu, USB depolama

Bu rehber, Asus cihazınızda Zapret’i stabil şekilde çalıştırmak için adım adım kurulum sürecini anlatır.

---

## 1️⃣ USB Bellek Hazırlığı

1. USB belleğinizi modeme takın (sabit olarak kalmalı).
2. SSH ile modeme root olarak bağlanın.
3. Bağlı diskleri kontrol edin:

```sh
df -h
```

4. USB belleği unmount edin:

```sh
umount -l /dev/sda2
```

5. Belleği ext2 olarak formatlayın:

```sh
mkfs.ext2 /dev/sda2
```

* Sorulara **Y** olarak cevap verin.
* İşlem yaklaşık 10 dakika sürer, “**Done**” yazısını görünce tamamdır.

⚠️ USB belleği modemde söküp tekrar takmanız gerekir.

---

## 2️⃣ Entware Kurulumu

1. SSH’de aşağıdaki komutları çalıştırın:

```sh
cd /tmp/share
wget https://raw.githubusercontent.com/RMerl/release/src/router/others/entware-setup.sh
chmod +x /tmp/share/entware-setup.sh
/tmp/share/entware-setup.sh
```

2. Kurulum sırasında seçenek sorulacaktır:

* Eğer **1** olarak gözüküyorsa **1** yazıp ilerleyin.
* Kurulum birkaç dakika sürecektir.
* Başarılı ise mesaj göreceksiniz:

```
Entware kurulumu tamamlandı.
```

---

## 3️⃣ Zapret Yönetim Betiği Kurulumu

### 1. /opt dizinine geçin ve zapret dizinini oluşturun

```sh
cd /opt
mkdir -p zapret
cd zapret
```

### 2. `zapret_manager.sh` dosyasını oluşturun

Terminalde aşağıdaki komutu çalıştırarak dosyayı oluşturabilirsiniz:

```sh
cat > zapret_manager.sh << 'EOF'
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
EOF
```

### 3. Dosyaya çalıştırma izni verin

```sh
chmod +x zapret_manager.sh
```

### 4. Yönetim scriptini çalıştırın

```sh
./zapret_manager.sh
```

Bu script sayesinde Zapret’i kurabilir, yedek alabilir, geri yükleyebilir, başlatıp durdurabilir ve config dosyasını düzenleyebilirsiniz.


## 4️⃣ Zapret Kurulumu

Menüden **1) Zapret kur (GitHub)** seçeneğini seçin.

Kurulum sırasında sorulara **Enter tuşuna basın** (varsayılan değerler kullanılacaktır).

**Önerilen Varsayılan Seçimler:**

| Soru                   | Varsayılan / Önerilen                  |
| ---------------------- | -------------------------------------- |
| Continue installation? | Enter (default: N → otomatik Evet)     |
| Firewall type          | Enter (default: iptables)              |
| IPv6 support           | Enter (default: N)                     |
| Filtering              | Enter (default: none)                  |
| TPWS socks mode        | Enter (default: N)                     |
| TPWS transparent mode  | Enter (default: N)                     |
| Enable NFQWS?          | Enter (default: Y)                     |
| Edit NFQWS options?    | **n** (otomatik varsayılan kullanılır) |

> Bu ayarlar çoğu kullanıcı için sorunsuz çalışır.

Kurulum tamamlandıktan sonra menü açılır ve artık **Başlat / Durdur / Config düzenleme** seçeneklerini kullanabilirsiniz.

---

## 5️⃣ Önerilen Paketler

Stabil çalışması için kurulum öncesi aşağıdaki paketleri yükleyin:

```sh
opkg update
opkg install coreutils-sort curl git-http grep gzip ipset iptables kmod_ndms nano xtables-addons_legacy nmap nmap-ssl netcat procps-ng-sysctl procps-ng-pgrep gcc make libpcap libpcap-dev
```

---

## 6️⃣ Notlar

* Modemde **AdGuard** veya başka DNS çözümleyici kullanabilirsiniz, Zapret ile birlikte sorunsuz çalışır.
* USB belleğinizi çıkarmayın, Zapret dosyaları buradan çalışır.
* Kurulum tamamlandıktan sonra **/opt/zapret\_manager.sh** betiği ile Zapret’i yönetebilirsiniz.


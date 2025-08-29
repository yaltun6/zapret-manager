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

1. Betiği indirip çalıştırılabilir yapın:

```sh
mkdir -p /opt
curl -L https://raw.githubusercontent.com/yaltun6/zapret-manager/main/zapret_manager.sh -o /opt/zapret_manager.sh
chmod +x /opt/zapret_manager.sh
```

2. Betiği çalıştırın:

```sh
/opt/zapret_manager.sh
```

---

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


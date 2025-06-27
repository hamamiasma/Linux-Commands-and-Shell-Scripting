# 🌐 أوامر الشبكات الأساسية في Linux

##  المحتويات

- [مقدمة](#-مقدمة)
- [معرفة معلومات الجهاز - hostname](#-معرفة-معلومات-الجهاز---hostname)
- [تكوين الشبكة - ifconfig](#-تكوين-الشبكة---ifconfig)
- [اختبار الاتصال - ping](#-اختبار-الاتصال---ping)
- [تحميل البيانات - curl](#-تحميل-البيانات---curl)
- [تحميل الملفات - wget](#-تحميل-الملفات---wget)
- [أوامر شبكات إضافية](#-أوامر-شبكات-إضافية)
- [استكشاف الأخطاء](#-استكشاف-الأخطاء)
- [التمارين العملية](#-التمارين-العملية)
- [أفضل الممارسات](#-أفضل-الممارسات)

##  مقدمة

أوامر الشبكات في Linux هي أدوات قوية لـ:
- **التشخيص**: فحص حالة الاتصال والشبكة
- **المراقبة**: متابعة أداء الشبكة وحركة البيانات
- **التحميل**: جلب الملفات والبيانات من الإنترنت
- **الإدارة**: تكوين وإدارة اتصالات الشبكة

### فوائد إتقان أوامر الشبكات:
- 🔍 **تشخيص مشاكل الاتصال** بسرعة
- 📊 **مراقبة أداء الشبكة** في الوقت الفعلي
- 🌍 **تحميل الملفات** مباشرة من الطرفية
- ⚡ **أتمتة المهام** الشبكية

##  معرفة معلومات الجهاز - hostname

### الوظيفة الأساسية
عرض أو تعديل اسم الجهاز (host name) ومعلومات الشبكة الأساسية.

### الاستخدام الأساسي

```bash
# عرض اسم الجهاز
hostname
```
**مثال النتيجة:** `my-linux-machine`

### الخيارات المفيدة

```bash
# عرض اسم الجهاز مع النطاق الكامل
hostname -f

# عرض عنوان IP للجهاز
hostname -i

# عرض اسم الجهاز بدون النطاق
hostname -s

# عرض جميع عناوين IP
hostname -I
```

### جدول خيارات hostname

| الخيار | الوصف |
|--------|--------|
| `-f` | الاسم الكامل مع النطاق (FQDN) |
| `-i` | عنوان IP الأساسي |
| `-I` | جميع عناوين IP |
| `-s` | الاسم المختصر بدون النطاق |
| `-d` | اسم النطاق فقط |

### تغيير اسم الجهاز

```bash
# تغيير مؤقت (حتى إعادة التشغيل)
sudo hostname new-hostname

# تغيير دائم
echo "new-hostname" | sudo tee /etc/hostname
sudo hostnamectl set-hostname new-hostname  # في الأنظمة الحديثة
```

### أمثلة عملية

```bash
# معرفة معلومات كاملة عن الجهاز
echo "اسم الجهاز: $(hostname)"
echo "عنوان IP: $(hostname -i)"
echo "النطاق: $(hostname -d)"
echo "الاسم الكامل: $(hostname -f)"
```

##  تكوين الشبكة - ifconfig

### الوظيفة الأساسية
عرض وتكوين معلومات كروت الشبكة (IP، MAC، إحصائيات البيانات).

### الاستخدام الأساسي

```bash
# عرض جميع واجهات الشبكة
ifconfig

# عرض واجهة محددة
ifconfig eth0

# عرض الواجهات النشطة فقط
ifconfig -s
```

### فهم مخرجات ifconfig

```
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::a00:27ff:fe4e:66a1  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:4e:66:a1  txqueuelen 1000  (Ethernet)
        RX packets 1234  bytes 567890 (554.5 KiB)
        TX packets 987   bytes 432100 (421.9 KiB)
```

#### تفسير المعلومات:

| المعلومة | المعنى |
|----------|--------|
| `inet` | عنوان IP الحالي |
| `netmask` | قناع الشبكة |
| `broadcast` | عنوان البث |
| `ether` | عنوان MAC |
| `RX packets` | الحزم المُستقبلة |
| `TX packets` | الحزم المُرسلة |

### البديل الحديث - ip

```bash
# عرض جميع الواجهات (البديل الحديث)
ip addr show
# أو باختصار
ip a

# عرض واجهة محددة
ip addr show eth0

# عرض جدول التوجيه
ip route show
```

### أوامر التكوين الأساسية

```bash
# تفعيل واجهة الشبكة
sudo ifconfig eth0 up

# إيقاف واجهة الشبكة
sudo ifconfig eth0 down

# تعيين عنوان IP يدوياً
sudo ifconfig eth0 192.168.1.50

# تعيين قناع الشبكة
sudo ifconfig eth0 192.168.1.50 netmask 255.255.255.0
```

## 🌐 اختبار الاتصال - ping

### الوظيفة الأساسية
إرسال حزم ICMP Echo Request لاختبار الاتصال مع جهاز أو موقع.

### الاستخدام الأساسي

```bash
# اختبار الاتصال مع موقع
ping google.com

# إيقاف الاختبار
# اضغط Ctrl + C
```

### الخيارات المفيدة

```bash
# تحديد عدد الحزم
ping -c 5 google.com

# تحديد حجم الحزمة
ping -s 1000 google.com

# تحديد الفترة بين الحزم (ثانية)
ping -i 2 google.com

# إظهار الطابع الزمني
ping -D google.com
```

### جدول خيارات ping

| الخيار | الوصف |
|--------|--------|
| `-c N` | إرسال N حزمة ثم التوقف |
| `-i N` | فترة N ثانية بين الحزم |
| `-s N` | حجم الحزمة N بايت |
| `-t N` | TTL (مدة البقاء) |
| `-W N` | مهلة انتظار الرد N ثانية |
| `-D` | إظهار الطابع الزمني |

### تحليل نتائج ping

```
PING google.com (172.217.12.46) 56(84) bytes of data.
64 bytes from fra16s13-in-f14.1e100.net (172.217.12.46): icmp_seq=1 ttl=57 time=23.4 ms
64 bytes from fra16s13-in-f14.1e100.net (172.217.12.46): icmp_seq=2 ttl=57 time=22.1 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss
round-trip min/avg/max/mdev = 22.120/22.750/23.380/0.630 ms
```

#### تفسير النتائج:

| المؤشر | المعنى |
|--------|--------|
| `time` | زمن الاستجابة بالميلي ثانية |
| `ttl` | عدد القفزات المتبقية |
| `packet loss` | نسبة فقدان الحزم |
| `min/avg/max` | أقل/متوسط/أكبر زمن استجابة |

### استخدامات عملية

```bash
# اختبار الاتصال المحلي
ping 127.0.0.1

# اختبار gateway الشبكة
ping $(ip route | grep default | awk '{print $3}')

# اختبار DNS
ping 8.8.8.8

# اختبار مع تقرير سريع
ping -c 3 -q google.com
```

## 📥 تحميل البيانات - curl

### الوظيفة الأساسية
أداة متعددة الاستخدامات لنقل البيانات من وإلى الخوادم.

### الاستخدام الأساسي

```bash
# تحميل صفحة ويب
curl www.google.com

# تحميل وحفظ في ملف
curl www.google.com -o google.html

# عرض headers فقط
curl -I www.google.com
```

### الخيارات الأساسية

| الخيار | الوصف |
|--------|--------|
| `-o filename` | حفظ في ملف محدد |
| `-O` | حفظ باسم الملف الأصلي |
| `-I` | عرض headers فقط |
| `-L` | متابعة redirects |
| `-s` | صامت (بدون progress) |
| `-v` | verbose (معلومات مفصلة) |

### استخدامات متقدمة

```bash
# تحميل ملف مع شريط التقدم
curl -L -O https://releases.ubuntu.com/20.04/ubuntu-20.04.3-desktop-amd64.iso

# إرسال POST request
curl -X POST -d "name=Ahmed&age=25" http://httpbin.org/post

# إرسال JSON data
curl -X POST -H "Content-Type: application/json" \
     -d '{"name":"Ahmed","age":25}' \
     http://httpbin.org/post

# استخدام authentication
curl -u username:password https://api.example.com/data

# تحميل مع متابعة في حالة الانقطاع
curl -C - -O https://example.com/largefile.zip
```

### اختبار APIs

```bash
# GET request
curl https://jsonplaceholder.typicode.com/posts/1

# POST request
curl -X POST -H "Content-Type: application/json" \
     -d '{"title":"test","body":"content","userId":1}' \
     https://jsonplaceholder.typicode.com/posts

# عرض headers وbody
curl -i https://httpbin.org/json
```

### أمثلة عملية

```bash
# فحص حالة موقع
curl -o /dev/null -s -w "%{http_code}" http://example.com

# تحميل عدة ملفات
curl -O https://example.com/file[1-5].txt

# تحميل مع تحديد User-Agent
curl -A "Mozilla/5.0" https://example.com
```

## 📦 تحميل الملفات - wget

### الوظيفة الأساسية
أداة مخصصة لتحميل الملفات من الإنترنت مع دعم التحميل التكراري.

### الاستخدام الأساسي

```bash
# تحميل ملف واحد
wget https://example.com/file.txt

# تحميل مع إعادة التسمية
wget -O newname.txt https://example.com/file.txt

# تحميل في الخلفية
wget -b https://example.com/largefile.zip
```

### الخيارات المفيدة

| الخيار | الوصف |
|--------|--------|
| `-O filename` | حفظ باسم مختلف |
| `-P directory` | حفظ في مجلد محدد |
| `-c` | استكمال التحميل المنقطع |
| `-b` | تحميل في الخلفية |
| `-q` | صامت |
| `-v` | verbose |
| `-t N` | عدد المحاولات |

### التحميل التكراري

```bash
# تحميل موقع كامل
wget -r -np -k https://example.com

# تحميل مع تحديد عمق المستويات
wget -r -l 2 https://example.com

# تحميل أنواع ملفات محددة فقط
wget -r -A "*.pdf,*.doc" https://example.com
```

### إدارة التحميل

```bash
# استكمال تحميل منقطع
wget -c https://example.com/largefile.zip

# تحديد عدد المحاولات
wget -t 5 https://example.com/file.txt

# تحديد timeout
wget --timeout=30 https://example.com/file.txt

# تحميل مع authentication
wget --user=username --password=password https://example.com/file.txt
```

### مثال عملي شامل

```bash
# تحميل ملف ISO مع استكمال واستئناف
wget -c -t 0 --timeout=30 \
     https://releases.ubuntu.com/20.04/ubuntu-20.04.3-desktop-amd64.iso

# عرض محتوى الملف المحمل
head -n 12 iso_8859-1.txt
```

##  أوامر شبكات إضافية

### netstat - مراقبة الاتصالات

```bash
# عرض جميع الاتصالات
netstat -a

# عرض الاتصالات النشطة
netstat -t

# عرض البرامج المستخدمة للمنافذ
sudo netstat -tlnp

# عرض إحصائيات الشبكة
netstat -s
```

### ss - البديل الحديث لnetstat

```bash
# عرض الاتصالات النشطة
ss -t

# عرض منافذ الاستماع
ss -l

# عرض TCP مع معلومات العملية
ss -tlp
```

### nslookup & dig - استعلام DNS

```bash
# استعلام DNS أساسي
nslookup google.com

# استعلام متقدم
dig google.com

# استعلام نوع محدد
dig google.com MX
dig google.com NS
```

### traceroute - تتبع المسار

```bash
# تتبع المسار إلى موقع
traceroute google.com

# مع عرض عناوين IP فقط
traceroute -n google.com
```

## 🔍 استكشاف الأخطاء

### مشاكل الاتصال الشائعة

#### 1. لا يوجد اتصال بالإنترنت

```bash
# فحص الواجهات
ip a

# فحص gateway
ip route show

# اختبار DNS
ping 8.8.8.8
nslookup google.com
```

#### 2. بطء في الاتصال

```bash
# فحص زمن الاستجابة
ping -c 10 google.com

# تتبع المسار
traceroute google.com

# فحص استخدام النطاق
sudo iftop  # إذا كان مثبتاً
```

#### 3. مشاكل DNS

```bash
# اختبار DNS servers مختلفة
nslookup google.com 8.8.8.8
nslookup google.com 1.1.1.1

# فحص ملف hosts
cat /etc/hosts

# فحص إعدادات DNS
cat /etc/resolv.conf
```

### نص برمجي لتشخيص الشبكة

```bash
#!/bin/bash
echo "=== تشخيص الشبكة ==="
echo "1. معلومات الجهاز:"
hostname -f

echo -e "\n2. واجهات الشبكة:"
ip a | grep -E "(inet|UP)"

echo -e "\n3. Gateway:"
ip route | grep default

echo -e "\n4. اختبار الاتصال:"
ping -c 3 -q 8.8.8.8 | tail -3

echo -e "\n5. اختبار DNS:"
nslookup google.com | grep Address
```

##  التمارين العملية

### تمرين 1: فحص الشبكة الأساسي

```bash
# 1. معرفة اسم جهازك وIP
hostname
hostname -i

# 2. فحص واجهات الشبكة
ifconfig
# أو
ip a

# 3. اختبار الاتصال
ping -c 5 google.com

# 4. فحص gateway
ip route | grep default
```

### تمرين 2: تحميل وتحليل ملف

```bash
# 1. تحميل ملف نصي
wget https://www.w3.org/TR/PNG/iso_8859-1.txt

# 2. عرض معلومات الملف
ls -lh iso_8859-1.txt

# 3. عرض بداية الملف
head -n 15 iso_8859-1.txt

# 4. البحث في الملف
grep -i "character" iso_8859-1.txt
```

### تمرين 3: مراقبة حركة الشبكة

```bash
# 1. عرض الاتصالات النشطة
netstat -t

# 2. عرض المنافذ المفتوحة
ss -tlnp

# 3. مراقبة حزم ping
ping google.com &
PING_PID=$!
sleep 10
kill $PING_PID
```

### تمرين 4: تنزيل وأرشفة موقع

```bash
# 1. إنشاء مجلد للتحميل
mkdir website_backup

# 2. تحميل صفحة رئيسية
cd website_backup
wget -k -p https://example.com

# 3. فحص الملفات المحملة
find . -type f | head -10

# 4. أرشفة الملفات
cd ..
tar -czf website_backup.tar.gz website_backup/
```

##  أفضل الممارسات

### أمان الشبكة

```bash
# تجنب إرسال كلمات مرور في URLs
# خطر:
wget http://user:password@example.com/file.txt

# أمان:
wget --user=user --ask-password https://example.com/file.txt
```

### تحسين الأداء

```bash
# استخدام عدة اتصالات متوازية
wget --limit-rate=200k https://example.com/largefile.zip

# تحديد User-Agent مناسب
curl -A "Mozilla/5.0 (compatible; bot)" https://api.example.com

# استخدام مهلة زمنية مناسبة
curl --connect-timeout 10 --max-time 30 https://example.com
```

### إدارة البيانات

```bash
# حفظ logs التحميل
wget -o download.log https://example.com/file.txt

# تحميل مع إعادة المحاولة
wget -t 3 -w 5 https://example.com/file.txt

# التحقق من سلامة الملف
wget https://example.com/file.txt
wget https://example.com/file.txt.sha256
sha256sum -c file.txt.sha256
```

##  مراقبة الأداء

### أدوات مراقبة الشبكة

```bash
# مراقبة استخدام الشبكة
sudo iftop -i eth0

# مراقبة الاتصالات
watch -n 1 'netstat -i'

# إحصائيات الشبكة
cat /proc/net/dev
```

### نص برمجي لمراقبة الأداء

```bash
#!/bin/bash
# حدد اسم كرت الشبكة الذي تتم مراقبته (يمكن تغييره مثلًا إلى wlan0 لشبكة Wi-Fi).
INTERFACE="eth0"
echo "مراقبة أداء الشبكة لـ $INTERFACE"

while true; do
    #  يقرأ عدد البايتات المستقبلَة (rx) والمرسَلة (tx) منذ تشغيل النظام.
    RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    #  يطبع التاريخ الحالي مع القيم.
    echo "$(date): RX: $RX_BYTES bytes, TX: $TX_BYTES bytes"
    # ينتظر ثانية واحدة قبل التكرار.
    sleep 1
done
```

## 🔗 الخطوات التالية

بعد إتقان أوامر الشبكات الأساسية:

1. **تعلم إعداد الشبكات** (network configuration)
2. **استكشاف أمان الشبكات** (firewall, iptables)
3. **إدارة خدمات الشبكة** (SSH, FTP, HTTP)
4. **مراقبة الشبكة المتقدمة** (tcpdump, wireshark)

## 📚 ملخص سريع

| الأمر | الوظيفة الأساسية | مثال |
|-------|------------------|-------|
| `hostname` | معلومات الجهاز | `hostname -i` |
| `ifconfig` | تكوين الشبكة | `ifconfig eth0` |
| `ping` | اختبار الاتصال | `ping -c 5 google.com` |
| `curl` | تحميل البيانات | `curl -O https://example.com/file.txt` |
| `wget` | تحميل الملفات | `wget -c https://example.com/file.zip` |

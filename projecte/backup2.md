# المهام 14 و 15: النسخ الاحتياطي اليدوي والأتمتة

## 📋 المحتويات

- [المهمة 14: إجراء النسخ الاحتياطي اليدوي](#-المهمة-14-إجراء-النسخ-الاحتياطي-اليدوي)
- [المهمة 15: الأتمتة باستخدام Cron](#-المهمة-15-الأتمتة-باستخدام-cron)
- [التحقق من النتائج](#-التحقق-من-النتائج)
- [استكشاف الأخطاء](#-استكشاف-الأخطاء)
- [نصائح متقدمة](#-نصائح-متقدمة)

---

##  المهمة 14: إجراء النسخ الاحتياطي اليدوي

هذا القسم يشرح كيفية تنفيذ نسخة احتياطية يدوية لمجلد `important-documents` باستخدام سكربت `backup.sh`.

### 1️⃣ تحميل ملف الأرشيف

```bash
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-LX0117EN-SkillsNetwork/labs/Final%20Project/important-documents.zip
```

**الشرح:**
- `wget`: أداة لتحميل الملفات من الإنترنت
- سيتم تحميل ملف ZIP يحتوي على وثائق تجريبية للاختبار

### 2️⃣ فك الضغط بدون استعادة التواريخ الأصلية

```bash
unzip -DDo important-documents.zip
```

**شرح المعاملات:**
- `-D`: عدم إنشاء مجلدات إضافية
- `-D`: عدم استعادة التواريخ الأصلية للملفات
- `-o`: الكتابة فوق الملفات الموجودة بدون تأكيد

**لماذا هذا مهم؟**
- نريد أن تظهر الملفات كما لو تم تعديلها "الآن"
- هذا يضمن أن السكربت سيجدها ضمن آخر 24 ساعة

### 3️⃣ تحديث وقت التعديل لجميع الملفات

```bash
touch important-documents/*
```

**الشرح:**
- `touch`: يحدث وقت آخر تعديل للملفات
- `*`: جميع الملفات في المجلد
- هذا يضمن أن جميع الملفات تظهر كأنها حُدثت "الآن"

**التحقق من النتيجة:**
```bash
ls -la important-documents/
```

### 4️⃣ تشغيل سكربت النسخ الاحتياطي

```bash
./backup.sh important-documents .
```

**شرح المعاملات:**
- `important-documents`: مجلد المصدر
- `.`: المجلد الحالي كوجهة للنسخة الاحتياطية

**ما يحدث داخلياً:**
1. السكربت يبحث عن الملفات المحدثة في آخر 24 ساعة
2. يضعها في مصفوفة `toBackup`
3. ينشئ أرشيف مضغوط باستخدام `tar -czf`
4. ينقل الأرشيف إلى مجلد الوجهة

### 5️⃣ التحقق من النسخة الاحتياطية

```bash
ls -l backup-*.tar.gz
```

**النتيجة المتوقعة:**
- ملف باسم `backup-[TIMESTAMP].tar.gz`
- رسالة من السكربت: `✅ Backup completed`

**فحص محتويات الأرشيف:**
```bash
tar -tzf backup-*.tar.gz
```

**مثال للناتج:**
```
important-documents/
-rw-r--r-- 1 user user 1234 Dec 20 10:30 backup-[1703073000].tar.gz
```

---

## ⏰ المهمة 15: الأتمتة باستخدام Cron

هذا القسم يوضح كيفية تثبيت وجدولة سكربت `backup.sh` ليعمل تلقائياً كل 24 ساعة.

### 1️⃣ نسخ السكربت إلى مجلد النظام

```bash
sudo cp backup.sh /usr/local/bin/backup.sh
sudo chmod +x /usr/local/bin/backup.sh
```

**أهمية هذه الخطوة:**
- ✅ يصبح السكربت متاحاً لجميع المستخدمين
- ✅ يمكن تشغيله من أي مكان في النظام
- ✅ Cron يمكنه الوصول إليه بسهولة

**لماذا `cp` وليس `mv`؟**
- نحتفظ بنسخة للتطوير والاختبار
- الأمان في حالة حدوث مشاكل

**التحقق من التثبيت:**
```bash
which backup.sh
ls -l /usr/local/bin/backup.sh
```

### 2️⃣ بدء خدمة Cron

#### في أنظمة Linux:
```bash
sudo service cron start
```

#### في macOS:
```bash
sudo launchctl load -w /System/Library/LaunchDaemons/com.vix.cron.plist
sudo launchctl list | grep cron
```

**التحقق من أن الخدمة تعمل:**
```bash
sudo service cron status
```

**في حالة عدم وجود خدمة cron:**
```bash
# تثبيت cron في Ubuntu/Debian
sudo apt update
sudo apt install cron

# في CentOS/RHEL
sudo yum install cronie
sudo systemctl enable crond
sudo systemctl start crond
```

### 3️⃣ جدولة مهمة Cron

#### فتح محرر Crontab:
```bash
crontab -e
```

**إذا كانت المرة الأولى:**
- قد يطلب منك اختيار محرر (nano, vim, etc.)
- اختر `nano` للسهولة

#### إضافة المهمة اليومية:
```bash
0 2 * * * /usr/local/bin/backup.sh /Users/asmaahamami/Downloads/Linux/important-documents /Users/asmaahamami/Downloads/Linux >> /Users/asmaahamami/backup-cron.log 2>&1
```

**شرح صيغة Cron:**
```
0 2 * * * command
│ │ │ │ │
│ │ │ │ └── يوم الأسبوع (0-7) (الأحد = 0 أو 7)
│ │ │ └──── الشهر (1-12)
│ │ └────── يوم الشهر (1-31)
│ └──────── الساعة (0-23)
└────────── الدقيقة (0-59)
```

**شرح التوجيه:**
- `>>`: إضافة المخرجات إلى ملف السجل
- `2>&1`: توجيه الأخطاء أيضاً إلى نفس الملف

#### أمثلة أخرى على الجدولة:
```bash
# كل ساعة
0 * * * * /usr/local/bin/backup.sh /path/to/source /path/to/dest

# كل يوم في منتصف الليل
0 0 * * * /usr/local/bin/backup.sh /path/to/source /path/to/dest

# كل أسبوع يوم الأحد الساعة 3 صباحاً
0 3 * * 0 /usr/local/bin/backup.sh /path/to/source /path/to/dest

# كل شهر في اليوم الأول الساعة 1 صباحاً
0 1 1 * * /usr/local/bin/backup.sh /path/to/source /path/to/dest
```

### 4️⃣ حفظ والخروج

#### في محرر Nano:
1. `Ctrl + O` للحفظ
2. `Enter` لتأكيد اسم الملف
3. `Ctrl + X` للخروج

#### في محرر Vim:
1. `Esc` للعودة إلى Command mode
2. `:wq` للحفظ والخروج
3. `Enter` لتنفيذ الأمر

### 5️⃣ التحقق من المهمة

```bash
crontab -l
```

**النتيجة المتوقعة:**
```
0 2 * * * /usr/local/bin/backup.sh /Users/asmaahamami/Downloads/Linux/important-documents /Users/asmaahamami/Downloads/Linux >> /Users/asmaahamami/backup-cron.log 2>&1
```

---

## ✅ التحقق من النتائج

### 1️⃣ اختبار المهمة يدوياً

```bash
# تشغيل المسار الكامل للتأكد
/usr/local/bin/backup.sh /Users/asmaahamami/Downloads/Linux/important-documents /Users/asmaahamami/Downloads/Linux
```

### 2️⃣ مراقبة مجلد الوجهة

```bash
# مراقبة الملفات الجديدة
watch -n 10 'ls -lt /Users/asmaahamami/Downloads/Linux/backup-*.tar.gz | head -5'
```

### 3️⃣ فحص سجل Cron

```bash
# فحص سجل النظام
sudo tail -f /var/log/syslog | grep CRON

# فحص السجل المخصص
tail -f /Users/asmaahamami/backup-cron.log
```

### 4️⃣ اختبار سريع (كل دقيقة)

للاختبار السريع، يمكنك تعديل الجدولة مؤقتاً:
```bash
crontab -e
# تغيير إلى:
* * * * * /usr/local/bin/backup.sh /path/to/source /path/to/dest >> /path/to/log 2>&1
```

**مراقبة النتائج:**
```bash
# انتظر دقيقتين ثم تحقق
sleep 120
ls -lt backup-*.tar.gz
```

**إعادة الجدولة للوضع العادي:**
```bash
crontab -e
# العودة إلى:
0 2 * * * /usr/local/bin/backup.sh /path/to/source /path/to/dest >> /path/to/log 2>&1
```

### 5️⃣ إيقاف الخدمة (عند الانتهاء من الاختبار)

```bash
sudo service cron stop
```

---

## 🔧 استكشاف الأخطاء

### المشكلة: Cron لا يعمل

**التحقق من الخدمة:**
```bash
sudo service cron status
sudo service cron restart
```

**فحص سجلات النظام:**
```bash
sudo tail -f /var/log/syslog | grep cron
journalctl -u cron -f  # في الأنظمة الحديثة
```

### المشكلة: السكربت لا يعمل في Cron

**أسباب محتملة:**
1. **مسارات نسبية**: Cron لا يستخدم نفس PATH
2. **صلاحيات**: المستخدم لا يملك صلاحيات كافية
3. **متغيرات البيئة**: مختلفة عن shell التفاعلي

**الحلول:**
```bash
# 1. استخدام مسارات مطلقة في السكربت
# بدلاً من: tar -czf
# استخدم: /bin/tar -czf

# 2. تعيين PATH في crontab
crontab -e
# إضافة في البداية:
PATH=/usr/local/bin:/usr/bin:/bin

# 3. اختبار البيئة
* * * * * env > /tmp/cron-env.txt
```

### المشكلة: ملفات السجل كبيرة جداً

**تدوير السجلات:**
```bash
# إضافة لـ crontab
0 0 * * 0 gzip /Users/asmaahamami/backup-cron.log && touch /Users/asmaahamami/backup-cron.log

# أو استخدام logrotate
sudo nano /etc/logrotate.d/backup-cron
```

### المشكلة: مساحة القرص ممتلئة

**تنظيف النسخ القديمة:**
```bash
# إضافة لـ crontab - حذف النسخ الأقدم من 30 يوم
0 3 * * * find /Users/asmaahamami/Downloads/Linux -name "backup-*.tar.gz" -mtime +30 -delete
```

---

## 🚀 نصائح متقدمة

### 1️⃣ نسخة احتياطية ذكية

```bash
#!/bin/bash
# نسخة محسنة من backup.sh

# إعدادات
MAX_BACKUPS=7
BACKUP_DIR="/Users/asmaahamami/Downloads/Linux"
SOURCE_DIR="/Users/asmaahamami/Downloads/Linux/important-documents"

# تشغيل النسخ الاحتياطي
/usr/local/bin/backup.sh "$SOURCE_DIR" "$BACKUP_DIR"

# تنظيف النسخ القديمة
find "$BACKUP_DIR" -name "backup-*.tar.gz" -type f | \
sort -r | \
tail -n +$((MAX_BACKUPS + 1)) | \
xargs rm -f

# إرسال إشعار
echo "Backup completed at $(date)" | \
mail -s "Backup Status" user@example.com
```

### 2️⃣ مراقبة صحة النسخ الاحتياطية

```bash
#!/bin/bash
# health_check.sh

BACKUP_DIR="/Users/asmaahamami/Downloads/Linux"
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/backup-*.tar.gz | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup found!" | mail -s "Backup Alert" admin@example.com
    exit 1
fi

# فحص عمر النسخة الاحتياطية
BACKUP_AGE=$(stat -c %Y "$LATEST_BACKUP")
CURRENT_TIME=$(date +%s)
AGE_HOURS=$(( (CURRENT_TIME - BACKUP_AGE) / 3600 ))

if [ $AGE_HOURS -gt 25 ]; then
    echo "⚠️ Backup is $AGE_HOURS hours old!" | mail -s "Backup Warning" admin@example.com
fi

# فحص سلامة الأرشيف
if tar -tzf "$LATEST_BACKUP" > /dev/null 2>&1; then
    echo "✅ Latest backup is healthy"
else
    echo "❌ Latest backup is corrupted!" | mail -s "Backup Error" admin@example.com
fi
```

### 3️⃣ جدولة متقدمة

```bash
# في crontab
# نسخة احتياطية يومية
0 2 * * * /usr/local/bin/backup.sh /path/to/daily/source /path/to/daily/dest

# نسخة احتياطية أسبوعية (أكثر شمولية)
0 1 * * 0 /usr/local/bin/backup.sh /path/to/weekly/source /path/to/weekly/dest

# فحص صحة النسخ
30 8 * * * /usr/local/bin/health_check.sh

# تنظيف السجلات
0 0 1 * * gzip /var/log/backup-*.log
```

### 4️⃣ مراقبة في الوقت الفعلي

```bash
# مراقبة مستمرة لمجلد النسخ الاحتياطية
watch -n 30 'echo "=== Latest Backups ==="; ls -lht backup-*.tar.gz | head -5; echo; echo "=== Disk Usage ==="; df -h .'
```

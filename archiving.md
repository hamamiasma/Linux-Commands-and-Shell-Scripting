#  الأرشفة والضغط في Linux

##  المحتويات

- [مقدمة](#-مقدمة)
- [الفرق بين الأرشفة والضغط](#-الفرق-بين-الأرشفة-والضغط)
- [أداة tar - الأرشفة](#-أداة-tar---الأرشفة)
- [أدوات الضغط - gzip و bzip2](#-أدوات-الضغط---gzip-و-bzip2)
- [أدوات zip و unzip](#-أدوات-zip-و-unzip)
- [مقارنة الأدوات](#-مقارنة-الأدوات)
- [أمثلة عملية شاملة](#-أمثلة-عملية-شاملة)
- [التمارين التطبيقية](#-التمارين-التطبيقية)
- [أفضل الممارسات](#-أفضل-الممارسات)
- [استكشاف الأخطاء](#-استكشاف-الأخطاء)

##  مقدمة

الأرشفة والضغط هما من أهم العمليات في إدارة الملفات في Linux. يُستخدمان لـ:

### فوائد الأرشفة والضغط:
-  **توفير المساحة**: تقليل حجم الملفات بشكل كبير
-  **التنظيم**: جمع ملفات متعددة في حاوية واحدة
-  **نقل سريع**: تحميل ونقل أسرع للملفات
-  **النسخ الاحتياطي**: حفظ البيانات بطريقة منظمة
-  **التوزيع**: مشاركة المشاريع والبرامج

### متى تستخدم الأرشفة والضغط؟
- 📁 إنشاء نسخ احتياطية من المشاريع
- 📧 إرسال عدة ملفات عبر البريد الإلكتروني
- 💽 توفير مساحة القرص الصلب
- 🌐 رفع الملفات على الإنترنت
- 🗄️ أرشفة الملفات القديمة

##  الفرق بين الأرشفة والضغط

### الأرشفة (Archiving)
**الهدف**: جمع عدة ملفات ومجلدات في حاوية واحدة

| المزايا | العيوب |
|---------|--------|
| ✅ يحافظ على بنية المجلدات | ❌ لا يقلل الحجم |
| ✅ يجمع الملفات في مكان واحد | ❌ قد يزيد الحجم قليلاً |
| ✅ يحافظ على الصلاحيات | |
| ✅ سهل الإدارة | |

### الضغط (Compression)
**الهدف**: تقليل حجم الملفات لتوفير المساحة

| المزايا | العيوب |
|---------|--------|
| ✅ يقلل الحجم بشكل كبير | ❌ يحتاج وقت للضغط/فك الضغط |
| ✅ يوفر مساحة القرص | ❌ قد يفقد جودة (في ملفات الوسائط) |
| ✅ نقل أسرع | ❌ يحتاج CPU أكثر |

### الجمع بين الاثنين
**الطريقة الأمثل**: أرشفة أولاً ثم ضغط النتيجة

```
الملفات → الأرشفة (tar) → الضغط (gzip) → ملف مضغوط (.tar.gz)
```

##  أداة tar - الأرشفة

### مقدمة عن tar
**tar** تعني "Tape Archive" وهي الأداة الأساسية للأرشفة في Linux.

### الصيغة العامة

```bash
tar [options] archive_name files_or_directories
```

### الخيارات الأساسية

| الخيار | المعنى | الوظيفة |
|--------|---------|----------|
| `-c` | create | إنشاء أرشيف جديد |
| `-x` | extract | استخراج من أرشيف |
| `-t` | list | عرض محتويات الأرشيف |
| `-f` | file | تحديد اسم ملف الأرشيف |
| `-v` | verbose | عرض تفاصيل العملية |
| `-z` | gzip | ضغط/فك ضغط بـ gzip |
| `-j` | bzip2 | ضغط/فك ضغط بـ bzip2 |

### إنشاء الأرشيف

#### أرشفة بدون ضغط

```bash
# أرشفة مجلد واحد
tar -cvf backup.tar documents/

# أرشفة عدة ملفات ومجلدات
tar -cvf project.tar src/ docs/ README.md

# أرشفة مع استثناء ملفات معينة
tar -cvf backup.tar --exclude='*.tmp' --exclude='*.log' documents/
```

#### أرشفة مع ضغط gzip

```bash
# إنشاء أرشيف مضغوط
tar -czvf backup.tar.gz documents/

# أو باستخدام امتداد .tgz
tar -czvf backup.tgz documents/
```

#### أرشفة مع ضغط bzip2

```bash
# ضغط أقوى لكن أبطأ
tar -cjvf backup.tar.bz2 documents/
```

### عرض محتويات الأرشيف

```bash
# عرض محتويات أرشيف عادي
tar -tvf backup.tar

# عرض محتويات أرشيف مضغوط
tar -tzvf backup.tar.gz

# عرض محتويات bzip2
tar -tjvf backup.tar.bz2

# عرض الملفات فقط (بدون تفاصيل)
tar -tf backup.tar
```

### استخراج الأرشيف

```bash
# استخراج في المجلد الحالي
tar -xvf backup.tar

# استخراج أرشيف مضغوط
tar -xzvf backup.tar.gz

# استخراج في مجلد محدد
tar -xzvf backup.tar.gz -C /path/to/directory

# استخراج ملفات محددة فقط
tar -xzvf backup.tar.gz documents/important.txt

# استخراج مع إظهار التقدم
tar -xzvf backup.tar.gz --checkpoint=100
```

### أمثلة عملية

#### مثال 1: نسخة احتياطية للمشروع

```bash
# إنشاء نسخة احتياطية بالتاريخ
DATE=$(date +%Y%m%d_%H%M%S)
tar -czvf "project_backup_$DATE.tar.gz" \
    --exclude='node_modules' \
    --exclude='.git' \
    project_folder/

# التحقق من النسخة الاحتياطية
tar -tzvf "project_backup_$DATE.tar.gz" | head -10
```

#### مثال 2: أرشفة مجلد النظام

```bash
# أرشفة مجلد /bin (مجلد كبير)
sudo tar -cvf bin.tar /bin

# فحص حجم الأرشيف
ls -lh bin.tar

# عرض عينة من المحتويات
tar -tvf bin.tar | head -20
```

##  أدوات الضغط - gzip و bzip2

### gzip - ضغط سريع

```bash
# ضغط ملف واحد
gzip largefile.txt
# ينتج: largefile.txt.gz

# ضغط مع الاحتفاظ بالأصل
gzip -k largefile.txt

# ضغط عدة ملفات
gzip *.txt

# فك الضغط
gunzip largefile.txt.gz
# أو
gzip -d largefile.txt.gz
```

### bzip2 - ضغط قوي

```bash
# ضغط بـ bzip2 (أقوى لكن أبطأ)
bzip2 largefile.txt
# ينتج: largefile.txt.bz2

# فك ضغط bzip2
bunzip2 largefile.txt.bz2
# أو
bzip2 -d largefile.txt.bz2
```

### مقارنة أداء الضغط

```bash
# إنشاء ملف تجريبي بحجم 100 ميغابايت
dd if=/dev/zero of=testfile bs=1M count=100

# ضغط بـ gzip
time gzip -k testfile
ls -lh testfile.gz

# ضغط بـ bzip2
time bzip2 -k testfile
ls -lh testfile.bz2

# مقارنة النتائج
echo "الملف الأصلي: $(ls -lh testfile | awk '{print $5}')"
echo "gzip: $(ls -lh testfile.gz | awk '{print $5}')"
echo "bzip2: $(ls -lh testfile.bz2 | awk '{print $5}')"
```

##  أدوات zip و unzip

### مقدمة عن ZIP
ZIP هو تنسيق شائع متوافق مع جميع أنظمة التشغيل (Windows, Mac, Linux).

### إنشاء أرشيف ZIP

```bash
# ضغط مجلد بالكامل
zip -r archive.zip folder/

# ضغط ملفات محددة
zip documents.zip *.pdf *.doc

# ضغط مع استثناء ملفات
zip -r project.zip project/ -x "*.log" "*.tmp"

# ضغط مع كلمة مرور
zip -e secure.zip sensitive_file.txt

# ضغط مع مستوى ضغط محدد (0-9)
zip -9 -r max_compression.zip folder/  # أقصى ضغط
zip -1 -r fast_compression.zip folder/  # ضغط سريع
```

### عرض محتويات ZIP

```bash
# عرض محتويات الأرشيف
unzip -l archive.zip

# عرض معلومات تفصيلية
unzip -v archive.zip

# اختبار سلامة الأرشيف
unzip -t archive.zip
```

### فك ضغط ZIP

```bash
# فك الضغط في المجلد الحالي
unzip archive.zip

# فك الضغط في مجلد محدد
unzip archive.zip -d /path/to/directory

# فك الضغط مع الكتابة فوق الملفات الموجودة
unzip -o archive.zip

# فك ضغط ملفات محددة فقط
unzip archive.zip "*.txt"

# فك الضغط بصمت (بدون رسائل)
unzip -q archive.zip
```

### أمثلة عملية لـ ZIP

#### مثال 1: أرشفة ملفات الإعدادات

```bash
# جمع ملفات .conf من /etc
sudo zip config_backup.zip /etc/*.conf

# فحص الأرشيف
unzip -l config_backup.zip

# فك الضغط مع عرض التقدم
unzip -v config_backup.zip
```

#### مثال 2: ضغط مجلد /bin

```bash
# ضغط مجلد /bin بشكل تكراري
sudo zip -ry bin.zip /bin

# فحص حجم الملف المضغوط
ls -lh bin.zip

# فك الضغط مع تأكيد الكتابة فوق الملفات
unzip -o bin.zip
```

## ⚖️ مقارنة الأدوات

### جدول مقارنة شامل

| المعيار | tar | tar.gz | tar.bz2 | zip |
|---------|-----|--------|---------|-----|
| **نسبة الضغط** | 0% | 60-70% | 70-80% | 60-70% |
| **السرعة** | سريع جداً | سريع | بطيء | متوسط |
| **التوافق** | Linux/Unix | Linux/Unix | Linux/Unix | عالمي |
| **حفظ الصلاحيات** | ✅ | ✅ | ✅ | ❌ |
| **الاستخدام الشائع** | أرشفة | نسخ احتياطية | أرشفة طويلة المدى | تبادل الملفات |

### متى تستخدم كل أداة؟

#### استخدم tar:
- ✅ أرشفة سريعة بدون ضغط
- ✅ الحفاظ على صلاحيات Linux
- ✅ أرشفة مؤقتة

#### استخدم tar.gz:
- ✅ نسخ احتياطية يومية
- ✅ توازن بين الحجم والسرعة
- ✅ الاستخدام الأكثر شيوعاً

#### استخدم tar.bz2:
- ✅ أرشفة طويلة المدى
- ✅ عندما المساحة مهمة جداً
- ✅ ملفات نادراً ما تُفك

#### استخدم zip:
- ✅ التوافق مع Windows/Mac
- ✅ إرسال ملفات للآخرين
- ✅ ملفات صغيرة ومتوسطة

##  أمثلة عملية شاملة

### مثال 1: نسخة احتياطية كاملة للنظام

```bash
#!/bin/bash
# نص برمجي للنسخ الاحتياطي

BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)

# إنشاء مجلد النسخ الاحتياطية
sudo mkdir -p $BACKUP_DIR

# نسخة احتياطية للملفات الشخصية
tar -czvf "$BACKUP_DIR/home_$DATE.tar.gz" \
    --exclude='Downloads' \
    --exclude='.cache' \
    /home/$(whoami)/

# نسخة احتياطية لإعدادات النظام
sudo tar -czvf "$BACKUP_DIR/etc_$DATE.tar.gz" /etc/

# عرض أحجام النسخ الاحتياطية
ls -lh $BACKUP_DIR/*$DATE*
```

### مثال 2: أرشفة مشروع تطوير

```bash
#!/bin/bash
PROJECT_NAME="my_web_app"
VERSION="v1.0"

# إنشاء أرشيف للتوزيع
tar -czvf "${PROJECT_NAME}_${VERSION}.tar.gz" \
    --exclude='node_modules' \
    --exclude='venv' \
    --exclude='__pycache__' \
    --exclude='.git' \
    --exclude='*.log' \
    $PROJECT_NAME/

# إنشاء نسخة ZIP للتوافق
zip -r "${PROJECT_NAME}_${VERSION}.zip" $PROJECT_NAME/ \
    -x "*/node_modules/*" "*/venv/*" "*/__pycache__/*" "*/.git/*" "*.log"

# مقارنة الأحجام
echo "=== مقارنة الأحجام ==="
ls -lh ${PROJECT_NAME}_${VERSION}.*
```

### مثال 3: أرشفة قاعدة البيانات

```bash
#!/bin/bash
DB_NAME="production_db"
BACKUP_PATH="/var/backups/db"
DATE=$(date +%Y%m%d_%H%M%S)

# إنشاء dump لقاعدة البيانات
# -u root: username Zugriff auf die MySQL-Datenbank. -p: Passwort 
mysqldump -u root -p $DB_NAME > "$BACKUP_PATH/${DB_NAME}_$DATE.sql"

# ضغط الـ dump
gzip "$BACKUP_PATH/${DB_NAME}_$DATE.sql"

# إنشاء أرشيف شهري (الاحتفاظ بـ 12 شهر)
# أرشفة شهرية في اليوم الأول من كل شهر
if [ $(date +%d) -eq 01 ]; then    # prüft, ob heute der erste Tag des Monats ist.
    MONTH=$(date +%Y%m)
    tar -czvf "$BACKUP_PATH/monthly_${DB_NAME}_$MONTH.tar.gz" \
        $BACKUP_PATH/${DB_NAME}_$(date +%Y%m)*.sql.gz
fi

# تنظيف النسخ القديمة (أكثر من 30 يوم)
find $BACKUP_PATH -name "${DB_NAME}_*.sql.gz" -mtime +30 -delete
```
| Teil         | Bedeutung                                                                |
| ------------ | ------------------------------------------------------------------------ |
| `date +%d`   | Gibt den **aktuellen Tag des Monats** zurück, z. B. `01`, `15`, `30`     |
| `$(...)`     | Führt den Befehl `date +%d` aus und gibt den Wert zurück                 |
| `-eq 01`     | Vergleicht, ob das Ergebnis **gleich `01`** ist (der erste Tag im Monat) |
| `if [ ... ]` | Klassische Bash-Syntax für eine Bedingung                                |

---

##  التمارين التطبيقية

### تمرين 1: أساسيات الأرشفة

```bash
# 1. إنشاء مجلد تجريبي مع ملفات
mkdir test_archive
cd test_archive
echo "ملف نصي 1" > file1.txt
echo "ملف نصي 2" > file2.txt
mkdir subfolder
echo "ملف فرعي" > subfolder/file3.txt

# 2. إنشاء أرشيف tar
tar -cvf archive.tar .

# 3. إنشاء أرشيف مضغوط
tar -czvf archive.tar.gz .

# 4. مقارنة الأحجام
ls -lh archive.*

# 5. عرض محتويات الأرشيف
tar -tvf archive.tar
tar -tzvf archive.tar.gz
```

### تمرين 2: مقارنة طرق الضغط

```bash
# 1. إنشاء ملف كبير للاختبار
dd if=/dev/urandom of=testfile bs=1M count=10

# 2. قياس حجم الملف الأصلي
ORIGINAL_SIZE=$(ls -l testfile | awk '{print $5}')
echo "الحجم الأصلي: $ORIGINAL_SIZE بايت"

# 3. اختبار gzip
time gzip -k testfile
GZIP_SIZE=$(ls -l testfile.gz | awk '{print $5}')
echo "حجم gzip: $GZIP_SIZE بايت"

# 4. اختبار bzip2
time bzip2 -k testfile
BZIP2_SIZE=$(ls -l testfile.bz2 | awk '{print $5}')
echo "حجم bzip2: $BZIP2_SIZE بايت"

# 5. حساب نسب الضغط
echo "نسبة ضغط gzip: $((100 - GZIP_SIZE * 100 / ORIGINAL_SIZE))%"
echo "نسبة ضغط bzip2: $((100 - BZIP2_SIZE * 100 / ORIGINAL_SIZE))%"
```

### تمرين 3: إدارة النسخ الاحتياطية

```bash
#!/bin/bash
# نص لإدارة النسخ الاحتياطية التلقائية

BACKUP_SOURCE="$HOME/Documents"
BACKUP_DEST="$HOME/Backups"
DATE=$(date +%Y%m%d)

# 1. إنشاء مجلد النسخ الاحتياطية
# ضمن وجود مجلد Backups داخل مجلد المستخدم.
mkdir -p "$BACKUP_DEST"

# 2. إنشاء نسخة احتياطية يومية
tar -czvf "$BACKUP_DEST/documents_$DATE.tar.gz" \
    --exclude='*.tmp' \
    --exclude='*.log' \
    "$BACKUP_SOURCE"

# 3. عدّ عدد النسخ الاحتياطية
BACKUP_COUNT=$(ls -1 "$BACKUP_DEST"/documents_*.tar.gz | wc -l)
echo "عدد النسخ الاحتياطية: $BACKUP_COUNT"

# 4. حذف النسخ الأقدم من أسبوع
find "$BACKUP_DEST" -name "documents_*.tar.gz" -mtime +7 -delete

echo "تم إنشاء النسخة الاحتياطية: documents_$DATE.tar.gz"
```

##  أفضل الممارسات

### تسمية الملفات

```bash
# تسمية جيدة مع التاريخ والوقت
DATE=$(date +%Y%m%d_%H%M%S)
tar -czvf "project_backup_$DATE.tar.gz" project/

# تسمية بالإصدار
tar -czvf "myapp_v2.1.0.tar.gz" myapp/

# تسمية بالمحتوى
tar -czvf "config_files_backup.tar.gz" /etc/*.conf
```

### استثناء الملفات غير المرغوبة

```bash
# إنشاء ملف .tarignore
cat > .tarignore << EOF
*.log
*.tmp
.git/
node_modules/
__pycache__/
*.pyc
.DS_Store
Thumbs.db
EOF

# استخدام الملف في الأرشفة
tar -czvf backup.tar.gz --exclude-from=.tarignore project/
```

### التحقق من سلامة الأرشيف

```bash
# إنشاء checksum للأرشيف
tar -czvf backup.tar.gz project/
sha256sum backup.tar.gz > backup.tar.gz.sha256

# التحقق من السلامة لاحقاً
sha256sum -c backup.tar.gz.sha256
```

### الضغط التفاعلي

```bash
# عرض التقدم أثناء الضغط
tar -czvf backup.tar.gz --checkpoint=1000 --checkpoint-action=dot project/

# استخدام pv لعرض شريط التقدم
tar -czf - project/ | pv -s $(du -sb project/ | awk '{print $1}') > backup.tar.gz
```

##  استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### 1. مساحة القرص ممتلئة

```bash
# فحص المساحة المتاحة
df -h

# ضغط في مجلد آخر
tar -czvf /tmp/backup.tar.gz large_folder/

# استخدام الضغط الأقوى
tar -cjvf backup.tar.bz2 large_folder/
```

#### 2. ملفات مكسورة في الأرشيف

```bash
# اختبار سلامة الأرشيف
tar -tzvf backup.tar.gz > /dev/null
echo "رمز الخروج: $?"  # 0 = سليم، غير ذلك = مشكلة

# اختبار ZIP
unzip -t archive.zip

# محاولة الإصلاح
zip -FF broken_archive.zip --out fixed_archive.zip
```

#### 3. صلاحيات غير صحيحة

```bash
# الأرشفة مع الحفاظ على الصلاحيات
tar -czvpf backup.tar.gz project/  # p = preserve permissions

# استخراج مع الحفاظ على الصلاحيات
tar -xzvpf backup.tar.gz
```

#### 4. مسارات مطلقة في الأرشيف

```bash
# تجنب المسارات المطلقة
cd /path/to/parent
tar -czvf backup.tar.gz folder_name/

# إزالة المسارات المطلقة من أرشيف موجود
tar -czvf new_backup.tar.gz --transform 's|^/||' /absolute/path/
```

### نص تشخيصي شامل

```bash
#!/bin/bash
# نص لتشخيص مشاكل الأرشفة
# يأخذ اسم الأرشيف من السطر الأول من الوسائط ($1).
# ex: ./myscript.sh  mybackup.tar.gz
ARCHIVE_FILE="$1"

# إذا لم يُرسل اسم الملف، يتم عرض رسالة الاستخدام والخروج.
if [ -z "$ARCHIVE_FILE" ]; then
    echo "الاستخدام: $0 <archive_file>"
    exit 1
fi

echo "=== تشخيص الأرشيف: $ARCHIVE_FILE ==="

# فحص وجود الملف
if [ ! -f "$ARCHIVE_FILE" ]; then
    echo "❌ الملف غير موجود"
    exit 1
fi

# فحص حجم الملف
# يُظهر الحجم بطريقة مفهومة (مثلاً: 12M, 832K...).
SIZE=$(ls -lh "$ARCHIVE_FILE" | awk '{print $5}')
echo " حجم الملف: $SIZE"

# تحديد نوع الأرشيف
if [[ "$ARCHIVE_FILE" == *.tar.gz ]] || [[ "$ARCHIVE_FILE" == *.tgz ]]; then
    echo "✅ نوع الأرشيف: tar.gz"
    tar -tzvf "$ARCHIVE_FILE" > /dev/null && echo "✅ الأرشيف سليم" || echo "❌ الأرشيف معطوب"
elif [[ "$ARCHIVE_FILE" == *.tar.bz2 ]]; then
    echo "✅ نوع الأرشيف: tar.bz2"
    tar -tjvf "$ARCHIVE_FILE" > /dev/null && echo "✅ الأرشيف سليم" || echo "❌ الأرشيف معطوب"
elif [[ "$ARCHIVE_FILE" == *.zip ]]; then
    echo "✅ نوع الأرشيف: zip"
    unzip -t "$ARCHIVE_FILE" > /dev/null && echo "✅ الأرشيف سليم" || echo "❌ الأرشيف معطوب"
elif [[ "$ARCHIVE_FILE" == *.tar ]]; then
    echo "✅ نوع الأرشيف: tar"
    tar -tvf "$ARCHIVE_FILE" > /dev/null && echo "✅ الأرشيف سليم" || echo "❌ الأرشيف معطوب"
else
    echo "❓ نوع الأرشيف غير معروف"
fi
```
| التعبير                               | المعنى                                                                       |
| ------------------------------------- | ---------------------------------------------------------------------------- |
| `if [ -z "$ARCHIVE_FILE" ]`           | يتحقق مما إذا كان المتغير `ARCHIVE_FILE` **فارغًا** (`-z` = "zero length")   |
| `$ARCHIVE_FILE`                       | يحتوي على الوسيط الأول (`$1`) الذي يُمرر للسكربت                             |
| `then`                                | بداية تنفيذ الأمر إذا كانت الشرطية صحيحة                                     |
| `echo "الاستخدام: $0 <archive_file>"` | طباعة رسالة للمستخدم توضح طريقة الاستخدام. يستخدم `$0` لعرض اسم السكربت نفسه |

--- 

##  ملخص الأوامر السريع

### tar - الأوامر الأساسية

| العملية | الأمر |
|---------|-------|
| **إنشاء أرشيف** | `tar -cvf archive.tar files/` |
| **إنشاء مضغوط** | `tar -czvf archive.tar.gz files/` |
| **عرض المحتويات** | `tar -tvf archive.tar` |
| **استخراج** | `tar -xvf archive.tar` |
| **استخراج مضغوط** | `tar -xzvf archive.tar.gz` |

### zip/unzip - الأوامر الأساسية

| العملية | الأمر |
|---------|-------|
| **إنشاء أرشيف** | `zip -r archive.zip folder/` |
| **عرض المحتويات** | `unzip -l archive.zip` |
| **استخراج** | `unzip archive.zip` |
| **اختبار السلامة** | `unzip -t archive.zip` |

## 🔗 الخطوات التالية

بعد إتقان الأرشفة والضغط:

1. **تعلم أدوات متقدمة** (7zip, rar)
2. **أتمتة النسخ الاحتياطية** (cron jobs)
3. **ضغط قواعد البيانات** (database dumps)
4. **إدارة المساحة** (disk cleanup strategies)


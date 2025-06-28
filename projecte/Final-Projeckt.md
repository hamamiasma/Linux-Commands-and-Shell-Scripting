# 🎓 المشروع النهائي: نظام النسخ الاحتياطي التلقائي

## 📋 المحتويات

- [مقدمة المشروع](#-مقدمة-المشروع)
- [السيناريو والمتطلبات](#-السيناريو-والمتطلبات)
- [هيكل المشروع](#-هيكل-المشروع)
- [شرح الكود خطوة بخطوة](#-شرح-الكود-خطوة-بخطوة)
- [الحلول الكاملة](#-الحلول-الكاملة)
- [الاختبار والتنفيذ](#-الاختبار-والتنفيذ)
- [التحسينات المتقدمة](#-التحسينات-المتقدمة)

## 🎯 مقدمة المشروع

### الهدف التعليمي
هذا المشروع النهائي يهدف إلى:
- **تطبيق مهارات Shell Scripting المتقدمة** في سيناريو واقعي
- **دمج جميع المفاهيم** التي تعلمناها في الدورة
- **إنشاء حل تلقائي** لمشكلة حقيقية في بيئة العمل
- **تطوير مهارات حل المشاكل** البرمجية

### المهارات المطلوبة
- ✅ التعامل مع Command Line Arguments
- ✅ إدارة المتغيرات وCommand Substitution
- ✅ استخدام شروط if وحلقات for
- ✅ التعامل مع المصفوفات (Arrays)
- ✅ أوامر النظام (find, tar, date)
- ✅ إدارة المسارات والمجلدات

## 🏢 السيناريو والمتطلبات

### السيناريو
```
🏢 شركة ABC International Inc.
المشكلة: عملية النسخ الاحتياطي اليدوية للملفات المشفرة
- ❌ تستغرق وقتاً طويلاً
- ❌ عرضة للأخطاء البشرية  
- ❌ تقلل من مستوى الأمان
- ❌ تتطلب عمالة كثيرة

المهمة: إنشاء سكربت backup.sh يعمل تلقائياً كل يوم
```

### المتطلبات الوظيفية
- 📅 **تشغيل يومي تلقائي**
- 🔍 **البحث عن الملفات المحدثة في آخر 24 ساعة**
- 🔒 **نسخ احتياطي للملفات المشفرة فقط**
- 📦 **ضغط وأرشفة الملفات**
- 📂 **حفظ في مجلد الوجهة المحدد**

### المدخلات
```bash
./backup.sh [target_directory] [destination_directory]
```

## 🏗️ هيكل المشروع

### الكود الأساسي المقدم
```bash
#!/bin/bash

# فحص عدد المعاملات
if [[ $# != 2 ]]; then
    echo "backup.sh target_directory_name destination_directory_name"
    exit
fi

# فحص صحة المسارات
if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
    echo "Invalid directory path provided"
    exit
fi

# [المهام 1-13 تكمل هنا...]
```

## 📝 شرح الكود خطوة بخطوة

### التحضيرات الأولية

#### فحص المعاملات
```bash
if [[ $# != 2 ]]; then
    echo "backup.sh target_directory_name destination_directory_name"
    exit
fi
```
**الشرح:**
- `$#`: عدد المعاملات المرسلة للسكربت
- يجب أن يكون هناك معاملان بالضبط
- إذا لم يكن العدد صحيحاً، يتم إنهاء السكربت

#### فحص صحة المسارات
```bash
if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
    echo "Invalid directory path provided"
    exit
fi
```
**الشرح:**
- `-d`: فحص وجود المجلد
- `!`: نفي (NOT)
- `||`: أو (OR)
- يتأكد أن كلا المجلدين موجودان

## 🎯 المهام خطوة بخطوة

### Task 1: تعيين المتغيرات الأساسية

**المطلوب:**
```bash
targetDirectory=$1
destinationDirectory=$2
```

**الشرح:**
- `$1`: المعامل الأول (مجلد المصدر)
- `$2`: المعامل الثاني (مجلد الوجهة)
- تحسين قابلية قراءة الكود

### Task 2: عرض القيم

**المطلوب:**
```bash
echo "Target directory: $targetDirectory"
echo "Destination directory: $destinationDirectory"
```

**الشرح:**
- عرض المسارات للتأكد من صحتها
- مفيد للتشخيص (debugging)

### Task 3: الطابع الزمني الحالي

**المطلوب:**
```bash
currentTS=$(date +%s)
```

**الشرح:**
- `date +%s`: الوقت الحالي بالثواني منذ 1970
- `$()`: Command substitution
- مفيد لإنشاء أسماء ملفات فريدة

### Task 4: اسم ملف النسخة الاحتياطية

**المطلوب:**
```bash
backupFileName="backup-[$currentTS].tar.gz"
```

**الشرح:**
- صيغة اسم الملف: `backup-[timestamp].tar.gz`
- مثال: `backup-[1634571345].tar.gz`
- `.tar.gz`: أرشيف مضغوط

### Task 5: المسار المطلق الحالي

**المطلوب:**
```bash
origAbsPath=$(pwd)
```

**الشرح:**
- `pwd`: Print Working Directory
- حفظ المسار الحالي للعودة إليه لاحقاً

### Task 6: المسار المطلق للوجهة

**المطلوب:**
```bash
cd "$destinationDirectory" || exit
destAbsPath=$(pwd)
```

**الشرح:**
- الانتقال لمجلد الوجهة
- `|| exit`: إنهاء إذا فشل الانتقال
- حفظ المسار المطلق

### Task 7: العودة للمجلد الأصلي

**المطلوب:**
```bash
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit
```

**الشرح:**
- العودة للمجلد الأصلي أولاً
- ثم الانتقال لمجلد الهدف
- ضمان سلامة التنقل

### Task 8: حساب طابع الأمس الزمني

**المطلوب:**
```bash
yesterdayTS=$((currentTS - 24 * 60 * 60))
date -r $yesterdayTS
```

**الشرح:**
- `24 * 60 * 60`: عدد ثواني اليوم (86400)
- طرح من الوقت الحالي للحصول على الأمس
- مفيد للبحث عن الملفات المحدثة

### Task 9: البحث عن الملفات

**المطلوب:**
```bash
for file in $(find . -type f -name "*.txt" -newer "/tmp/timestamp_file")
```
| جزء الكود                      | الشرح                                                           |
| ------------------------------ | --------------------------------------------------------------- |
| `find .`                       | البحث يبدأ من المجلد الحالي `.`                                 |
| `-type f`                      | يبحث فقط عن ملفات عادية (وليس مجلدات)                           |
| `-name "*.txt"`                | يبحث عن الملفات التي تنتهي بـ `.txt`                            |
| `-newer "/tmp/timestamp_file"` | فقط الملفات التي تم **تعديلها بعد** الملف `/tmp/timestamp_file` |
| `$(...)`                       | ينفّذ الأمر `find` ويضع النتائج مكانها                          |
| `for file in ...`              | يمرّ على كل ملف تم إيجاده واحدًا تلو الآخر                      |


**البديل الأفضل:**
```bash
declare -a toBackup
for file in *
```

**الشرح:**
- `declare -a`: إعلان مصفوفة
- البحث في جميع الملفات
- يمكن تخصيص نمط البحث

### Task 10: فحص تاريخ التعديل

**المطلوب:**
```bash
if [ stat -f %m  "$file") -gt $yesterdayTS ]; then
```

**الشرح:**
- `stat -c %Y`: تاريخ آخر تعديل بالثواني
- `-gt`: أكبر من (Greater Than)
- مقارنة مع طابع الأمس الزمني

### Task 11: إضافة للمصفوفة

**المطلوب:**
```bash
toBackup+=("$file")
```

**الشرح:**
- `+=`: إضافة عنصر للمصفوفة
- الملفات المحدثة تُضاف للقائمة

### Task 12: إنشاء الأرشيف

**المطلوب:**
```bash
tar -czf "$backupFileName" "${toBackup[@]}"
```

**الشرح:**
- `tar`: أداة الأرشفة
- `-c`: إنشاء أرشيف
- `-z`: ضغط بـ gzip
- `-f`: اسم الملف
- `"${toBackup[@]}"`: جميع عناصر المصفوفة

### Task 13: نقل الأرشيف

**المطلوب:**
```bash
mv "$backupFileName" "$destAbsPath"
```

**الشرح:**
- نقل الأرشيف لمجلد الوجهة
- استخدام المسار المطلق المحفوظ

## ✅ الحلول الكاملة

### الحل الأساسي

```bash
#!/bin/bash

# فحص عدد المعاملات
if [[ $# != 2 ]]; then
    echo "backup.sh target_directory_name destination_directory_name"
    exit
fi

# فحص صحة المسارات
if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
    echo "Invalid directory path provided"
    exit
fi

# [TASK 1] - تعيين المتغيرات
targetDirectory=$1
destinationDirectory=$2

# [TASK 2] - عرض القيم
echo "Target directory: $targetDirectory"
echo "Destination directory: $destinationDirectory"

# [TASK 3] - الطابع الزمني الحالي
currentTS=$(date +%s)

# [TASK 4] - اسم ملف النسخة الاحتياطية
backupFileName="backup-[$currentTS].tar.gz"

# [TASK 5] - المسار المطلق الحالي
origAbsPath=$(pwd)

# [TASK 6] - المسار المطلق للوجهة
cd "$destinationDirectory" || exit
destAbsPath=$(pwd)

# [TASK 7] - العودة والانتقال للهدف
cd "$origAbsPath" || exit
cd "$targetDirectory" || exit

# [TASK 8] - طابع الأمس الزمني
yesterdayTS=$((currentTS - 24 * 60 * 60))

# إعداد مصفوفة الملفات
declare -a toBackup

# [TASK 9-11] - البحث وإضافة الملفات
for file in *; do
    # [TASK 10] - فحص تاريخ التعديل
    if [[ -f "$file" ]] && [[ $(stat -c %Y "$file") -gt $yesterdayTS ]]; then
        # [TASK 11] - إضافة للمصفوفة
        toBackup+=("$file")
        echo "Adding $file to backup"
    fi
done

# [TASK 12] - إنشاء الأرشيف
if [ ${#toBackup[@]} -gt 0 ]; then
    echo "Creating backup with ${#toBackup[@]} files..."
    tar -czf "$backupFileName" "${toBackup[@]}"
    
    # [TASK 13] - نقل للوجهة
    mv "$backupFileName" "$destAbsPath"
    echo "✅ Backup completed: $destAbsPath/$backupFileName"
else
    echo "❌ No files found for backup"
fi

echo "🎉 Backup script completed successfully!"
```

### الحل المتقدم مع ميزات إضافية

```bash
#!/bin/bash

# إعدادات متقدمة
LOG_FILE="/var/log/backup.log"
EMAIL_ALERT="admin@example.com"
ENCRYPTION_PATTERN="*.gpg"  # للملفات المشفرة

# دالة للكتابة في السجل
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

# دالة لإرسال تحذيرات
send_alert() {
    local message="$1"
    echo "$message" | mail -s "Backup Alert" "$EMAIL_ALERT" 2>/dev/null
    log_message "ALERT: $message"
}

# بداية السكربت
log_message "Starting backup script"

# فحص المعاملات
if [[ $# != 2 ]]; then
    error_msg="Usage: backup.sh target_directory_name destination_directory_name"
    echo "$error_msg"
    log_message "ERROR: $error_msg"
    exit 1
fi

# فحص صحة المسارات
if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
    error_msg="Invalid directory path provided"
    echo "$error_msg"
    log_message "ERROR: $error_msg"
    exit 1
fi

# تعيين المتغيرات
targetDirectory=$1
destinationDirectory=$2

log_message "Target: $targetDirectory, Destination: $destinationDirectory"

# الطابع الزمني
currentTS=$(date +%s)
currentDate=$(date '+%Y-%m-%d_%H-%M-%S')

# اسم الملف مع تاريخ أكثر وضوحاً
backupFileName="backup-${currentDate}-[${currentTS}].tar.gz"

# المسارات المطلقة
origAbsPath=$(pwd)

cd "$destinationDirectory" || {
    send_alert "Failed to access destination directory: $destinationDirectory"
    exit 1
}
destAbsPath=$(pwd)

cd "$origAbsPath" || exit
cd "$targetDirectory" || {
    send_alert "Failed to access target directory: $targetDirectory"
    exit 1
}

# حساب طابع الأمس
yesterdayTS=$((currentTS - 24 * 60 * 60))
log_message "Looking for files modified after $(date -d @$yesterdayTS)"

# البحث عن الملفات المشفرة المحدثة
declare -a toBackup
file_count=0
total_size=0

for file in $ENCRYPTION_PATTERN; do
    if [[ -f "$file" ]]; then
        file_mod_time=$(stat -c %Y "$file")
        if [[ $file_mod_time -gt $yesterdayTS ]]; then
            toBackup+=("$file")
            file_size=$(stat -c %s "$file")
            total_size=$((total_size + file_size))
            ((file_count++))
            log_message "Added to backup: $file ($(du -h "$file" | cut -f1))"
        fi
    fi
done

# إنشاء النسخة الاحتياطية
if [ ${#toBackup[@]} -gt 0 ]; then
    log_message "Creating backup with $file_count files ($(du -h "${toBackup[@]}" | tail -1 | cut -f1) total)"
    
    # إنشاء الأرشيف مع شريط التقدم
    tar -czf "$backupFileName" "${toBackup[@]}" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        # نقل للوجهة
        mv "$backupFileName" "$destAbsPath/" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            backup_size=$(du -h "$destAbsPath/$backupFileName" | cut -f1)
            success_msg="✅ Backup completed successfully: $destAbsPath/$backupFileName ($backup_size)"
            echo "$success_msg"
            log_message "$success_msg"
            
            # تنظيف النسخ القديمة (أكثر من 30 يوم)
            find "$destAbsPath" -name "backup-*.tar.gz" -mtime +30 -delete 2>/dev/null
            log_message "Cleaned up old backups"
        else
            send_alert "Failed to move backup file to destination"
            exit 1
        fi
    else
        send_alert "Failed to create backup archive"
        exit 1
    fi
else
    warning_msg="❌ No encrypted files found for backup in the last 24 hours"
    echo "$warning_msg"
    log_message "$warning_msg"
fi

log_message "Backup script completed successfully"
echo "🎉 Backup operation finished!"
```

## 🧪 الاختبار والتنفيذ

### إعداد بيئة الاختبار

```bash
# إنشاء مجلدات الاختبار
mkdir -p ~/test_backup/{source,destination}

# إنشاء ملفات تجريبية
cd ~/test_backup/source
echo "Test file 1" > file1.txt
echo "Test file 2" > file2.txt
echo "Old file" > old_file.txt

# جعل ملف قديم
touch -t 202301010000 old_file.txt

# إضافة صلاحية تنفيذ للسكربت
chmod +x backup.sh
```

### تشغيل الاختبار

```bash
# تشغيل السكربت
./backup.sh ~/test_backup/source ~/test_backup/destination

# فحص النتائج
ls -la ~/test_backup/destination/
```

### اختبار السيناريوهات المختلفة

```bash
# اختبار معاملات خاطئة
./backup.sh  # بدون معاملات
./backup.sh only_one_param  # معامل واحد فقط
./backup.sh /nonexistent /also_nonexistent  # مسارات غير موجودة

# اختبار مع ملفات محدثة
touch ~/test_backup/source/new_file.txt
./backup.sh ~/test_backup/source ~/test_backup/destination
```

## 🚀 التحسينات المتقدمة

### إضافة جدولة Cron

```bash
# إضافة للـ crontab للتشغيل يومياً الساعة 2 صباحاً
0 2 * * * /path/to/backup.sh /data/encrypted /backups/daily >> /var/log/backup_cron.log 2>&1
```

### إضافة إشعارات البريد الإلكتروني

```bash
# في نهاية السكربت
echo "Backup Summary: $file_count files backed up" | \
mail -s "Daily Backup Report" admin@company.com
```

### إضافة تشفير إضافي

```bash
# تشفير الأرشيف
gpg --symmetric --cipher-algo AES256 "$backupFileName"
rm "$backupFileName"  # حذف النسخة غير المشفرة
```

### مراقبة الأداء

```bash
# قياس وقت التنفيذ
start_time=$(date +%s)
# ... عمليات النسخ الاحتياطي ...
end_time=$(date +%s)
execution_time=$((end_time - start_time))
log_message "Backup completed in $execution_time seconds"
```


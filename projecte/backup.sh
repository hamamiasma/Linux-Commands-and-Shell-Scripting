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
    if [[ -f "$file" ]] && [[ $(stat -f %m "$file") -gt $yesterdayTS ]]; then
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
    echo " Backup completed: $destAbsPath/$backupFileName"
else
    echo " No files found for backup"
fi

echo " Backup script completed successfully!"

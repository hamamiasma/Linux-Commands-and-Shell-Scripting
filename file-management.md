# 📁 إدارة الملفات والمجلدات في Linux

##  المحتويات

- [مقدمة](#-مقدمة)
- [أوامر التنقل الأساسية](#-أوامر-التنقل-الأساسية)
- [البحث عن الملفات](#-البحث-عن-الملفات)
- [إنشاء الملفات والمجلدات](#-إنشاء-الملفات-والمجلدات)
- [نسخ الملفات](#-نسخ-الملفات)
- [نقل وإعادة تسمية الملفات](#-نقل-وإعادة-تسمية-الملفات)
- [حذف الملفات والمجلدات](#-حذف-الملفات-والمجلدات)
- [أوامر العرض المتقدمة](#-أوامر-العرض-المتقدمة)
- [التمارين العملية](#-التمارين-العملية)
- [نصائح وحيل](#-نصائح-وحيل)

## مقدمة

إدارة الملفات والمجلدات هي من أهم المهارات في Linux. هذا الدليل يغطي جميع الأوامر الأساسية والمتقدمة للتعامل مع نظام الملفات بكفاءة وأمان.

### الفوائد من إتقان إدارة الملفات:
-  **زيادة الإنتاجية**: العمل بشكل أسرع وأكثر كفاءة
-  **الأمان**: حماية الملفات من الفقدان أو التلف
-  **التنظيم**: ترتيب الملفات بطريقة منطقية
-  **الأتمتة**: إمكانية كتابة نصوص لأتمتة المهام

##  أوامر التنقل الأساسية

### عرض المسار الحالي

```bash
pwd
```
**الوظيفة:** Print Working Directory - يعرض مسار المجلد الحالي

### عرض محتويات المجلد

```bash
# عرض بسيط
ls

# عرض مفصل مع الصلاحيات
ls -l

# عرض جميع الملفات (بما فيها المخفية)
ls -la

# عرض مع أحجام قابلة للقراءة
ls -lh

# ترتيب حسب التاريخ
ls -lt

# ترتيب حسب الحجم
ls -lS
```

### تغيير المجلد

```bash
# الانتقال إلى مجلد محدد
cd /home/project

# العودة إلى المجلد السابق
cd -

# الانتقال إلى المجلد الأم
cd ..

# الانتقال إلى المجلد الرئيسي
cd ~
# أو
cd
```

##  البحث عن الملفات

### الأمر find - البحث الشامل

```bash
# البحث عن ملف بالاسم
find /path -name "filename.txt"

# البحث عن ملفات بامتداد محدد
find /etc -name "*.txt"

# البحث عن ملفات أكبر من حجم معين
find /home -size +100M

# البحث عن ملفات تم تعديلها خلال آخر 7 أيام
find /home -mtime -7

# البحث عن المجلدات فقط
find /path -type d

# البحث عن الملفات فقط
find /path -type f
```

### أمثلة متقدمة للبحث

```bash
# البحث عن ملفات قابلة للتنفيذ
find /usr/bin -perm -111

# البحث عن ملفات فارغة
find /home -empty

# البحث وتنفيذ أمر على النتائج
find /tmp -name "*.log" -exec rm {} \;

# البحث مع تجاهل رسائل الخطأ
find /etc -name "*.conf" 2>/dev/null
```

### الأمر locate - البحث السريع

```bash
# تحديث قاعدة بيانات البحث
sudo updatedb

# البحث السريع عن ملف
locate filename.txt

# البحث مع تجاهل حالة الأحرف
locate -i FILENAME.TXT
```

## 🆕 إنشاء الملفات والمجلدات

### إنشاء الملفات

```bash
# إنشاء ملف فارغ
touch newfile.txt

# إنشاء عدة ملفات
touch file1.txt file2.txt file3.txt

# إنشاء ملف مع محتوى
echo "Hello World" > myfile.txt

# إضافة محتوى لملف موجود
echo "New line" >> myfile.txt
```

### إنشاء المجلدات

```bash
# إنشاء مجلد واحد
mkdir new_folder

# إنشاء مجلدات متعددة
mkdir folder1 folder2 folder3

# إنشاء مجلدات متداخلة
mkdir -p parent/child/grandchild

# إنشاء مجلد مع صلاحيات محددة
mkdir -m 755 secure_folder
```

##  نسخ الملفات

### الأمر cp - النسخ الأساسي

```bash
# نسخ ملف
cp source.txt destination.txt

# نسخ ملف إلى مجلد
cp file.txt /home/user/

# نسخ عدة ملفات إلى مجلد
cp file1.txt file2.txt /destination/folder/

# نسخ مع الاحتفاظ بالصلاحيات والطوابع الزمنية
cp -p source.txt destination.txt
```

### نسخ المجلدات

```bash
# نسخ مجلد بالكامل (بشكل تكراري)
cp -r source_folder/ destination_folder/

# نسخ مع عرض التقدم
cp -rv source_folder/ destination_folder/

# نسخ مع تأكيد الكتابة فوق الملفات الموجودة
cp -i source.txt destination.txt
```

### أمثلة عملية للنسخ

```bash
# نسخ ملف من مجلد النظام
cp /etc/passwd users_backup.txt

# نسخ مع إعادة تسمية
cp /tmp/data.txt ./data_copy.txt

# نسخ جميع ملفات .txt
cp *.txt backup_folder/
```

##  نقل وإعادة تسمية الملفات

### الأمر mv - النقل والتسمية

```bash
# إعادة تسمية ملف
mv oldname.txt newname.txt

# نقل ملف إلى مجلد آخر
mv file.txt /destination/folder/

# نقل وإعادة تسمية في نفس الوقت
mv file.txt /destination/folder/newname.txt

# نقل عدة ملفات
mv file1.txt file2.txt file3.txt /destination/
```

### نقل المجلدات

```bash
# نقل مجلد كامل
mv source_folder/ /new/location/

# إعادة تسمية مجلد
mv old_folder_name/ new_folder_name/
```

### أمثلة عملية للنقل

```bash
# إنشاء ملف ونقله
touch users.txt
mv users.txt user-info.txt

# نقل إلى مجلد مؤقت
mv user-info.txt /tmp/

# التحقق من النقل
ls /tmp/ | grep user-info
```

##  حذف الملفات والمجلدات

### الأمر rm - الحذف الآمن

```bash
# حذف ملف مع التأكيد
rm -i filename.txt

# حذف ملف بدون تأكيد (خطير!)
rm filename.txt

# حذف عدة ملفات
rm file1.txt file2.txt file3.txt

# حذف جميع ملفات .tmp
rm *.tmp
```

### حذف المجلدات

```bash
# حذف مجلد فارغ
rmdir empty_folder/

# حذف مجلد وجميع محتوياته (خطير!)
rm -r folder_name/

# حذف مع التأكيد لكل ملف
rm -ri folder_name/

# فرض الحذف (خطير جداً!)
rm -rf folder_name/
```

### ⚠️ تحذيرات مهمة للحذف

```bash
# لا تنفذ هذه الأوامر أبداً!
rm -rf /          # يحذف النظام بالكامل
rm -rf /*         # يحذف جميع الملفات
rm -rf ~/         # يحذف جميع ملفاتك الشخصية
```

##  أوامر العرض المتقدمة

### الأمر ls مع خيارات متقدمة

```bash
# عرض مع ألوان
ls --color=auto

# عرض مع مؤشرات نوع الملف
ls -F

# عرض في شكل قوائم عمودية
ls -1

# عرض مع أرقام الصفحات
ls -i

# عرض حسب الوقت (الأحدث أولاً)
ls -lt

# عرض حسب الحجم (الأكبر أولاً)  
ls -lS

# عرض عكسي
ls -lr
```

### جدول خيارات ls الشائعة

| الخيار | الوصف |
|--------|--------|
| `-a` | عرض جميع الملفات (بما فيها المخفية) |
| `-l` | عرض مفصل طويل |
| `-h` | أحجام قابلة للقراءة (مع -l) |
| `-t` | ترتيب حسب وقت التعديل |
| `-S` | ترتيب حسب الحجم |
| `-r` | عكس الترتيب |
| `-d` | عرض المجلدات فقط (لا محتوياتها) |
| `-F` | إضافة مؤشرات نوع الملف |

### عرض محتوى الملفات

```bash
# عرض محتوى ملف صغير
cat filename.txt

# عرض مع أرقام الأسطر
cat -n filename.txt

# عرض ملف كبير (صفحة بصفحة)
less filename.txt
# أو
more filename.txt

# عرض أول 10 أسطر
head filename.txt

# عرض آخر 10 أسطر
tail filename.txt

# متابعة إضافات الملف (مفيد للسجلات)
tail -f logfile.txt
```

##  التمارين العملية

### تمرين 1: إنشاء هيكل مجلدات منظم

```bash
# إنشاء مجلد مشروع رئيسي
mkdir ~/my_project

# إنشاء مجلدات فرعية
mkdir -p ~/my_project/{docs,src,tests,config}

# التحقق من الهيكل
tree ~/my_project
# أو إذا لم يكن tree مثبتاً
ls -la ~/my_project
```

### تمرين 2: إدارة ملفات التكوين

```bash
cd ~/my_project/config

# إنشاء ملفات تكوين
touch app.conf database.conf server.conf

# إضافة محتوى لملف التكوين
echo "# App Configuration" > app.conf
echo "debug=true" >> app.conf
echo "port=8080" >> app.conf

# عرض المحتوى
cat app.conf

# نسخ التكوين لإنشاء نسخة احتياطية
cp app.conf app.conf.backup
```

### تمرين 3: البحث وتنظيف الملفات

```bash
# إنشاء ملفات تجريبية
cd ~/my_project
touch temp1.tmp temp2.tmp old_file.txt

# البحث عن ملفات .tmp
find . -name "*.tmp"

# حذف ملفات .tmp مع التأكيد
rm -i *.tmp

# البحث عن ملفات أكبر من 1KB
find . -size +1k

# عرض أحجام الملفات
ls -lh
```

### تمرين 4: نسخ احتياطي للمشروع

```bash
# إنشاء مجلد النسخ الاحتياطية
mkdir ~/backups

# نسخ المشروع بالكامل
cp -r ~/my_project ~/backups/my_project_$(date +%Y%m%d)

# التحقق من النسخة الاحتياطية
ls -la ~/backups/
```

## 💡 نصائح وحيل

### اختصارات لوحة المفاتيح المفيدة

| الاختصار | الوظيفة |
|----------|----------|
| `Tab` | إكمال أسماء الملفات والمجلدات |
| `Tab Tab` | عرض جميع الخيارات المتاحة |
| `↑` | الأمر السابق |
| `Ctrl+C` | إيقاف الأمر الحالي |
| `Ctrl+L` | مسح الشاشة |
| `Ctrl+A` | الانتقال لبداية السطر |
| `Ctrl+E` | الانتقال لنهاية السطر |

### استخدام الرموز النمطية (Wildcards)

```bash
# جميع الملفات
ls *

# الملفات المنتهية بـ .txt
ls *.txt

# الملفات المبتدئة بـ data
ls data*

# حرف واحد مجهول
ls file?.txt

# نطاق من الأحرف
ls file[1-5].txt

# استثناء ملفات معينة
ls !(*.tmp)
```

### أوامر مركبة مفيدة

```bash
# إنشاء مجلد والانتقال إليه
mkdir new_folder && cd new_folder

# نسخ وإعادة تسمية في أمر واحد  
cp file.txt{,.backup}

# نقل جميع ملفات .txt إلى مجلد
mkdir txt_files && mv *.txt txt_files/

# عرض حجم مجلد
du -sh folder_name/

# عرض المساحة المستخدمة في النظام
df -h
```

### أوامر التاريخ للملفات

```bash
# تغيير طابع زمني لملف
touch filename.txt

# تعيين تاريخ محدد
touch -t 202312251200 filename.txt

# نسخ الطابع الزمني من ملف آخر
touch -r source.txt destination.txt

# عرض الطابع الزمني
stat filename.txt
```

##  أفضل الممارسات

### النسخ الاحتياطي

```bash
# نسخ احتياطي يومي
#!/bin/bash
DATE=$(date +%Y%m%d)
tar -czf ~/backups/backup_${DATE}.tar.gz ~/important_files/
```
- tar: أداة أرشفة وضغط.
- -c: إنشاء أرشيف جديد.
- -z: ضغط باستخدام gzip.
- -f: تحديد اسم الملف الناتج.
- ~/backups/backup_${DATE}.tar.gz: مسار واسم النسخة الاحتياطية.
- ~/important_files/: المجلد الذي نريد نسخه احتياطيًا.

### تنظيم الملفات

```bash
# هيكل مجلدات موصى به
~/
├── Documents/
│   ├── Projects/
│   ├── Archives/
│   └── Templates/
├── Downloads/
│   ├── Software/
│   └── Media/
└── Scripts/
    ├── backup/
    └── automation/
```

### أمان الملفات

```bash
# تشفير ملف حساس
gpg -c sensitive_file.txt

# إنشاء أرشيف محمي بكلمة مرور
zip -e archive.zip file1.txt file2.txt

# إنشاء checksum للتحقق من سلامة الملف
sha256sum important_file.txt > important_file.sha256
```

## 🚨 تجنب الأخطاء الشائعة

### أخطاء خطيرة يجب تجنبها

```bash
# خطر: حذف بدون تأكيد
rm -rf *                  # خطير!

# خطر: الكتابة فوق ملفات مهمة
cp temp.txt important.txt # بدون -i

# خطر: عدم التحقق من المسار
cd /wrong/path && rm -rf *

# أمان: استخدم دائماً
rm -i filename            # مع تأكيد
cp -i source dest         # مع تأكيد
pwd                       # تحقق من موقعك
```

### نصائح لتجنب فقدان البيانات

1. **استخدم -i مع أوامر الحذف والنسخ**
2. **تحقق من المسار باستخدام pwd**
3. **اعمل نسخ احتياطية دورية**
4. **استخدم version control للمشاريع**
5. **تجربة الأوامر الخطيرة في بيئة آمنة أولاً**

##  الأدوات المتقدمة

### أدوات مفيدة إضافية

```bash
# تثبيت أدوات مفيدة
sudo apt install tree ncdu htop

# tree: عرض هيكل المجلدات
tree /path/to/directory

# ncdu: تحليل استخدام القرص التفاعلي
ncdu /home

# rsync: نسخ متقدم ومتزامن
rsync -av source/ destination/
```

## 🔗 الخطوات التالية

بعد إتقان إدارة الملفات الأساسية:

1. **تعلم البرمجة النصية (Shell Scripting)**
2. **استكشاف أدوات الأرشفة والضغط**
3. **تعلم إدارة العمليات والخدمات**
4. **دراسة إدارة الشبكات في Linux**

---

**📁 تذكر**: الإدارة الجيدة للملفات هي أساس العمل المنتج في Linux. مارس الأوامر بانتظام واحتفظ بنسخ احتياطية من ملفاتك المهمة!
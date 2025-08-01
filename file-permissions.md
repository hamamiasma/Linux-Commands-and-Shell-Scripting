# 🔐 إدارة صلاحيات الملفات في Linux

##  المحتويات

- [مقدمة عن الأمان](#-مقدمة-عن-الأمان)
- [نظام الملكية](#-نظام-الملكية)
- [فهم الصلاحيات](#-فهم-الصلاحيات)
- [عرض الصلاحيات](#-عرض-الصلاحيات)
- [تعديل الصلاحيات](#-تعديل-الصلاحيات)
- [صلاحيات المجلدات](#-صلاحيات-المجلدات)
- [الملفات التنفيذية](#-الملفات-التنفيذية)
- [التمارين العملية](#-التمارين-العملية)

##  مقدمة عن الأمان

### لماذا نحتاج لصلاحيات الملفات؟

نظام Linux هو نظام **متعدد المستخدمين**، مما يعني:
- المستخدمون الآخرون يمكنهم رؤية ملفاتك ما لم تقم بتقييد ذلك
- تحتاج لحماية الملفات الحساسة (وثائق مالية، ملفات عمل)
- يجب تحديد من يستطيع قراءة أو تعديل أو تنفيذ ملفاتك

### أهمية إدارة الصلاحيات

- 🔒 **الأمان**: حماية البيانات الحساسة
- 👥 **الخصوصية**: التحكم في من يصل لملفاتك
- 🚫 **منع التلف**: حماية الملفات من التعديل غير المرغوب
- ⚡ **الكفاءة**: تنظيم الوصول للموارد

## 👥 نظام الملكية

في Linux، هناك **3 مستويات للملكية**:

| المستوى | الرمز | الوصف |
|---------|-------|--------|
| **User (المستخدم)** | `u` | المستخدم الذي أنشأ الملف |
| **Group (المجموعة)** | `g` | مجموعة من المستخدمين |
| **Other (الآخرون)** | `o` | أي شخص آخر على النظام |

### قاعدة مهمة
> **فقط مالك الملف يستطيع تغيير صلاحياته**

## فهم الصلاحيات

### أنواع الصلاحيات

| الصلاحية | الرمز | للملفات | للمجلدات |
|----------|-------|----------|-----------|
| **Read (قراءة)** | `r` | قراءة محتوى الملف | عرض محتويات المجلد (`ls`) |
| **Write (كتابة)** | `w` | تعديل الملف | إضافة/حذف ملفات من المجلد |
| **Execute (تنفيذ)** | `x` | تشغيل الملف كبرنامج | الدخول إلى المجلد (`cd`) |

##  عرض الصلاحيات

### إنشاء ملف للتجربة

```bash
echo "Who can read this file?" > my_new_file
ls -l my_new_file
```

### فهم مخرجات الأمر ls -l

```
-rw-r--r-- 1 theia users 25 Dec 22 17:47 my_new_file
```

#### تحليل الصلاحيات:

| الجزء | التفسير |
|-------|----------|
| `-` | نوع الملف (- = ملف، d = مجلد) |
| `rw-` | صلاحيات المستخدم: قراءة وكتابة |
| `r--` | صلاحيات المجموعة: قراءة فقط |
| `r--` | صلاحيات الآخرين: قراءة فقط |
| `1` | عدد الروابط |
| `theia` | اسم المالك |
| `users` | اسم المجموعة |
| `25` | حجم الملف |
| `Dec 22 17:47` | تاريخ آخر تعديل |

### أمثلة على أنواع الملفات

| الرمز | النوع |
|-------|--------|
| `-` | ملف عادي |
| `d` | مجلد (directory) |
| `l` | رابط رمزي (symbolic link) |
| `c` | ملف جهاز أحرف |
| `b` | ملف جهاز كتل |

## ⚙️ تعديل الصلاحيات

### الأمر chmod (Change Mode)

الصيغة العامة:
```bash
chmod [who][operation][permission] filename
```

### الرموز المستخدمة

#### من (Who):
| الرمز | المعنى |
|-------|--------|
| `u` | المستخدم (User) |
| `g` | المجموعة (Group) |
| `o` | الآخرون (Other) |
| `a` | الجميع (All) |

#### العمليات (Operations):
| الرمز | المعنى |
|-------|--------|
| `+` | إضافة صلاحية |
| `-` | إزالة صلاحية |
| `=` | تعيين صلاحية محددة |

### أمثلة عملية

#### جعل الملف خاص (قراءة فقط للمالك)

```bash
chmod go-r my_new_file
ls -l my_new_file
```

**النتيجة:**
```
-rw------- 1 theia users 24 Dec 22 18:49 my_new_file
```

#### إضافة صلاحية التنفيذ للجميع

```bash
chmod +x my_script.sh
```

#### إزالة صلاحية الكتابة من المجموعة

```bash
chmod g-w filename
```

#### تعيين صلاحيات محددة

```bash
chmod u=rwx,g=rx,o=r filename
```

### الطريقة الرقمية لchmod

كل صلاحية لها قيمة رقمية:
- `r` = 4
- `w` = 2  
- `x` = 1

#### أمثلة على الأرقام:

| الرقم | الصلاحيات | المعنى |
|-------|------------|---------|
| `7` | `rwx` | جميع الصلاحيات |
| `6` | `rw-` | قراءة وكتابة |
| `5` | `r-x` | قراءة وتنفيذ |
| `4` | `r--` | قراءة فقط |
| `0` | `---` | لا صلاحيات |

#### استخدام الطريقة الرقمية:

```bash
# rwx للمالك، r-x للمجموعة، r-- للآخرين
chmod 754 filename

# rw- للمالك، r-- للمجموعة والآخرين  
chmod 644 filename

# rwx للمالك فقط
chmod 700 filename
```

## 📁 صلاحيات المجلدات

### إنشاء مجلد للتجربة

```bash
mkdir test_directory
ls -l
```

**مثال النتيجة:**
```
drwxr-sr-x 2 theia users 4096 May 15 14:06 test_directory
```

### معنى صلاحيات المجلدات

| الصلاحية | الوظيفة |
|----------|----------|
| `r` | عرض محتويات المجلد (`ls`) |
| `w` | إضافة/حذف ملفات من المجلد |
| `x` | الدخول إلى المجلد (`cd`) |

### تجارب على صلاحيات المجلدات

#### إزالة صلاحية التنفيذ

```bash
chmod u-x test_directory
cd test_directory  # سيفشل
```

**النتيجة:**
```
bash: cd: test_directory: Permission denied
```

#### إزالة صلاحية الكتابة

```bash
chmod u+x test_directory  # استرجاع التنفيذ
chmod u-w test_directory  # إزالة الكتابة
cd test_directory
mkdir new_folder  # سيفشل
```

## الملفات التنفيذية

### ما هي الملفات التنفيذية؟

الملف التنفيذي هو ملف يحتوي على:
- أوامر يمكن للنظام تفسيرها
- برامج نصية (Scripts) مثل Bash scripts
- برامج مترجمة

### متطلبات التنفيذ

1. **صلاحية التنفيذ**: `chmod +x filename`
2. **Shebang**: السطر الأول يحدد المفسر

#### أمثلة على Shebang:

```bash
#!/bin/bash          # Bash script
#!/usr/bin/python3   # Python script
#!/bin/sh            # Shell script
```

### مثال عملي

```bash
# إنشاء نص برمجي
echo '#!/bin/bash' > my_script.sh
echo 'echo "Hello from script!"' >> my_script.sh

# إضافة صلاحية التنفيذ
chmod +x my_script.sh

# تشغيل النص البرمجي
./my_script.sh
```

##  التمارين العملية

### تمرين 1: عرض وتعديل صلاحيات الملفات

#### الخطوة 1: تنزيل ملف للتجربة

```bash
cd /home/project
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-LX0117EN-SkillsNetwork/labs/module%201/usdoi.txt
```

#### الخطوة 2: عرض الصلاحيات

```bash
ls -l usdoi.txt
```

**مثال النتيجة:**
```
-rw-r--r-- 1 theia theia 8121 May 31 16:45 usdoi.txt
```

#### الخطوة 3: تجارب التعديل

```bash
# إزالة صلاحية القراءة من الجميع
chmod -r usdoi.txt
ls -l usdoi.txt

# إعادة صلاحية القراءة للجميع  
chmod +r usdoi.txt
ls -l usdoi.txt

# إزالة صلاحية القراءة من الآخرين فقط
chmod o-r usdoi.txt
ls -l usdoi.txt
```

### تمرين 2: إدارة صلاحيات المجلدات

#### الخطوة 1: إنشاء مجلد تجريبي

```bash
mkdir test_permissions
ls -l
```

#### الخطوة 2: تجربة صلاحيات مختلفة

```bash
# إزالة صلاحية التنفيذ
chmod u-x test_permissions
cd test_permissions  # فشل متوقع

# استرجاع التنفيذ، إزالة الكتابة
chmod u+x test_permissions
chmod u-w test_permissions
cd test_permissions
mkdir subfolder  # فشل متوقع
```

### تمرين 3: إنشاء ملف تنفيذي

```bash
# إنشاء نص برمجي بسيط
# EOF هو مُعرّف أو علامة نهاية (يمكن أن تكون أي كلمة، ولكن EOF شائعة الاستخدام) تُستخدم لتحديد بداية ونهاية كتلة نصية تُمرَّر كمدخل للأمر. في المثال:
cat > hello_script.sh << 'EOF'
#!/bin/bash
echo "مرحبا من النص البرمجي!"
echo "التاريخ الحالي: $(date)"
EOF

# إضافة صلاحية التنفيذ
chmod +x hello_script.sh

# تشغيل النص البرمجي
./hello_script.sh
```

##  نصائح متقدمة

### استخدام umask

```bash

# حدد umask ما هي الأذونات التي يتم منعها تلقائيًا عند إنشاء ملف أو مجلد.

# عرض قيمة umask الحالية
umask

# تعيين umask جديدة (مؤقتًا)
umask 077  # الملفات الجديدة ستكون خاصة
```

### البحث عن ملفات بصلاحيات محددة

```bash
# البحث عن ملفات قابلة للتنفيذ
find . -perm -111

# البحث عن ملفات قابلة للكتابة من قبل الآخرين
find . -perm -002

# البحث عن ملفات مع صلاحيات 755
find . -perm 755
```

### تغيير المالك والمجموعة

```bash
# تغيير المالك (يتطلب sudo)
sudo chown newowner filename

# تغيير المجموعة
sudo chgrp newgroup filename

# تغيير المالك والمجموعة معًا
sudo chown newowner:newgroup filename
```

## ⚠️ تحذيرات أمنية

### لا تفعل هذا أبدًا:

```bash
# خطير جداً - لا تنفذ هذا!
chmod 777 /  # يعطي صلاحيات كاملة لجميع الملفات
chmod -R 777 ~  # يجعل جميع ملفاتك الشخصية متاحة للجميع
```

### أفضل الممارسات:

1. **مبدأ الحد الأدنى**: أعط أقل صلاحيات ممكنة
2. **راجع الصلاحيات دوريًا**: تحقق من صلاحيات الملفات المهمة
3. **احذر من 777**: لا تستخدمها إلا في حالات نادرة جداً
4. **استخدم المجموعات**: نظم المستخدمين في مجموعات

##  جدول مرجعي سريع

### صلاحيات شائعة للملفات:

| الصلاحية | الرقم | الاستخدام |
|----------|-------|-----------|
| `rw-r--r--` | `644` | ملفات عادية |
| `rw-------` | `600` | ملفات خاصة |
| `rwxr-xr-x` | `755` | ملفات تنفيذية |
| `rwx------` | `700` | ملفات تنفيذية خاصة |

### صلاحيات شائعة للمجلدات:

| الصلاحية | الرقم | الاستخدام |
|----------|-------|-----------|
| `drwxr-xr-x` | `755` | مجلدات عامة |
| `drwx------` | `700` | مجلدات خاصة |
| `drwxrwxr-x` | `775` | مجلدات مشتركة |

## 🔗 الخطوات التالية

بعد إتقان صلاحيات الملفات، ننصح بـ:
1. تعلم [إدارة الملفات المتقدمة](./file-management.md)
2. استكشاف أوامر النظام المتقدمة
3. تعلم كتابة النصوص البرمجية

---

**🔐 تذكر**: الأمان في Linux يعتمد على الإدارة الصحيحة للصلاحيات. كن حذرًا ودقيقًا!
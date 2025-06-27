#  معالجة النصوص والبيانات في Linux

##  المحتويات

- [مقدمة](#-مقدمة)
- [ترتيب البيانات - sort](#-ترتيب-البيانات---sort)
- [إزالة التكرارات - uniq](#-إزالة-التكرارات---uniq)
- [البحث في النصوص - grep](#-البحث-في-النصوص---grep)
- [استخراج البيانات - cut](#-استخراج-البيانات---cut)
- [دمج الملفات - paste](#-دمج-الملفات---paste)
- [أوامر إضافية مفيدة](#-أوامر-إضافية-مفيدة)
- [تطبيقات عملية](#-تطبيقات-عملية)
- [التمارين](#-التمارين)
- [نصائح متقدمة](#-نصائح-متقدمة)

##  مقدمة

معالجة النصوص والبيانات هي من أقوى ميزات Linux. هذا الدليل يغطي الأوامر الأساسية لـ:
- ترتيب وتنظيم البيانات
- البحث والتصفية
- استخراج ودمج المعلومات
- تحليل النصوص

### فوائد إتقان معالجة النصوص:
- 📊 **تحليل البيانات**: معالجة ملفات CSV وقوائم البيانات
- 🔍 **البحث السريع**: العثور على المعلومات بكفاءة
- 🧹 **تنظيف البيانات**: إزالة التكرارات والترتيب
- ⚡ **الأتمتة**: دمج الأوامر في نصوص برمجية

##  ترتيب البيانات - sort

### الوظيفة الأساسية
يرتب أسطر الملف ترتيبًا أبجديًا أو رقميًا.

### الاستخدام الأساسي

```bash
# ترتيب أبجدي أساسي
sort filename.txt

# مثال عملي
echo -e "dog\ncat\nbird\napple" | sort
```

**النتيجة:**
```
apple
bird
cat
dog
```

### خيارات متقدمة

```bash
# ترتيب عكسي (تنازلي)
sort -r pets.txt

# ترتيب رقمي (مهم للأرقام)
sort -n numbers.txt

# ترتيب حسب عمود محدد
sort -k 2 data.txt

# ترتيب وحفظ النتيجة
sort input.txt > sorted_output.txt

# تجاهل حالة الأحرف
sort -f mixed_case.txt
```

### أمثلة عملية

```bash
# ترتيب قائمة أسماء
cat > names.txt << EOF
أحمد
محمد  
سارة
فاطمة
علي
EOF

sort names.txt
```

### جدول خيارات sort

| الخيار | الوصف |
|--------|--------|
| `-r` | ترتيب عكسي |
| `-n` | ترتيب رقمي |
| `-k N` | ترتيب حسب العمود رقم N |
| `-f` | تجاهل حالة الأحرف |
| `-u` | إزالة التكرارات أثناء الترتيب |
| `-t 'delimiter'` | تحديد فاصل الحقول |

##  إزالة التكرارات - uniq

### الوظيفة الأساسية
يحذف الأسطر المكررة **المتتالية فقط**.

### الاستخدام الأساسي

```bash
# إزالة التكرارات المتتالية
uniq pets.txt

# مثال عملي
echo -e "cat\ncat\ndog\ncat\ndog\ndog" | uniq
```

**النتيجة:**
```
cat
dog
cat
dog
```

### الاستخدام الصحيح مع sort

```bash
# ترتيب ثم إزالة جميع التكرارات
sort pets.txt | uniq

# أو استخدام sort -u مباشرة
sort -u pets.txt
```

### خيارات متقدمة

```bash
# عدد التكرارات لكل سطر
uniq -c pets.txt

# عرض السطور المكررة فقط
uniq -d pets.txt

# عرض السطور الفريدة فقط (غير مكررة)
uniq -u pets.txt
```

### مثال تطبيقي

```bash
# إنشاء ملف تجريبي
cat > animals.txt << EOF
cat
dog
cat
bird
dog
cat
bird
EOF

# ترتيب وعدّ التكرارات
sort animals.txt | uniq -c
```

**النتيجة:**
```
1 bird
2 cat
2 dog
```

##  البحث في النصوص - grep

### الوظيفة الأساسية
البحث عن نمط أو كلمة في الملفات والنصوص.

### الاستخدام الأساسي

```bash
# البحث عن كلمة
grep "pattern" filename.txt

# البحث في عدة ملفات
grep "pattern" *.txt

# البحث التفاعلي من الإدخال
echo "Hello World" | grep "World"
```

### الخيارات الأساسية

| الخيار | الوظيفة |
|--------|----------|
| `-i` | تجاهل حالة الأحرف (غير حساس للأحرف الكبيرة والصغيرة) |
| `-n` | عرض رقم السطر مع النتيجة |
| `-c` | عدد الأسطر التي تطابق النمط |
| `-v` | عكس النتيجة: عرض الأسطر التي **لا** تحتوي على النمط |
| `-w` | مطابقة الكلمة **كاملة** فقط |
| `-r` | البحث في المجلدات بشكل تكراري |

### أمثلة متقدمة

```bash
# بحث غير حساس لحالة الأحرف مع رقم السطر
grep -in "error" logfile.txt

# البحث عن كلمة كاملة فقط
grep -w "fail" results.txt

# عكس البحث (كل شيء ما عدا النمط)
grep -v "success" results.txt

# عدّ النتائج
grep -c "pattern" file.txt

# البحث في جميع ملفات المجلد
grep -r "TODO" ~/project/
```

### أنماط البحث المتقدمة

```bash
# البحث باستخدام Regular Expressions
grep "^start" file.txt        # أسطر تبدأ بكلمة "start"
grep "end$" file.txt          # أسطر تنتهي بكلمة "end"
grep "[0-9]" file.txt         # أسطر تحتوي على أرقام
grep "colou?r" file.txt       # مطابقة "color" أو "colour"

# البحث عن عدة أنماط
grep -E "pattern1|pattern2" file.txt
```

### مثال تطبيقي

```bash
# إنشاء ملف سجل تجريبي
cat > logfile.txt << EOF
2024-01-01 INFO: System started
2024-01-01 ERROR: Database connection failed
2024-01-01 WARNING: Low disk space
2024-01-01 INFO: User logged in
2024-01-01 ERROR: Authentication failed
EOF

# البحث عن رسائل الخطأ
grep "ERROR" logfile.txt

# البحث مع رقم السطر
grep -n "ERROR" logfile.txt

# عدّ رسائل الخطأ
grep -c "ERROR" logfile.txt

# أسطر تنتهي بكلمة "end"
grep "end$" file.txt

this is the end
weekend
start to end
the end.
end
```

## ✂️ استخراج البيانات - cut

### الوظيفة الأساسية
استخراج أجزاء محددة من كل سطر (أعمدة، أحرف، حقول).

### استخراج الأحرف

```bash
# استخراج الأحرف من 2 إلى 9
cut -c 2-9 people.txt

# استخراج الحرف الأول فقط
cut -c 1 names.txt

# استخراج عدة مجالات من الأحرف
cut -c 1-3,7-10 data.txt
```

### استخراج الحقول

```bash
# استخراج الحقل الثاني (الفصل بالفراغ)
cut -d " " -f 2 people.txt

# استخراج عدة حقول
cut -d "," -f 1,3 csv_file.csv

# استخراج من الحقل الثاني للآخر
cut -d ":" -f 2- /etc/passwd
```

### أمثلة عملية

```bash
# إنشاء ملف بيانات CSV
cat > employees.csv << EOF
John,Doe,Developer,50000
Jane,Smith,Designer,45000
Bob,Johnson,Manager,60000
EOF

# استخراج الأسماء الأولى
cut -d "," -f 1 employees.csv

# استخراج المسميات الوظيفية
cut -d "," -f 3 employees.csv

# استخراج الاسم والراتب
cut -d "," -f 1,4 employees.csv
```

### جدول خيارات cut

| الخيار | الوصف |
|--------|--------|
| `-c N-M` | استخراج الأحرف من N إلى M |
| `-d "delimiter"` | تحديد فاصل الحقول |
| `-f N` | استخراج الحقل رقم N |
| `-f N,M` | استخراج حقول متعددة |
| `-f N-` | من الحقل N للنهاية |
| `--complement` | استخراج كل شيء ما عدا المحدد |

##  دمج الملفات - paste

### الوظيفة الأساسية
دمج محتويات عدة ملفات سطر بسطر (أعمدة جانبية).

### الاستخدام الأساسي

```bash
# دمج ملفين
paste file1.txt file2.txt

# دمج عدة ملفات
paste first.txt last.txt age.txt
```

### إنشاء مثال تطبيقي

```bash
# إنشاء ملفات منفصلة
echo -e "أحمد\nفاطمة\nمحمد" > first_names.txt
echo -e "علي\nأحمد\nسالم" > last_names.txt
echo -e "25\n30\n28" > ages.txt

# دمج الملفات
paste first_names.txt last_names.txt ages.txt
```

**النتيجة:**
```
أحمد	علي	25
فاطمة	أحمد	30
محمد	سالم	28
```

### تخصيص الفاصل

```bash
# استخدام فاصلة كفاصل
paste -d "," first_names.txt last_names.txt ages.txt
```
**النتيجة:**
```
أحمد,علي,25
فاطمة,أحمد,30
محمد,سالم,28
```

```bash
# استخدام عدة فواصل
paste -d ",-" file1.txt file2.txt file3.txt

# استخدام مسافات متعددة
paste -d "   " file1.txt file2.txt
```
**النتيجة:**
```
أحمد,علي-25
فاطمة,أحمد-30
محمد,سالم-28
```

### خيارات متقدمة

```bash
# دمج سطري (تحويل الأعمدة لصفوف)
paste -s file.txt

# دمج مع فاصل سطر جديد
paste -d "\n" file1.txt file2.txt
```

##  أوامر إضافية مفيدة

### tr - تحويل الأحرف

```bash
# تحويل للأحرف الكبيرة
echo "hello world" | tr 'a-z' 'A-Z'

# حذف أحرف معينة
echo "hello123world" | tr -d '0-9'

# استبدال المسافات بشرطات سفلية
echo "hello world" | tr ' ' '_'
```

### wc - عدّ الكلمات والأسطر

```bash
# عدّ الأسطر والكلمات والأحرف
wc filename.txt

# عدّ الأسطر فقط
wc -l filename.txt

# عدّ الكلمات فقط
wc -w filename.txt

# عدّ الأحرف فقط
wc -c filename.txt
```

### head و tail - عرض بداية ونهاية الملف

```bash
# أول 10 أسطر
head filename.txt

# أول 5 أسطر
head -n 5 filename.txt

# آخر 10 أسطر
tail filename.txt

# متابعة التحديثات (للسجلات)
tail -f logfile.txt
```

##  تطبيقات عملية

### مثال 1: تحليل ملف سجل الخادم

```bash
# إنشاء ملف سجل تجريبي
cat > server.log << EOF
192.168.1.1 - GET /index.html 200
192.168.1.2 - POST /login 401
192.168.1.1 - GET /about.html 200
192.168.1.3 - GET /index.html 404
192.168.1.2 - POST /login 200
192.168.1.1 - GET /contact.html 200
EOF

# أكثر عناوين IP نشاطًا
cut -d " " -f 1 server.log | sort | uniq -c | sort -nr

# عدد الطلبات الناجحة (200)
grep "200" server.log | wc -l

# استخراج الصفحات المطلوبة
cut -d " " -f 3 server.log | sort | uniq
```

### مثال 2: معالجة ملف CSV للموظفين

```bash
# إنشاء ملف بيانات موظفين
cat > employees.csv << EOF
Name,Department,Salary,Years
أحمد علي,IT,75000,5
سارة محمد,HR,60000,3
خالد أحمد,Finance,80000,7
فاطمة سالم,IT,70000,4
محمد عبدالله,Marketing,65000,6
EOF

# استخراج أسماء موظفي IT
grep "IT" employees.csv | cut -d "," -f 1

# متوسط رواتب قسم IT
grep "IT" employees.csv | cut -d "," -f 3 | paste -sd+ | bc

# ترتيب حسب الراتب
sort -t "," -k 3 -nr employees.csv
```

### مثال 3: تنظيف قائمة بريد إلكتروني

```bash
# إنشاء قائمة بريد مع تكرارات
cat > emails.txt << EOF
user1@example.com
user2@gmail.com
user1@example.com
admin@company.com
user3@yahoo.com
user2@gmail.com
EOF

# إزالة التكرارات وترتيب أبجدي
sort emails.txt | uniq > clean_emails.txt

# البحث عن gmail فقط
grep "gmail" clean_emails.txt

# عدّ رسائل كل domain
cut -d "@" -f 2 clean_emails.txt | sort | uniq -c
```

##  التمارين

### تمرين 1: تحليل ملف نصي

```bash
# إنشاء ملف نص للتحليل
cat > sample_text.txt << EOF
Linux is powerful
Unix is reliable  
Linux is open source
Windows is popular
Linux is free
Unix is stable
EOF

# المطلوب:
# 1. عدّ كم مرة ذُكرت كلمة "Linux"
# 2. ترتيب الأسطر أبجدياً
# 3. استخراج الكلمة الأولى من كل سطر
# 4. البحث عن أسطر تحتوي على "is"
```

### الحلول:

```bash
# 1. عدّ كلمة "Linux"
grep -c "Linux" sample_text.txt

# 2. ترتيب أبجدي
sort sample_text.txt

# 3. استخراج الكلمة الأولى
cut -d " " -f 1 sample_text.txt

# 4. البحث عن "is"
grep "is" sample_text.txt
```

### تمرين 2: معالجة بيانات الطلاب

```bash
# إنشاء ملف درجات الطلاب
cat > grades.csv << EOF
StudentName,Subject,Grade
أحمد,Math,85
سارة,Science,92
أحمد,Science,78
محمد,Math,90
سارة,Math,88
محمد,Science,85
EOF

# المطلوب:
# 1. عرض درجات الرياضيات فقط
# 2. ترتيب الطلاب حسب الاسم
# 3. حساب متوسط درجات كل طالب
```
### الحلول:

```bash
# -F ",": يستخدم الفاصلة كفاصل حقول (CSV).
#'$2 == "Math"': شرط لاختيار الصفوف التي المادة فيها "Math".
#print: طباعة السطر كما هو.

echo "🔹 درجات الرياضيات فقط:"
awk -F "," '$2 == "Math"' grades.csv

echo -e "\n🔹 ترتيب حسب الاسم:"
# -n +2: Gibt alle Zeilen ab der zweiten Zeile einer Eingabe oder Datei aus.
tail -n +2 grades.csv | sort -t "," -k1

echo -e "\n🔹 متوسط درجات كل طالب:"
# printf "%s: %.2f\n", name, sum[name]/count[name]: Formatiert die Ausgabe: Name, Doppelpunkt, Durchschnitt mit 2 Nachkommastellen.
tail -n +2 grades.csv | awk -F "," '{ sum[$1] += $3; count[$1]++ } END { for (name in sum) printf "%s: %.2f\n", name, sum[name]/count[name] }'
```
##  نصائح متقدمة

### دمج عدة أوامر بأنابيب

```bash
# سلسلة معالجة متقدمة
cat data.txt | grep "pattern" | sort | uniq -c | sort -nr

# تحليل أكثر الكلمات تكراراً في ملف
cat text.txt | tr ' ' '\n' | sort | uniq -c | sort -nr | head -10
```

### استخدام متغيرات البيئة

```bash
# حفظ النتائج في متغير
# $(...): تشغيل أمر وحفظ النتيجة.
RESULT=$(grep "pattern" file.txt | wc -l)
echo "Found $RESULT matches"
```

### إنشاء تقارير

```bash
#!/bin/bash
# نص برمجي لتحليل ملف سجل

LOG_FILE="server.log"
echo "=== تقرير تحليل السجل ==="
echo "إجمالي الطلبات: $(wc -l < $LOG_FILE)"
echo "الطلبات الناجحة: $(grep '200' $LOG_FILE | wc -l)"
echo "الطلبات الفاشلة: $(grep -v '200' $LOG_FILE | wc -l)"
echo ""
echo "أكثر عناوين IP نشاطاً:"
cut -d " " -f 1 $LOG_FILE | sort | uniq -c | sort -nr | head -5
# عرض أكثر 5 عناوين IP نشاطًا.
```

### تحسين الأداء

```bash
# استخدام LC_ALL=C لتسريع المعالجة
LC_ALL=C sort large_file.txt

# معالجة الملفات الكبيرة على دفعات
split -l 1000 large_file.txt part_
```

##  ملخص سريع

| الأمر | الوظيفة الأساسية | مثال |
|-------|------------------|-------|
| `sort` | ترتيب أسطر الملف | `sort file.txt` |
| `uniq` | حذف التكرارات المتتالية | `sort file.txt \| uniq` |
| `grep` | البحث عن نمط | `grep "pattern" file.txt` |
| `cut` | استخراج جزء من السطر | `cut -d "," -f 1 file.csv` |
| `paste` | دمج ملفات جانبياً | `paste file1.txt file2.txt` |

## 🔗 الخطوات التالية

بعد إتقان معالجة النصوص الأساسية:

1. **تعلم Regular Expressions** للبحث المتقدم
2. **استكشاف sed وawk** لمعالجة أكثر تعقيداً  
3. **تطوير نصوص برمجية** لأتمتة المهام
4. **دراسة معالجة البيانات الضخمة** باستخدام أدوات متخصصة


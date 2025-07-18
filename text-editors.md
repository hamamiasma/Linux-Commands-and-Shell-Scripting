# ✏️ محررات النصوص في Linux

## المحتويات

- [مقدمة](#-مقدمة)
- [محرر Nano](#-محرر-nano)
- [محرر Vim](#-محرر-vim)
- [مقارنة بين المحررين](#-مقارنة-بين-المحررين)
- [التمارين العملية](#-التمارين-العملية)
- [نصائح وحيل](#-نصائح-وحيل)

##  مقدمة

محررات النصوص هي أدوات أساسية لأي مستخدم Linux. في هذا الدليل، سنتعلم استخدام محررين شائعين:
- **Nano**: محرر بسيط ومناسب للمبتدئين
- **Vim**: محرر قوي ومخصص للمستخدمين المتقدمين

## محرر Nano

### مقدمة عن Nano

Nano هو محرر نصوص بسيط يُستخدم داخل الطرفية (Terminal). يتميز بـ:
- سهولة الاستخدام للمبتدئين
- واجهة بديهية مع عرض الاختصارات
- لا يحتاج إلى تعلم أوضاع خاصة

### تشغيل Nano

```bash
# فتح محرر فارغ
nano

# إنشاء أو تحرير ملف
nano filename.txt

# فتح ملف مع الانتقال إلى سطر محدد
nano +10 filename.txt
```

### الاختصارات الأساسية في Nano

| الاختصار | الوظيفة |
|-----------|----------|
| `Ctrl + X` | الخروج من المحرر |
| `Ctrl + O` | حفظ الملف |
| `Ctrl + W` | البحث في النص |
| `Ctrl + K` | قص السطر الحالي |
| `Ctrl + U` | لصق النص المقصوص |
| `Ctrl + G` | عرض المساعدة |
| `Ctrl + C` | عرض موقع المؤشر |

### تمرين عملي: إنشاء ملف مع Nano

```bash
# الانتقال إلى مجلد المشروع
cd /home/project

# إنشاء وتحرير ملف جديد
nano hello_world.txt
```

**اكتب في المحرر:**
```
Hello world!
This is the second line of my first-ever text file created with nano.
```

**للحفظ والخروج:**
1. اضغط `Ctrl + X`
2. اضغط `Y` للحفظ
3. اضغط `Enter` لتأكيد اسم الملف

**التحقق من الملف:**
```bash
cat hello_world.txt
```

## 🚀 محرر Vim

### مقدمة عن Vim

Vim هو محرر نصوص قوي ومخصص للمستخدمين المتقدمين. يتميز بـ:
- كفاءة عالية وسرعة في التحرير
- قابلية تخصيص متقدمة
- دعم ممتاز للبرمجة
- منحنى تعلم أكثر تحديًا

### تثبيت Vim

```bash
sudo apt install vim
```

### أوضاع Vim

Vim يعمل بنظام الأوضاع (Modes):

| الوضع | الوصف | كيفية الدخول |
|--------|--------|---------------|
| **Normal Mode** | الوضع الافتراضي للتنقل والأوامر | `Esc` |
| **Insert Mode** | وضع الكتابة والتحرير | `i`, `a`, `o` |
| **Visual Mode** | وضع التحديد | `v` |
| **Command Mode** | وضع الأوامر | `:` |

### الأوامر الأساسية في Vim

#### أوامر التشغيل والخروج

```bash
# تشغيل Vim
vim

# فتح ملف
vim filename.txt

# عرض المساعدة
:help

# الخروج
:q

# الخروج بدون حفظ
:q!

# حفظ والخروج
:wq
```

#### أوامر الحفظ والتحرير

| الأمر | الوظيفة |
|-------|----------|
| `:w` | حفظ الملف |
| `:q` | الخروج |
| `:wq` | حفظ وخروج |
| `:q!` | خروج بدون حفظ |
| `i` | الدخول إلى Insert Mode |
| `Esc` | العودة إلى Normal Mode |

### تمرين عملي: إنشاء ملف مع Vim

```bash
# الانتقال إلى مجلد المشروع
cd /home/project

# إنشاء وتحرير ملف جديد
vim hello_world_2.txt
```

**خطوات التحرير:**
1. اضغط `i` للدخول إلى Insert Mode
2. اكتب النص:
   ```
   Hello World!
   This is the second line.
   ```
3. اضغط `Esc` للعودة إلى Normal Mode
4. اكتب `:w` للحفظ
5. اكتب `:q` للخروج

## ⚖️ مقارنة بين المحررين

| المقارنة | Vim | Nano |
|----------|-----|------|
| **سهولة الاستخدام** | صعب للمبتدئين | سهل جدًا |
| **وضعية التحرير** | Insert + Command | مباشر |
| **الوظائف المتقدمة** | قوي جدًا | محدود |
| **الاختصارات** | تعتمد على الأوامر | واضحة أسفل الشاشة |
| **السرعة** | سريع بعد التعود | أبطأ قليلًا |
| **الدعم البرمجي** | ممتاز للمطورين | جيد للمستخدمين العاديين |
| **الحفظ والخروج** | `:w` و `:q` | `Ctrl + O` و `Ctrl + X` |
| **الانتشار** | شائع بين المطورين | شائع بين المبتدئين |

##  متى تستخدم كل محرر؟

### استخدم Nano إذا:
- كنت مبتدئًا في Linux
- تريد التحرير بسرعة وسهولة
- تقوم بتعديلات بسيطة
- تحتاج لمحرر بديهي

### استخدم Vim إذا:
- تحتاج لتعديلات معقدة
- تعمل كثيرًا في الطرفية
- تريد تخصيص بيئة العمل
- تطور برمجيات بانتظام

##  التمارين العملية

### تمرين 1: تعديل ملف باستخدام Nano

```bash
# فتح الملف الموجود
nano hello_world.txt

# أضف السطر التالي:
# This is line three of my new file.

# للحفظ والخروج:
# Ctrl + X, ثم Y, ثم Enter
```

### تمرين 2: إنشاء نص برمجي باستخدام Vim

```bash
# إنشاء ملف نص برمجي
vim done.txt

# اضغط i للدخول إلى Insert Mode
# اكتب: echo "I am done with the lab!"
# اضغط Esc, ثم :wq

# تشغيل النص البرمجي
bash done.txt
```

**النتيجة المتوقعة:**
```
I am done with the lab!
```

##  نصائح وحيل

### نصائح لاستخدام Nano بكفاءة

1. **استخدم الاختصارات**: تعلم الاختصارات الأساسية لتوفير الوقت
2. **البحث والاستبدال**: استخدم `Ctrl + \` للبحث والاستبدال
3. **النسخ واللصق**: استخدم `Alt + A` لتحديد النص

### نصائح لتعلم Vim

1. **ابدأ بالأساسيات**: تعلم الأوضاع الأساسية أولاً
2. **تدرب يوميًا**: استخدم Vim لمدة 15 دقيقة يوميًا
3. **استخدم الدروس التفاعلية**: جرب الأمر `vimtutor`
4. **تخصيص الإعدادات**: أنشئ ملف `.vimrc` لتخصيص Vim

### أوامر Vim المتقدمة

```bash
# البحث في النص
/search_term

# إظهار أرقام الأسطر
:set number

# إلغاء أرقام الأسطر
:set nonumber

# استبدال النص
:%s/old/new/g

# : =>  للدخول في نمط أوامر.
# % : يشير إلى جميع الأسطر في الملف (نطاق العمل).
# s : اختصار لـ substitute، أي الاستبدال.
# /old/ : النص الذي تريد استبداله.
# /new/ : النص البديل الجديد.
# g : تعني global، أي استبدال كل تطابق في كل سطر، وليس فقط أول تطابق.

```

## 🔗 موارد إضافية

- [موقع Vim الرسمي](https://www.vim.org/)
- [دروس Vim التفاعلية](https://www.openvim.com/)
- [مرجع أوامر Nano](https://www.nano-editor.org/dist/latest/cheatsheet.html)

## الخطوات التالية

بعد إتقان استخدام محررات النصوص، ننصح بـ:
1. تعلم [إدارة صلاحيات الملفات](./file-permissions.md)
2. استكشاف [إدارة الملفات المتقدمة](./file-management.md)
3. البدء في كتابة النصوص البرمجية (Shell Scripts)

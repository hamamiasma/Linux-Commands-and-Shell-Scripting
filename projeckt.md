### مشروع 6: نظام مراقبة الخادم المتكامل
```bash
#!/bin/bash
# advanced_server_monitor.sh - نظام مراقبة متكامل مع التحذيرات والتقارير

# الإعدادات
CONFIG_FILE="$HOME/.server_monitor.conf"
LOG_DIR="$HOME/logs/server_monitor"
ALERT_EMAIL="admin@example.com"
REPORT_DIR="$HOME/reports"

# إنشاء ملف الإعدادات الافتراضي
create_default_config() {
    cat > "$CONFIG_FILE" << EOF
# إعدادات مراقب الخادم
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90
LOAD_THRESHOLD=2.0
CHECK_INTERVAL=300
ENABLE_EMAIL_ALERTS=false
ENABLE_LOG_ROTATION=true
MAX_LOG_FILES=30
EOF
}

# قراءة الإعدادات
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        create_default_config
    fi
    source "$CONFIG_FILE"
}

# دالة إرسال التحذيرات
send_alert() {
    local message="$1"
    local priority="$2"
    
    # كتابة في السجل
    echo "$(date): [$priority] $message" >> "$LOG_DIR/alerts.log"
    
    # إرسال بريد إلكتروني (إذا كان مفعلاً)
    if [ "$ENABLE_EMAIL_ALERTS" = "true" ]; then
        echo "$message" | mail -s "تحذير الخادم - $priority" "$ALERT_EMAIL"
    fi
    
    # عرض على الشاشة
    case $priority in
        "CRITICAL") echo "🔴 $message" ;;
        "WARNING")  echo "🟡 $message" ;;
        "INFO")     echo "🔵 $message" ;;
    esac
}

# فحص استخدام المعالج
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
    cpu_usage=${cpu_usage%.*}  # إزالة الكسور
    
    if [ ${cpu_usage:-0} -gt $CPU_THRESHOLD ]; then
        send_alert "استخدام المعالج مرتفع: ${cpu_usage}% (الحد الأقصى: ${CPU_THRESHOLD}%)" "WARNING"
        return 1
    fi
    return 0
}

# فحص استخدام الذاكرة
check_memory() {
    local memory_info=$(free | grep Mem)
    local total=$(echo $memory_info | awk '{print $2}')
    local used=$(echo $memory_info | awk '{print $3}')
    local memory_percent=$((used * 100 / total))
    
    if [ $memory_percent -gt $MEMORY_THRESHOLD ]; then
        send_alert "استخدام الذاكرة مرتفع: ${memory_percent}% (الحد الأقصى: ${MEMORY_THRESHOLD}%)" "WARNING"
        return 1
    fi
    return 0
}

# فحص مساحة القرص
check_disk() {
    local critical_disks=()
    
    while IFS= read -r line; do
        if [[ $line =~ ^/dev ]]; then
            local usage=$(echo $line | awk '{print $5}' | sed 's/%//')
            local mount=$(echo $line | awk '{print $6}')
            
            if [ ${usage:-0} -gt $DISK_THRESHOLD ]; then
                critical_disks+=("$mount: ${usage}%")
            fi
        fi
    done < <(df -h)
    
    if [ ${#critical_disks[@]} -gt 0 ]; then
        local message="أقراص ممتلئة: $(IFS=', '; echo "${critical_disks[*]}")"
        send_alert "$message" "CRITICAL"
        return 1
    fi
    return 0
}

# فحص حمولة النظام
check_load() {
    local load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)
    local cpu_cores=$(nproc)
    
    # مقارنة الحمولة مع عدد الأنوية
    if (( $(echo "$load_avg > $LOAD_THRESHOLD" | bc -l) )); then
        send_alert "حمولة النظام مرتفعة: $load_avg (الحد الأقصى: $LOAD_THRESHOLD، الأنوية: $cpu_cores)" "WARNING"
        return 1
    fi
    return 0
}

# فحص الخدمات المهمة
check_services() {
    local critical_services=("ssh" "cron")
    local failed_services=()
    
    for service in "${critical_services[@]}"; do
        if ! systemctl is-active --quiet "$service"; then
            failed_services+=("$service")
        fi
    done
    
    if [ ${#failed_services[@]} -gt 0 ]; then
        local message="خدمات متوقفة: $(IFS=', '; echo "${failed_services[*]}")"
        send_alert "$message" "CRITICAL"
        return 1
    fi
    return 0
}

# إنشاء تقرير شامل
generate_report() {
    local report_file="$REPORT_DIR/server_report_$(date +%Y%m%d_%H%M%S).html"
    
    mkdir -p "$REPORT_DIR"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <title>تقرير الخادم - $(date)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 10px; border-radius: 5px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .warning { background: #fff3cd; border-color: #ffeaa7; }
        .critical { background: #f8d7da; border-color: #f5c6cb; }
        .good { background: #d4edda; border-color: #c3e6cb; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: right; border: 1px solid #ddd; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>
    <div class="header">
        <h1>تقرير حالة الخادم</h1>
        <p>التاريخ والوقت: $(date)</p>
        <p>اسم الخادم: $(hostname -f)</p>
    </div>

    <div class="section">
        <h2>معلومات النظام</h2>
        <table>
            <tr><th>المعالج</th><td>$(lscpu | grep "Model name" | awk -F: '{print $2}' | xargs)</td></tr>
            <tr><th>الذاكرة الإجمالية</th><td>$(free -h | grep Mem | awk '{print $2}')</td></tr>
            <tr><th>نظام التشغيل</th><td>$(lsb_release -d | awk -F: '{print $2}' | xargs)</td></tr>
            <tr><th>وقت التشغيل</th><td>$(uptime -p)</td></tr>
        </table>
    </div>

    <div class="section">
        <h2>استخدام الموارد</h2>
        <table>
            <tr><th>المعالج</th><td>$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')</td></tr>
            <tr><th>الذاكرة</th><td>$(free -h | grep Mem | awk '{printf "المستخدم: %s من %s (%.1f%%)", $3, $2, $3/$2*100}')</td></tr>
            <tr><th>حمولة النظام</th><td>$(uptime | awk -F'load average:' '{print $2}')</td></tr>
        </table>
    </div>

    <div class="section">
        <h2>مساحة الأقراص</h2>
        <table>
            <tr><th>نقطة التحميل</th><th>الحجم</th><th>المستخدم</th><th>المتاح</th><th>النسبة</th></tr>
$(df -h | grep -E '^/dev' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $6, $2, $3, $4, $5}')
        </table>
    </div>

    <div class="section">
        <h2>العمليات النشطة (أكثر 10 استهلاكاً للمعالج)</h2>
        <table>
            <tr><th>PID</th><th>المستخدم</th><th>المعالج%</th><th>الذاكرة%</th><th>الأمر</th></tr>
$(ps aux --sort=-%cpu | head -11 | tail -10 | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $2, $1, $3, $4, $11}')
        </table>
    </div>

    <div class="section">
        <h2>آخر التحذيرات</h2>
        <pre>$(tail -20 "$LOG_DIR/alerts.log" 2>/dev/null || echo "لا توجد تحذيرات")</pre>
    </div>

    <div class="header">
        <p>تم إنشاء التقرير تلقائياً بواسطة نظام مراقبة الخادم</p>
    </div>
</body>
</html>
EOF

    echo "📊 تم إنشاء التقرير: $report_file"
}

# تدوير ملفات السجل
rotate_logs() {
    if [ "$ENABLE_LOG_ROTATION" = "true" ]; then
        find "$LOG_DIR" -name "*.log" -mtime +$MAX_LOG_FILES -delete
        send_alert "تم تدوير ملفات السجل" "INFO"
    fi
}

# الدالة الرئيسية للمراقبة
main_monitor() {
    local issues=0
    
    echo "🔍 بدء فحص النظام - $(date)"
    
    # إنشاء مجلدات السجلات
    mkdir -p "$LOG_DIR" "$REPORT_DIR"
    
    # تحميل الإعدادات
    load_config
    
    # تنفيذ الفحوصات
    check_cpu || ((issues++))
    check_memory || ((issues++))
    check_disk || ((issues++))
    check_load || ((issues++))
    check_services || ((issues++))
    
    # تقرير النتائج
    if [ $issues -eq 0 ]; then
        send_alert "جميع فحوصات النظام مرت بنجاح" "INFO"
    else
        send_alert "تم اكتشاف $issues مشكلة في النظام" "WARNING"
    fi
    
    # إنشاء تقرير يومي (إذا كان أول فحص في اليوم)
    local today=$(date +%Y%m%d)
    local last_report=$(find "$REPORT_DIR" -name "server_report_${today}_*.html" | head -1)
    
    if [ -z "$last_report" ]; then
        generate_report
    fi
    
    # تدوير السجلات
    rotate_logs
    
    echo "✅ انتهاء فحص النظام"
}

# واجهة سطر الأوامر
case "${1:-monitor}" in
    "monitor")
        main_monitor
        ;;
    "report")
        generate_report
        ;;
    "config")
        echo "📝 ملف الإعدادات: $CONFIG_FILE"
        if [ ! -f "$CONFIG_FILE" ]; then
            create_default_config
            echo "تم إنشاء ملف إعدادات افتراضي"
        fi
        echo "لتعديل الإعدادات: nano $CONFIG_FILE"
        ;;
    "logs")
        echo "📜 ملفات السجل في: $LOG_DIR"
        ls -la "$LOG_DIR" 2>/dev/null || echo "لا توجد ملفات سجل"
        ;;
    "install-cron")
        # إضافة مهمة cron للمراقبة كل 5 دقائق
        (crontab -l 2>/dev/null; echo "*/5 * * * * $PWD/$0 monitor >> /tmp/server_monitor_cron.log 2>&1") | crontab -
        echo "✅ تم تثبيت مهمة cron للمراقبة كل 5 دقائق"
        ;;
    "remove-cron")
        crontab -l 2>/dev/null | grep -v "$0" | crontab -
        echo "✅ تم إزالة مهمة cron"
        ;;
    "help")
        echo "نظام مراقبة الخادم المتكامل"
        echo "================================"
        echo "الاستخدام: $0 [command]"
        echo ""
        echo "الأوامر:"
        echo "  monitor       بدء فحص النظام (افتراضي)"
        echo "  report        إنشاء تقرير HTML"
        echo "  config        إدارة ملف الإعدادات"
        echo "  logs          عرض ملفات السجل"
        echo "  install-cron  تثبيت مراقبة تلقائية"
        echo "  remove-cron   إزالة المراقبة التلقائية"
        echo "  help          عرض هذه المساعدة"
        ;;
    *)
        echo "❌ أمر غير معروف: $1"
        echo "استخدم: $0 help للمساعدة"
        exit 1
        ;;
esac
```

**استخدام المشروع:**
```bash
# تشغيل فحص واحد
./advanced_server_monitor.sh monitor

# إنشاء تقرير
./advanced_server_monitor.sh report

# تثبيت مراقبة تلقائية كل 5 دقائق
./advanced_server_monitor.sh install-cron

# عرض الإعدادات
./advanced_server_monitor.sh config
```### مشروع 5: نظام إدارة المشاريع التلقائي
```bash
#!/bin/bash
# نظام شامل لإدارة مشاريع التطوير مع البرمجة النصية المتقدمة

PROJECT_ROOT="$HOME/Projects"
BACKUP_ROOT="$HOME/ProjectBackups"
LOG_FILE="$HOME/project_manager.log"

# دالة للكتابة في السجل
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# دالة لإنشاء مشروع جديد
create_project() {
    read -p "اسم المشروع: " project_name
    read -p "نوع المشروع (web/mobile/desktop): " project_type
    
    PROJECT_PATH="$PROJECT_ROOT/$project_name"
    
    if [ -d "$PROJECT_PATH" ]; then
        echo "❌ المشروع موجود مسبقاً!"
        return 1
    fi
    
    # إنشاء هيكل المشروع
    mkdir -p "$PROJECT_PATH"/{src,docs,tests,config,assets}
    
    # إنشاء ملفات أساسية
    echo "# $project_name" > "$PROJECT_PATH/README.md"
    echo "# مشروع $project_type" >> "$PROJECT_PATH/README.md"
    echo "تاريخ الإنشاء: $(date)" >> "$PROJECT_PATH/README.md"
    
    # إنشاء ملف إعدادات
    cat > "$PROJECT_PATH/config/project.conf" << EOF
PROJECT_NAME=$project_name
PROJECT_TYPE=$project_type
CREATED_DATE=$(date +%Y%m%d)
VERSION=1.0.0
EOF
    
    echo "✅ تم إنشاء المشروع: $project_name"
    log_action "تم إنشاء مشروع جديد: $project_name"
}

# دالة للنسخ الاحتياطي الذكي
backup_project() {
    read -p "اسم المشروع للنسخ الاحتياطي: " project_name
    PROJECT_PATH="$PROJECT_ROOT/$project_name"
    
    if [ ! -d "$PROJECT_PATH" ]; then
        echo "❌ المشروع غير موجود!"
        return 1
    fi
    
    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
    BACKUP_PATH="$BACKUP_ROOT/${project_name}_backup_$BACKUP_DATE.tar.gz"
    
    mkdir -p "$BACKUP_ROOT"
    
    echo "📦 إنشاء نسخة احتياطية..."
    tar -czf "$BACKUP_PATH" \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='*.tmp' \
        -C "$PROJECT_ROOT" "$project_name"
    
    BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
    echo "✅ تم إنشاء النسخة الاحتياطية: ${project_name}_backup_$BACKUP_DATE.tar.gz"
    echo "📊 الحجم: $BACKUP_SIZE"
    log_action "نسخة احتياطية للمشروع $project_name - الحجم: $BACKUP_SIZE"
}

# القائمة الرئيسية التفاعلية
while true; do
    clear
    echo "🚀 مدير المشاريع التلقائي"
    echo "=========================="
    echo "1) إنشاء مشروع جديد"
    echo "2) عرض المشاريع الموجودة"
    echo "3) نسخة احتياطية لمشروع"
    echo "4) إحصائيات المشاريع"
    echo "5) خروج"
    echo
    read -p "اختيارك (1-5): " choice
    
    case $choice in
        1) create_project ;;
        2) 
            echo "📁 المشاريع الموجودة:"
            ls -la "$PROJECT_ROOT" 2>/dev/null || echo "لا توجد مشاريع"
            ;;
        3) backup_project ;;
        4)
            echo "📊 إحصائيات المشاريع:"
            PROJECT_COUNT=$(find "$PROJECT_ROOT" -maxdepth 1 -type d | wc -l)
            echo "عدد المشاريع: $((PROJECT_COUNT - 1))"
            echo "إجمالي الحجم: $(du -sh "$PROJECT_ROOT" 2>/dev/null | cut -f1 || echo 'غير محدد')"
            ;;
        5) 
            echo "👋 شكراً لاستخدام مدير المشاريع!"
            exit 0 
            ;;
        *) echo "❌ اختيار غير صحيح!" ;;
    esac
    
    echo
    read -p "اضغط Enter للمتابعة..." 
done
```---

### 📜 [البرمجة النصية](./shell-scripting.md)
**أتمتة المهام والبرمجة المتقدمة**

#### المفاهيم الأساسية:
- **Shebang** (`#!/bin/bash`) - تحديد المفسر
- **المتغيرات والمصفوفات** - تخزين واستخدام البيانات
- **الشروط المتقدمة** - التحكم في تدفق البرنامج مع case
- **الحلقات المتطورة** - for, while, until للعمليات المعقدة
- **السكربتات التفاعلية** - التفاعل مع المستخدم

#### التقنيات المتقدمة:
- **Pipes والـ Filters** - ربط الأوامر ومعالجة البيانات
- **I/O Redirection** - توجيه المخرجات والمدخلات
- **Command Substitution** - استخدام مخرجات الأوامر
- **معالجة JSON** - تحليل البيانات من APIs
- **جدولة Cron** - تشغيل تلقائي للمهام

#### أمثلة متقدمة:
```bash
#!/bin/bash
# مراقب النظام التلقائي
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt 80 ]; then
    echo "تحذير: القرص ممتلئ بنسبة $USAGE%" | \
    mail -s "تحذير النظام" admin@example.com
fi

# جدولة يومية في cron (2:00 صباحاً)
# 0 2 * * * /home/user/system_monitor.sh
```

#### مشاريع متقدمة:
- 🤖 **نظام النسخ الاحتياطي الذكي** مع التنظيف التلقائي
- 📊 **مراقب النظام الشامل** مع التحذيرات
- 🗂️ **مدير الملفات المتطور** مع واجهة تفاعلية
- 📅 **جدولة المهام** التلقائية مع Cron# 🌟 الدليل الشامل لنظام Linux - فهرس كامل

## 📚 جميع الملفات التعليمية

### 📘 [الملف الرئيسي - README.md](./README.md)
**نظرة عامة ومقدمة شاملة**
- معلومات المشروع والأهداف
- دليل البدء السريع
- المتطلبات والتثبيت
- روابط جميع الأقسام

---

##  جدول مرجعي سريع

### أوامر يومية ضرورية
| الفئة | الأوامر |
|-------|---------|
| **التنقل** | `pwd`, `ls`, `cd`, `find` |
| **الملفات** | `touch`, `cp`, `mv`, `rm`, `chmod` |
| **العرض** | `cat`, `less`, `head`, `tail` |
| **البحث** | `grep`, `find`, `locate` |
| **المعالجة** | `sort`, `uniq`, `cut`, `paste` |
| **الشبكة** | `ping`, `curl`, `wget`, `hostname` |
| **الأرشفة** | `tar`, `zip`, `gzip`, `unzip` |
| **البرمجة** | `bash`, `read`, `echo`, `if`, `for` |
| **النظام** | `ps`, `top`, `df`, `free` |

### اختصارات لوحة المفاتيح
| الاختصار | الوظيفة |
|----------|----------|
| `Tab` | إكمال تلقائي |
| `↑/↓` | تصفح تاريخ الأوامر |
| `Ctrl+C` | إيقاف الأمر |
| `Ctrl+L` | مسح الشاشة |
| `Ctrl+A` | بداية السطر |
| `Ctrl+E` | نهاية السطر |

---

## 🛡️ قواعد الأمان الذهبية

### ❌ لا تفعل أبداً:
```bash
rm -rf /                    # يحذف النظام!
chmod 777 -R /             # يعطي صلاحيات خطيرة!
curl script.sh | bash      # ينفذ نص مجهول!
```

### ✅ افعل دائماً:
```bash
pwd                         # تأكد من موقعك
ls -la                      # اعرف ما تتعامل معه
cp important.txt{,.backup}  # اعمل نسخة احتياطية
rm -i file.txt             # تأكد قبل الحذف
```

---

## 🚀 مشاريع عملية للتطبيق

### مشروع 1: منظم الملفات الشخصية
```bash
#!/bin/bash
# نص لتنظيم مجلد التنزيلات
mkdir -p ~/Downloads/{Images,Documents,Videos,Archives}
mv ~/Downloads/*.{jpg,png,gif} ~/Downloads/Images/ 2>/dev/null
mv ~/Downloads/*.{pdf,doc,txt} ~/Downloads/Documents/ 2>/dev/null
mv ~/Downloads/*.{mp4,avi,mkv} ~/Downloads/Videos/ 2>/dev/null
mv ~/Downloads/*.{zip,tar,gz} ~/Downloads/Archives/ 2>/dev/null
```

### مشروع 2: محلل السجلات
```bash
#!/bin/bash
# تحليل سجل الخادم مع معالجة النصوص
LOG="/var/log/nginx/access.log"
echo "=== تقرير يومي ==="
echo "إجمالي الطلبات: $(wc -l < $LOG)"
echo "أكثر الصفحات زيارة:"
awk '{print $7}' $LOG | sort | uniq -c | sort -nr | head -10
echo "أكثر عناوين IP نشاطاً:"
awk '{print $1}' $LOG | sort | uniq -c | sort -nr | head -5
```

### مشروع 3: نظام النسخ الاحتياطي التلقائي
```bash
#!/bin/bash
# نسخة احتياطية ذكية مع الأرشفة والضغط
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)

# نسخة احتياطية للملفات الشخصية
tar -czvf "$BACKUP_DIR/home_$DATE.tar.gz" \
    --exclude='Downloads' \
    --exclude='.cache' \
    --exclude='*.tmp' \
    /home/$(whoami)/

# تنظيف النسخ القديمة (أكثر من 30 يوم)
find $BACKUP_DIR -name "home_*.tar.gz" -mtime +30 -delete

echo "تمت النسخة الاحتياطية: home_$DATE.tar.gz"
ls -lh "$BACKUP_DIR/home_$DATE.tar.gz"
```

### مشروع 4: مراقب الشبكة والنظام
```bash
#!/bin/bash
# مراقبة شاملة للنظام والشبكة
echo "=== تقرير النظام والشبكة ==="
echo "التاريخ: $(date)"
echo "اسم الجهاز: $(hostname -f)"
echo "عنوان IP: $(hostname -i)"
echo "استخدام المعالج: $(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')"
echo "استخدام الذاكرة: $(free | grep Mem | awk '{printf("%.2f%%\n", $3/$2 * 100.0)}')"
echo "استخدام القرص: $(df -h / | grep -v Filesystem | awk '{print $5}')"

# اختبار الاتصال
echo "حالة الاتصال بالإنترنت:"
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "✅ متصل"
    echo "زمن الاستجابة: $(ping -c 1 8.8.8.8 | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')"
else
    echo "❌ غير متصل"
fi
```
---

### أنت الآن مؤهل لـ:
- **إدارة الخوادم** (Server Administration) على مستوى احترافي
- **DevOps والأتمتة** (CI/CD, Infrastructure Automation)
- **الأمان المتقدم** (Security Hardening, Monitoring)
- **الحوسبة السحابية** (Cloud Infrastructure Management)
- **الحاويات والمحاكاة الافتراضية** (Docker, Kubernetes)
- **تطوير أدوات مخصصة** للمؤسسات

### الخطوة التالية:
اختر تخصصاً محدداً وتعمق فيه:
- 🏗️ **مهندس بنية تحتية** (Infrastructure Engineer)
- 🔒 **مختص أمان** (Security Specialist)  
- ☁️ **مهندس سحابي** (Cloud Engineer)
- 🤖 **مهندس DevOps** (DevOps Engineer)
- 📊 **مهندس بيانات** (Data Engineer)


---


*آخر تحديث: ديسمبر 2024*  
*الإصدار: 2.0*
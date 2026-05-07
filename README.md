<div align="center">
  <img src="https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/school.svg" alt="EduFlow Logo" width="100" />
  
  # 🧠 EduFlow SmartAttend Pro
  
  <p><strong>نظام ذكي متكامل لإدارة الجداول المدرسية وتحضير الطلاب</strong></p>
  <p><em>Intelligent Integrated School Scheduling & Attendance Management System</em></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter_3-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/SQLite_(Drift)-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
    <img src="https://img.shields.io/badge/BLoC-5FB3B3?style=for-the-badge&logo=bloc&logoColor=white" alt="BLoC" />
    <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
  </p>

  <p>
    <a href="#-english-version">🇬🇧 English</a> · 
    <a href="#-النسخة-العربية">🌐 العربية</a>
  </p>
</div>

---

<a name="-english-version"></a>
## 🇬🇧 English Version

### 🎯 Why This Project?
Managing schools manually is a thing of the past. This project demonstrates high-level engineering skills by solving two of the most complex problems in education: **Automatic Scheduling** (using AI-driven conflict resolution) and **Contactless Attendance** (using high-speed barcode processing). It is designed as a **professional enterprise-grade portfolio piece**.

### ✨ Features
- 🧠 **AI-Driven Scheduling**: Automated generation of complex school timetables with zero conflicts between teachers, classes, and subjects.
- 📱 **QR/Barcode Attendance**: Instant student check-in system using the device camera as a professional scanner.
- 📱 **Fully Responsive UI**: A premium user experience that adapts perfectly to tablets and mobile phones.
- 📊 **Pro Reporting**: Generate high-quality PDF certificates and Excel statistics for students and management.
- ✅ **Clean Architecture**: Built using a layered architecture (Domain, Data, Presentation) for maximum scalability.
- 🌐 **Global Ready**: Full RTL support for Arabic and LTR for English with context-aware localization.

### 🛠️ Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: BLoC (Business Logic Component) & Riverpod
- **Database**: Drift (Reactive SQLite)
- **Architecture**: Clean Architecture + Repository Pattern
- **Reports**: PDF & Excel Services
- **Animations**: Flutter Animate
- **Icons**: Lucide Icons & Material Design

### 🚀 Getting Started

1. Clone the repository:
```bash
git clone https://github.com/mohannad877/EduFlow-SmartAttend-Pro-School-Management-System.git
cd EduFlow-SmartAttend-Pro-School-Management-System
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

<br />
<hr />
<br />

<a name="-النسخة-العربية"></a>
## 🌐 النسخة العربية

### 🎯 لماذا هذا المشروع؟
> 💼 **للمؤسسات والمهندسين**: إدارة المدارس والجداول هي من أكثر العمليات تعقيداً. هذا المشروع ليس مجرد تطبيق، بل هو **نظام هندسي متكامل** يحل مشكلة تعارض الحصص برمجياً ويوفر أتمتة كاملة للحضور والغياب. تم تصميمه ليكون **نموذجاً احترافياً** يُبرز قدراتك على:
> 
> ✅ بناء خوارزميات معقدة (Intelligent Scheduling)  
> ✅ استخدام Clean Architecture بمستوى الشركات الكبرى  
> ✅ معالجة البيانات الضخمة وتخزينها تفاعلياً بـ SQLite  
> ✅ إنشاء تقارير رسمية (PDF/Excel) برمجياً  
> ✅ تصميم واجهات عصرية تدعم الوضع الليلي واللغات المتعددة

### ✨ الميزات

#### 🧠 الذكاء والجدولة
| الميزة | الوصف |
|--------|-------|
| 📅 **Intelligent Scheduler** | توليد تلقائي للجداول المدرسية يمنع تضارب المدرسين أو القاعات |
| 🔄 **Conflict Resolver** | حل ذكي للتعارضات عند تعديل الجداول يدوياً |
| 📋 **Session Management** | إدارة كاملة للحصص، الفترات، وأيام الدوام الأسبوعية |

#### 📱 نظام الحضور والباركود
| الميزة | الوصف |
|--------|-------|
| 🔍 **High-Speed Scanner** | مسح فوري للباركود والـ QR لتحضير الطلاب في أجزاء من الثانية |
| 🎴 **ID Card Generator** | إمكانية طباعة بطاقات باركود للطلاب مباشرة من التطبيق |
| 🔔 **Smart Notifications** | إرسال تنبيهات تلقائية عند غياب الطالب أو تأخره |

#### 📊 التقارير والبيانات
| الميزة | الوصف |
|--------|-------|
| 📄 **PDF Reports** | إصدار تقارير حضور رسمية وجداول دراسية جاهزة للطباعة |
| 📁 **Excel Export** | تصدير إحصائيات الطلاب والنتائج إلى جداول بيانات Excel |
| ☁️ **Auto Backup** | نسخ احتياطي دوري لقاعدة البيانات لضمان عدم ضياع البيانات |

#### ⚙️ الهندسة والنظام
| الميزة | الوصف |
|--------|-------|
| 🏗️ **Clean Architecture** | كود نظيف مقسم لطبقات (Domain, Data, Presentation) |
| 🌓 **Theme Switching** | دعم كامل للوضع الليلي والنهاري (Dark/Light Mode) |
| 🌐 **i18n Professional** | ترجمة سياقية دقيقة للغتين العربية والإنجليزية |

### 🛠️ المكدس التقني (Tech Stack)

```text
✅ Framework:      Flutter 3 (Cross-Platform)
✅ Language:       Dart
✅ State Mgmt:     BLoC & Riverpod (Combined Power)
✅ Database:       Drift (SQLite) - Reactive & Fast
✅ Architecture:   Clean Architecture + Repository Pattern
✅ UI Design:      Modern UI with Glassmorphism & Micro-animations
✅ Export Tools:   PDF, Excel, & Printing Services
✅ Localization:   Context-aware ARB (Arabic/English)
```

### 🚀 التشغيل المحلي

```bash
# 1. استنساخ المستودع
git clone https://github.com/mohannad877/EduFlow-SmartAttend-Pro-School-Management-System.git
cd EduFlow-SmartAttend-Pro-School-Management-System

# 2. تحميل المكتبات
flutter pub get

# 3. توليد ملفات قاعدة البيانات والترجمة
flutter gen-l10n

# 4. تشغيل التطبيق
flutter run
```

### 📁 هيكلية المشروع

```text
lib/
├── core/               # الإعدادات العامة، الثيم، والتنقل
├── domain/             # الكيانات (Entities)، الاستخدامات (Use-cases)، والمستودعات المجردة
├── data/               # تنفيذ المستودعات، قواعد البيانات (Drift)، والموديلات
├── features/           # المميزات مقسمة برمجياً:
│   ├── attendance/     # نظام الحضور والغياب
│   ├── schedule/       # خوارزميات الجدولة والواجهات
│   ├── students/       # إدارة الطلاب والصفوف
│   └── reports/        # خدمات تصدير PDF/Excel
└── presentation/       # إدارة الحالة (BLoC) والواجهات الرسومية
```

---

## 🤝 المساهمة | Contributing
المساهمات مرحب بها! افتح Pull Request إذا كان لديك إضافة رائعة.

## 📄 الرخصة | License
هذا المشروع مفتوح المصدر تحت [رخصة MIT](LICENSE).

## 📬 تواصل معي | Connect With Me

<div align="center">

**Mohannad Nabil Ahmed Mohammed Abdullah**  
📍 Ibb – Yemen | 📱 +967 777 354 821

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/mohannadnabil)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mohannad877)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mohannad.nabil.it@gmail.com)

</div>

---

<div align="center">
  <p>
    <strong>صُنع بـ ❤️ لخدمة التعليم والابتكار برمجياً 🌍</strong><br />
    Developed with ❤️ by <a href="https://github.com/mohannad877">Mohannad Nabil</a>
  </p>
  
  <p>
    <sub>⭐ إذا أعجبك المشروع، لا تنسَ إضافة نجمة على GitHub! ⭐</sub>
  </p>
</div>

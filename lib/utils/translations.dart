import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const Map<String, String> _en = {
    'app_title': 'Expense Tracker',
    'login': 'Login',
    'register': 'Register',
    'logout': 'Logout',
    'email': 'Email',
    'password': 'Password',
    'name': 'Name',
    'dashboard': 'Dashboard',
    'settings': 'Settings',
    'language': 'Language',
    'dark_mode': 'Dark Mode',
    'add_expense': 'Add Expense',
    'amount': 'Amount',
    'date': 'Date',
    'category': 'Category',
    'payment_method': 'Payment Method',
    'save': 'Save',
    'cancel': 'Cancel',
    'no_data': 'No data available',
    'total': 'Total',
    'welcome': 'Welcome',
    'invalid_credentials': 'Invalid credentials',
    'create_account': 'Create an account',
    'forgot_password': 'Forgot password?',
    'search': 'Search',
  };

  static const Map<String, String> _ar = {
    'app_title': 'متتبع المصاريف',
    'login': 'تسجيل الدخول',
    'register': 'إنشاء حساب',
    'logout': 'تسجيل الخروج',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'name': 'الاسم',
    'dashboard': 'اللوحة',
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'dark_mode': 'الوضع الداكن',
    'add_expense': 'إضافة مصروف',
    'amount': 'المبلغ',
    'date': 'التاريخ',
    'category': 'الفئة',
    'payment_method': 'طريقة الدفع',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'no_data': 'لا توجد بيانات',
    'total': 'الإجمالي',
    'welcome': 'مرحبًا',
    'invalid_credentials': 'بيانات اعتماد غير صحيحة',
    'create_account': 'أنشئ حسابًا',
    'forgot_password': 'هل نسيت كلمة المرور؟',
    'search': 'بحث',
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'ar': _ar,
      };
}

import 'package:get/get.dart';
import 'app_routes.dart';
import 'auth_middleware.dart';

// Import real views
import '../views/splash_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/dashboard_view.dart';
import '../views/add_expense_view.dart';
import '../views/categories_view.dart';
import '../views/payment_methods_view.dart';
import '../views/settings_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addExpense,
      page: () => const AddExpenseView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.paymentMethods,
      page: () => const PaymentMethodsView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

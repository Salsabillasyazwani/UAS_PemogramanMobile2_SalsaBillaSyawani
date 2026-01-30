import 'package:get/get.dart';
import '../../fitur/auth/login_page.dart';
import '../../fitur/auth/register_page.dart';
import '../../fitur/auth/splash_page.dart';
import '../../fitur/dashboard/dashboard_page.dart';
import '../../fitur/product/product_form_page.dart';
import '../../fitur/product/product_list_page.dart';
import '../../fitur/product/update_produk_page.dart';
import '../../fitur/hpp/hpp_page.dart';
import '../../fitur/transaksi/transaksi_page.dart';
import '../../fitur/transaksi/order_page.dart';
import '../../fitur/transaksi/struk_page.dart';
import '../../fitur/profile/profile_page.dart';
import '../../fitur/report/report_page.dart';
import '../../fitur/report/date_range_page.dart';
import '../../fitur/profile/change_password_page.dart';
import '../../fitur/profile/edit_profile_page.dart';
import '../../fitur/profile/EditAddressPage.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const productList = '/product-list';
  static const productForm = '/product-form';
  static const transaksi = '/transaksi';
  static const order = '/order';
  static const struk = '/struk';
  static const hpp = '/hpp';
  static const report = '/report';
  static const dateRange = '/date-range';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const editAddress = '/edit-address';
  static const changePassword = '/change-password';

  static final routes = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(name: dashboard, page: () => DashboardPage()),
    GetPage(name: productList, page: () => const ProductListPage()),
    GetPage(name: productForm, page: () => ProductFormPage()),
    GetPage(
      name: '/update-produk',
      page: () => UpdateProdukPage(productData: Get.arguments),
    ),
    GetPage(name: hpp, page: () => HppPage()),
    GetPage(name: transaksi, page: () => TransaksiPage()),
    GetPage(name: order, page: () => OrderPage()),
    GetPage(name: struk, page: () => StrukPage()),
    GetPage(name: report, page: () => const ReportPage()),
    GetPage(name: dateRange, page: () => const DateRangePage()),
    GetPage(name: profile, page: () => ProfilePage()),
    GetPage(name: editAddress, page: () => const EditAddressPage()),
    GetPage(name: editProfile, page: () => EditProfilePage()),
    GetPage(name: changePassword, page: () => ChangePasswordPage()),
  ];
}

import 'package:get/get.dart';
import '../fitur/auth/auth_controller.dart';
import '../fitur/dashboard/dashboard_controller.dart';
import '../fitur/product/product_controller.dart';
import '../fitur/product/product_form_controller.dart';
import '../fitur/hpp/hpp_controller.dart';
import '../fitur/transaksi/transaksi_controller.dart';
import '../fitur/profile/profile_controller.dart';
import '../fitur/report/report_controller.dart';
import '../data/services/auth_service.dart';
import '../data/services/profile_service.dart';
import '../data/services/product_service.dart';
import '../data/services/report_service.dart';
import '../data/services/transaksi _service.dart';
import '../data/services/hpp_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => ProfileService(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ProductFormController(), fenix: true);
    Get.lazyPut(() => HppController(), fenix: true);
    Get.lazyPut(() => TransaksiController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => ReportService(), fenix: true);
    Get.lazyPut(() => ProductService(), fenix: true);
    Get.lazyPut(() => TransaksiService(), fenix: true);
    Get.lazyPut(() => HppService(), fenix: true);
  }
}

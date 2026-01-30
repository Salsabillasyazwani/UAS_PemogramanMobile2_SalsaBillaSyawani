import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/transaksi _service.dart';
import '../../data/services/report_service.dart';

class DashboardController extends GetxController {
  final TransaksiService _transaksiService = TransaksiService();
  final ReportService _reportService = ReportService();
  final SupabaseClient _supabase = Supabase.instance.client;

  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  var produkTerjualHariIni = "0".obs;
  var produkTerjualBulanIni = "0".obs;
  var omsetHariIni = "Rp.0".obs;
  var omsetBulanIni = "Rp.0".obs;
  var listProdukTerlaris = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  String get _currentUserId => _supabase.auth.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      final salesToday = await _transaksiService.getTotalSalesToday();
      produkTerjualHariIni.value = salesToday.toString();

      final salesMonth = await _transaksiService.getTotalSalesThisMonth();
      produkTerjualBulanIni.value = salesMonth.toString();

      final revenueToday = await _transaksiService.getRevenueToday();
      omsetHariIni.value = formatCurrency(revenueToday);

      final revenueMonth = await _transaksiService.getRevenueThisMonth();
      omsetBulanIni.value = formatCurrency(revenueMonth);

      final bestSelling = await _reportService.getBestSellingProducts(
        userId: _currentUserId,
        limit: 10,
      );

      listProdukTerlaris.assignAll(
        bestSelling.map((item) {
          return {
            'nama': item['nama'].toString(),
            'harga': item['harga'].toString(),
            'terjual': item['terjual'].toString(),
          };
        }).toList(),
      );
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  @override
  void onReady() {
    super.onReady();
    refreshDashboard();
  }
}

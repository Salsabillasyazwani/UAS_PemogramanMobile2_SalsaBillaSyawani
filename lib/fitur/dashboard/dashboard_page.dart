import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'widgets/summary_card.dart';
import 'widgets/action_menu_item.dart';
import 'widgets/product_list_item.dart';
import '../../core/widgets/animated_navbar.dart';
import '../product/product_form_page.dart';
import '../product/product_list_page.dart';
import '../hpp/hpp_page.dart';
import '../transaksi/transaksi_page.dart';
import '../profile/profile_page.dart';
import '../report/report_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final List<Widget> bodyPages = [
      _buildDashboardHome(controller),
      TransaksiPage(),
      ReportPage(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Obx(
        () =>
            IndexedStack(index: controller.tabIndex.value, children: bodyPages),
      ),
      bottomNavigationBar: Obx(
        () => AnimatedNavBar(
          currentIndex: controller.tabIndex.value,
          onTap: (index) {
            controller.changeTabIndex(index);
          },
        ),
      ),
    );
  }

  Widget _buildDashboardHome(DashboardController controller) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Produk terjual\nhari ini',
                          value: controller.produkTerjualHariIni.value,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SummaryCard(
                          title: 'Produk terjual\nbulan ini',
                          value: controller.produkTerjualBulanIni.value,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Obx(
                  () => Column(
                    children: [
                      SummaryCard(
                        title: 'Omset hari ini',
                        value: controller.omsetHariIni.value,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: 10),
                      SummaryCard(
                        title: 'Omset bulan ini',
                        value: controller.omsetBulanIni.value,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Menu Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionMenuItem(
                      icon: Icons.add_circle_outline,
                      label: 'Input\nProduk',
                      onTap: () {
                        Get.to(() => ProductFormPage());
                      },
                    ),
                    ActionMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Produk',
                      onTap: () {
                        Get.to(() => ProductListPage());
                      },
                    ),
                    ActionMenuItem(
                      icon: Icons.calculate_outlined,
                      label: 'Hpp',
                      onTap: () {
                        Get.to(() => HppPage());
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  'Produk terlaris',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),

                // List Produk Terlaris
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.listProdukTerlaris.length,
                    itemBuilder: (context, index) {
                      var item = controller.listProdukTerlaris[index];
                      return ProductListItem(
                        name: item['nama']!,
                        price: item['harga']!,
                        sold: item['terjual']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget Header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 43, left: 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF800A0A), Color(0xFF4A0505)],
        ),
      ),
      child: const Text(
        'Dasboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

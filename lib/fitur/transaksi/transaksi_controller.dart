import 'package:get/get.dart';
import '../../data/services/transaksi _service.dart';
import '../../data/services/product_service.dart';

class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.quantity = 0,
  });

  double get total => price * quantity;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      quantity: 0,
    );
  }
}

class TransaksiController extends GetxController {
  final TransaksiService _transaksiService = TransaksiService();
  final ProductService _productService = ProductService();
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingProducts = false.obs;

  List<Product> strukProducts = [];
  double strukTotal = 0;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoadingProducts.value = true;
      final productList = await _productService.getAllProducts();

      products.value = productList
          .map((json) => Product.fromJson(json))
          .toList();
      filteredProducts.assignAll(products);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void addProduct(String id) {
    try {
      final product = products.firstWhere((p) => p.id == id);

      if (product.stock <= 0) {
        Get.snackbar('Stok Habis', 'Stok ${product.name} habis');
        return;
      }

      if (product.quantity >= product.stock) {
        Get.snackbar('Stok Limit', 'Maksimal stok tercapai');
        return;
      }

      product.quantity++;
      products.refresh();
      filteredProducts.refresh();
    } catch (e) {
      print("Produk tidak ditemukan: $e");
    }
  }

  void removeProduct(String id) {
    try {
      final product = products.firstWhere((p) => p.id == id);
      if (product.quantity > 0) {
        product.quantity--;
        products.refresh();
        filteredProducts.refresh();
      }
    } catch (e) {
      print("Produk tidak ditemukan: $e");
    }
  }

  List<Product> get selectedProducts =>
      products.where((p) => p.quantity > 0).toList();
  int get totalProducts => products.fold(0, (sum, p) => sum + p.quantity);
  double get totalPrice => products.fold(0.0, (sum, p) => sum + p.total);
  void saveStrukSnapshot() {
    strukProducts = selectedProducts
        .map(
          (p) => Product(
            id: p.id,
            name: p.name,
            price: p.price,
            stock: p.stock,
            quantity: p.quantity,
          ),
        )
        .toList();
    strukTotal = totalPrice;
  }

  Future<bool> processTransaction() async {
    if (selectedProducts.isEmpty) {
      Get.snackbar('Peringatan', 'Keranjang masih kosong');
      return false;
    }

    isLoading.value = true;
    try {
      final items = selectedProducts
          .map(
            (p) => {
              'product_id': p.id,
              'product_name': p.name,
              'quantity': p.quantity,
              'price': p.price,
            },
          )
          .toList();

      final result = await _transaksiService.createTransaction(
        items: items,
        paymentMethod: 'Tunai',
      );

      if (result['success'] == true) {
        saveStrukSnapshot();
        Get.snackbar('Berhasil', result['message'] ?? 'Transaksi Berhasil');
        await loadProducts();
        return true;
      } else {
        Get.snackbar('Gagal', result['message'] ?? 'Transaksi Gagal');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan sistem');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetTransaction() {
    for (var p in products) {
      p.quantity = 0;
    }
    products.refresh();
    filteredProducts.refresh();
  }
}

class ProductReport {
  final String id;
  final String userId;
  final String nama;
  final String kategori;
  final String satuan;
  final int harga;
  final int stok;
  final String mfg;
  final String exp;

  ProductReport({
    required this.id,
    required this.userId,
    required this.nama,
    required this.kategori,
    required this.satuan,
    required this.harga,
    required this.stok,
    required this.mfg,
    required this.exp,
  });
}

class MutationReport {
  final String tanggal;
  final String userId;
  final String idProduk;
  final String namaProduk;
  final String jenis;
  final int jumlah;

  MutationReport({
    required this.tanggal,
    required this.userId,
    required this.idProduk,
    required this.namaProduk,
    required this.jenis,
    required this.jumlah,
  });
}

class TransactionReport {
  final String id;
  final String userId;
  final String tanggal;
  final String metodeBayar;
  final int totalItem;
  final int totalHarga;

  TransactionReport({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.metodeBayar,
    required this.totalItem,
    required this.totalHarga,
  });
}

class HppReport {
  final String tanggal;
  final String userId;
  final String? productName;
  final int totalHpp;
  final int perUnit;
  final int jual;
  final int jualPajak;
  final int margin;

  HppReport({
    required this.tanggal,
    required this.userId,
    this.productName,
    required this.totalHpp,
    required this.perUnit,
    required this.jual,
    required this.jualPajak,
    required this.margin,
  });
}

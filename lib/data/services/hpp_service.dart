import 'package:supabase_flutter/supabase_flutter.dart';

class HppService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>?> saveHppCalculation({
    required String productName,
    required double quantityProduction,
    required List<Map<String, dynamic>> bahanBaku,
    required List<Map<String, dynamic>> tenagaKerja,
    required List<Map<String, dynamic>> overhead,
    required double totalBahanBaku,
    required double totalTenagaKerja,
    required double totalOverhead,
    required double biayaTakTerduga,
    required double persentaseTakTerduga,
    required double totalHpp,
    required double hppPerUnit,
    required double hargaJualPerUnit,
    required double hargaJualPajak,
    required double marginValue,
    required double pajak,
    required double margin,
    required bool marginInRupiah,
    required bool useBiayaTakTerduga,
  }) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final existing = await _supabase
          .from('hpp_calculations')
          .select('id')
          .eq('user_id', _currentUserId!)
          .eq('product_name', productName)
          .gte('created_at', startOfDay.toIso8601String())
          .lte('created_at', endOfDay.toIso8601String())
          .maybeSingle();

      final data = {
        'user_id': _currentUserId,
        'product_name': productName,
        'quantity_production': quantityProduction,
        'total_bahan_baku': totalBahanBaku,
        'total_tenaga_kerja': totalTenagaKerja,
        'total_overhead': totalOverhead,
        'biaya_tak_terduga': biayaTakTerduga,
        'persentase_tak_terduga': persentaseTakTerduga,
        'total_hpp': totalHpp,
        'hpp_per_unit': hppPerUnit,
        'harga_jual_per_unit': hargaJualPerUnit,
        'harga_jual_pajak': hargaJualPajak,
        'margin_value': marginValue,
        'pajak': pajak,
        'margin': margin,
        'margin_in_rupiah': marginInRupiah,
        'use_biaya_tak_terduga': useBiayaTakTerduga,
        'updated_at': now.toIso8601String(),
      };

      String hppId;

      if (existing != null) {
        hppId = existing['id'];
        await _supabase.from('hpp_calculations').update(data).eq('id', hppId);
        await _supabase.from('hpp_bahan_baku').delete().eq('hpp_id', hppId);
        await _supabase.from('hpp_tenaga_kerja').delete().eq('hpp_id', hppId);
        await _supabase.from('hpp_overhead').delete().eq('hpp_id', hppId);
      } else {
        data['created_at'] = now.toIso8601String();
        final result = await _supabase
            .from('hpp_calculations')
            .insert(data)
            .select('id')
            .single();
        hppId = result['id'];
      }

      if (bahanBaku.isNotEmpty) {
        final bahanBakuData = bahanBaku
            .map(
              (item) => {
                'hpp_id': hppId,
                'user_id': _currentUserId,
                'nama': item['nama'],
                'harga': item['harga'],
              },
            )
            .toList();
        await _supabase.from('hpp_bahan_baku').insert(bahanBakuData);
      }

      if (tenagaKerja.isNotEmpty) {
        final tenagaKerjaData = tenagaKerja
            .map(
              (item) => {
                'hpp_id': hppId,
                'user_id': _currentUserId,
                'nama': item['nama'],
                'harga': item['harga'],
                'satuan': item['satuan'],
              },
            )
            .toList();
        await _supabase.from('hpp_tenaga_kerja').insert(tenagaKerjaData);
      }

      if (overhead.isNotEmpty) {
        final overheadData = overhead
            .map(
              (item) => {
                'hpp_id': hppId,
                'user_id': _currentUserId,
                'nama': item['nama'],
                'harga': item['harga'],
                'satuan': item['satuan'],
              },
            )
            .toList();
        await _supabase.from('hpp_overhead').insert(overheadData);
      }

      return {'id': hppId};
    } catch (e) {
      print('Error saving HPP calculation: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllHppCalculations() async {
    try {
      if (_currentUserId == null) return [];
      final response = await _supabase
          .from('hpp_calculations')
          .select('*, hpp_bahan_baku(*), hpp_tenaga_kerja(*), hpp_overhead(*)')
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting HPP calculations: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getHppById(String id) async {
    try {
      if (_currentUserId == null) return null;
      final response = await _supabase
          .from('hpp_calculations')
          .select('*, hpp_bahan_baku(*), hpp_tenaga_kerja(*), hpp_overhead(*)')
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .single();

      return response;
    } catch (e) {
      print('Error getting HPP by ID: $e');
      return null;
    }
  }

  Future<bool> deleteHpp(String id) async {
    try {
      if (_currentUserId == null) return false;
      await _supabase
          .from('hpp_calculations')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId!);
      return true;
    } catch (e) {
      print('Error deleting HPP: $e');
      return false;
    }
  }
}

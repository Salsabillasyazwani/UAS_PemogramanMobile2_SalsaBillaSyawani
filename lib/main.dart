import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/routes/app_routes.dart';
import 'bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bisypslsbjesbloofbje.supabase.co',
    anonKey: 'sb_publishable_SotVQ1F1FjSlFY1ao6MnZQ_pkTKOM1p',
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    if (session != null) {
      Get.offAllNamed(AppRoutes.dashboard);
    }
  });

  runApp(const MyApp());
}

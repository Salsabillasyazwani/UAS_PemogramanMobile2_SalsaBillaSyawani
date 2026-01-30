import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://bisypslsbjesbloofbje.supabase.co',
    anonKey: 'sb_publishable_SotVQ1F1FjSlFY1ao6MnZQ_pkTKOM1p',
  );
  runApp(const MyApp());
}

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'providers/tasbih_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// INIT LOCALE INDONESIA
  await initializeDateFormatting(
    'id_ID',
    null,
  );

  runApp(
    MultiProvider(
      providers: [
        /// TASBIH PROVIDER
        ChangeNotifierProvider(
          create: (_) => TasbihProvider(),
        ),

        /// THEME PROVIDER
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
        ),
      ],
      child: const DzikrTasbih(),
    ),
  );
}

import 'package:e_contrat/page/grid.dart';
import 'package:e_contrat/page/home.dart';
import 'package:e_contrat/core/theme/app_theme.dart';
import 'package:e_contrat/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
  
 main() async {
   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (_) {}
  configureDependencies();
  registerFeatureDependencies();
  runApp(const Econtrat());
}

class Econtrat extends StatelessWidget {
  const Econtrat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(context),
      darkTheme: AppTheme.dark(context),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR')
      ],
      routes: {
        '/grid': (context) => const Grid(),
      },
      title: 'E-contrat',
      home: const MyHomePage(),
    );
  }
}

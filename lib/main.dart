import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebas_pruebas/presentation/home_page.dart';
import 'package:pruebas_pruebas/providers/datos_placa_provider.dart';
import 'package:pruebas_pruebas/providers/imagen_provider.dart';
import 'package:pruebas_pruebas/providers/text_placa_provider.dart';
import 'package:pruebas_pruebas/providers/username_text_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ImagenProvider>(create: (_) => ImagenProvider()),
      ChangeNotifierProvider<TextPlacaProvider>(create: (_) => TextPlacaProvider()),
      ChangeNotifierProvider<UserNameTextProvider>(create: (_) => UserNameTextProvider()),
      ChangeNotifierProvider<DatosPlacaProvider>(create: (_) => DatosPlacaProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 40, 101, 205))),
    );
  }
}

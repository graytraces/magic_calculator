import 'package:flutter/material.dart';
import 'package:simple_magic_calculator/screens/calculator_screen.dart';
import 'package:simple_magic_calculator/viewmodels/calculator_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CalculatorViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.cyan)),
      themeMode: ThemeMode.dark,
      home: CalculatorScreen(),
    );
  }
}

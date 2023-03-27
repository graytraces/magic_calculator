import 'package:flutter/material.dart';
import 'package:magic_calculator_app/screens/note_like_screen.dart';
import 'package:magic_calculator_app/viewmodels/calculator_viewmodel.dart';
import 'package:provider/provider.dart';
import 'app_stat_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (BuildContext context) => AppStatProvider()),
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
      home: NoteLikeScreen(Provider.of<AppStatProvider>(context, listen: false)),
    );
  }
}

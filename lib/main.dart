import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/providers/home_provider.dart';
import 'package:smart_home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize provider
  final homeProvider = HomeProvider();
  await homeProvider.init();

  runApp(
    ChangeNotifierProvider<HomeProvider>.value(
      // Specify type
      value: homeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Умный дом',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          primary: const Color(0xFF2ECC71),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

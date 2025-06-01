import 'package:cleanify/env_config.dart';
import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/pages/onboardingpage.dart';
import 'package:cleanify/pages/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_methods/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 61, 217, 136)),
          inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          bottomAppBarTheme:
              const BottomAppBarTheme(shape: CircularNotchedRectangle())),
      home: StreamBuilder(
          stream: Auth().authStateChanges,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return const MainTabBar();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const OnboardingPage();
          })),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'package:cleanify/pages/homepage.dart';
//
//void main() {
//  runApp(const MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  const MyApp({super.key});
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//        theme: ThemeData(
//            colorScheme: ColorScheme.fromSeed(
//                seedColor: const Color.fromARGB(255, 39, 247, 139)),
//            useMaterial3: true),
//        home: const MyHomePage(title: 'Cleanify'));
//  }
//}

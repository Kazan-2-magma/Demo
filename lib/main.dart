import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'View/auth_View.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp (MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "my app",
    home: AuthPage(),
  ));
    //(const MyApp());
}

/*class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
      ),

    );
  }
}*/





import 'package:cinq_etoils/Model/FirebaseServiceUser.dart';
import 'package:cinq_etoils/View/pagesAdmin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginView.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseServiceUser firebaseService=FirebaseServiceUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return pagesAdmin();
          }
          else{
            return LoginView(firebaseService: firebaseService);
          }
        },

      ),


    );
  }
}
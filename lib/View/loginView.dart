import 'package:cinq_etoils/Model/Users.dart';
import 'package:cinq_etoils/View/pagesAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/FirebaseServiceUser.dart';
import '../Model/regexvalid.dart';
import '../style/colors.dart';
import 'DialogView/CustomSnackBar.dart';

class LoginView extends StatefulWidget {
  final FirebaseServiceUser firebaseService;

  const LoginView({super.key, required this.firebaseService});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Form(
              key: _formkey,
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ClipOval(
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image.asset(
                        'assets/logo/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      height: 450,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                           BoxShadow(
                            color: AppColors.bleu,
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: Offset(3, 1),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Connexion Admin",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: AppColors.bleu,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                              ),
                              child: TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Vous devez entrer l'Email";
                                  } else if (!Validator.isValidEmail(value)) {
                                    return "Entre un forme d'é-mail valide";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    color: AppColors.bleu,
                                  ),
                                  labelText: 'Email',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.bleu,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.bleu,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.rouge,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.rouge,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: AppColors.bleu,
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 300,
                              decoration: const BoxDecoration(
                              ),
                              child: TextFormField(
                                controller: password,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Vous devez entrer Mot de passe";
                                  }
                                  return null;
                                },
                                obscureText: !visible,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                    color: AppColors.bleu,
                                  ),
                                  labelText: 'Mot de passe',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.bleu,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.bleu,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.rouge,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.rouge,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColors.bleu,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      color: Colors.blue,
                                      visible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        visible = !visible;
                                      });
                                    },
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    _formkey.currentState!.save();
                                    singUserIn();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Ink(
                                  child: const Text(
                                    'Connecter',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  void singUserIn() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      List<Userapp> user = await widget.firebaseService.rechercheUserParEmailEtPassword(email.text, password.text);

      if (user.isNotEmpty) {
        String roleuser = user.first.role;
        if (roleuser == "admin") {
          String? signInResult = await widget.firebaseService.signInWithEmailAndPassword(email.text, password.text);

          if (signInResult == null) {
            CustomSnackBar.showCustomSnackBar(context, "Succès", "Vous êtes connecté", AppColors.vert, Icons.done);

          } else {
            CustomSnackBar.showCustomSnackBar(context, "Erreur", signInResult, AppColors.rouge, Icons.error);
          }
        } else {
          CustomSnackBar.showCustomSnackBar(context, "Erreur", "Cette application est réservée aux administrateurs.", AppColors.rouge, Icons.error);
        }
      } else {
        CustomSnackBar.showCustomSnackBar(context, "Erreur", "Aucun utilisateur trouvé pour cet e-mail.", AppColors.rouge, Icons.error);
      }
    } catch (e) {
      print("Une erreur s'est produite lors de la connexion de l'utilisateur : $e");
    } finally {
      // Fermez la boîte de dialogue de chargement
      Navigator.pop(context);
    }
  }

}

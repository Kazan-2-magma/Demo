import 'package:flutter/material.dart';

import '../../Model/FirebaseServiceProjet.dart';
import '../../Model/Projets.dart';
import '../../style/colors.dart';
import '../../Model/regexvalid.dart';
import 'CustomSnackBar.dart';

class ajouteProjets extends StatefulWidget {
  final FirebaseServiceProjet firebaseService;
  const ajouteProjets({super.key, required this.firebaseService});

  @override
  State<ajouteProjets> createState() => _ajouteProjetsState();
}

class _ajouteProjetsState extends State<ajouteProjets> {
  final _formKey = GlobalKey<FormState>();
  final Projet _projet = Projet(id: '', nomProjet: '', numeroTelephone: '', email: '', photoUrl: '', projetUrl: '');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      padding: const EdgeInsets.symmetric(horizontal:40,vertical: 10 ),
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent),
                        color: AppColors.bleu
                      ),
                    child: Title(color: AppColors.bleu, child: const Text("Ajouter Projet",style: TextStyle(color: AppColors.blanc,fontSize: 20),))),
              const SizedBox(height: 10,),
              TextFormField(
                onSaved: (value) {
                  _projet.nomProjet = value!;
                },
                validator: (value){
                  if (value!.isEmpty) {
                    return "Vous devez entrer le nom";
                  }
                  return null;
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Nom de Projet',
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.business_center,color: AppColors.bleu,),
                  ),
                ),
              const SizedBox(height: 10,),
              TextFormField(
                onSaved: (value) {
                  _projet.numeroTelephone = value!;
                },
                validator: (value){
                  if (value!.isEmpty) {
                    return "Vous devez entrer telephone";
                  }else if(!Validator.isValidPhoneNumber(value)){
                    return "Entrez le téléphone comme ceci'0 et{9 N}'";
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Tele professionnel',
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.phone,color: AppColors.bleu,),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                onSaved: (value) {
                  _projet.email = value!;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if (value!.isEmpty) {
                    return "Vous devez entrer l'Email";
                  }else if(!Validator.isValidEmail(value)){
                    return "Entre un forme d'é-mail valide";
                  }
                  return null;
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Email professionnel',
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.email,color: AppColors.bleu,),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                onSaved: (value) {
                  _projet.projetUrl = value!;
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'URL Avis',
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.link,color: AppColors.bleu,),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      label: const Text("annuler"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.rouge,
                          foregroundColor: AppColors.blanc,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  Flexible(
                    child: ElevatedButton.icon(
                      label: const Text("Ajouter"),
                      onPressed: () { if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        // Call the method to add the project using FirebaseService
                        widget.firebaseService.ajouterProjet(_projet);
                        Navigator.of(context).pop();
                        CustomSnackBar.showCustomSnackBar(context, "Succès", "Le projet est bien ajouté", AppColors.vert, Icons.done);
                      }

                      },
                      icon: const Icon(Icons.add_business),
                      style: ElevatedButton.styleFrom(

                          backgroundColor: AppColors.vert,
                          foregroundColor: AppColors.blanc,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

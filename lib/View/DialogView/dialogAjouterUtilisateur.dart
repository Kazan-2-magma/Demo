import 'package:flutter/material.dart';

import '../../Model/FirebaseServiceProjet.dart';
import '../../Model/FirebaseServiceUser.dart';
import '../../Model/Projets.dart';
import '../../Model/Users.dart';
import '../../Model/regexvalid.dart';
import '../../style/colors.dart';
import 'CustomSnackBar.dart';

class ajouteUtilisateur extends StatefulWidget {
  const ajouteUtilisateur({super.key});

  @override
  State<ajouteUtilisateur> createState() => _ajouteUtilisateurState();
}

class _ajouteUtilisateurState extends State<ajouteUtilisateur> {
  TextEditingController  firstNameController=TextEditingController();
  TextEditingController  lastNameController=TextEditingController();
  TextEditingController  phoneNumberController=TextEditingController();
  TextEditingController  emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late BuildContext dialogContext;
  bool visible = false;
  bool visible2 = false;
  String _selectedRole = 'admin';
  String? selectedProjectId;
  List<Projet> projects = []; // List to store projects

  @override
  void initState() {
    super.initState();
    fetchProjects(); // Fetch projects when the widget initializes
  }

  // Method to fetch projects
  void fetchProjects() async {
    FirebaseServiceProjet firebaseService = FirebaseServiceProjet();
    firebaseService.getProjets().listen((List<Projet> fetchedProjects) {
      setState(() {
        projects = fetchedProjects;
        // Set the default project here
        if (_selectedRole!='admin') {
          selectedProjectId =
              projects.first.id; // Select the first project by default
        }
      });
    });
  }



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
                  padding: const EdgeInsets.symmetric(horizontal:35,vertical: 10 ),
                  decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.bleu
                  ),
                  child: Title(color: AppColors.bleu, child: const Text("Ajouter Utilisateur ",style: TextStyle(color: AppColors.blanc,fontSize: 25),))),
              const SizedBox(height: 10,),
              TextFormField(
               controller: lastNameController,
                validator: (value){
                  if (value!.isEmpty) {
                    return 'Vous devez entrer le nom';
                  }
                  return null;
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Nom',
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
                  prefixIcon: const Icon(Icons.person,color: AppColors.bleu,),

                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: firstNameController,
                validator: (value){
                  if (value!.isEmpty) {
                    return 'Vous devez entrer le prenom';
                  }
                  return null;
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Prenom',
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
                  prefixIcon: const Icon(Icons.person,color: AppColors.bleu,),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
               controller: phoneNumberController,
                validator: (value){
                  if (value!.isEmpty) {
                    return "Vous devez entrer telephone";
                  }else if(!Validator.isValidPhoneNumber(value)){
                    return "Entrez le téléphone comme ceci'0 et{9 N}'";
                  }
                  return null;
                },
                obscureText: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Telephone',
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
                controller: emailController,
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.email,color: AppColors.bleu,),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vous devez entrer le mot de passe';
                  } else if (!Validator.isValidPassword(value)) {
                    return 'Le mot de passe doit contenir : \n'
                        '* Au moins une majuscule\n'
                        '* Au moins une minuscule\n'
                        '* Au moins un chiffre\n'
                        '* Au moins un caractère spécial\n'
                        '* Au moins 8 caractères';
                  } else {
                    return null; // Mot de passe valide
                  }
                },
                obscureText: !visible,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
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
                  contentPadding: const EdgeInsets.all(12),
                  prefixIcon: const Icon(Icons.lock,color: AppColors.bleu,),
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.blue,
                      visible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                validator: (value){
                if (value!.isEmpty) {
                  return 'Vous devez Confirmer votre Mot de passe';
                }else if(value!=passwordController.text){
                  return 'la confirmation incorrecte';
                }
                return null;
              },
                obscureText: !visible2,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: AppColors.bleu,
                  ),
                  labelText: 'Confirmer votre Mot de passe',
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
                  prefixIcon: const Icon(Icons.lock,color: AppColors.bleu,),
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.blue,
                      visible2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        visible2 = !visible2;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Radio(
                    fillColor: MaterialStateColor.resolveWith((states) => AppColors.bleu),
                    focusColor: MaterialStateColor.resolveWith((states) => AppColors.bleu),
                    value: 'admin',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedProjectId="";
                        _selectedRole= value!;
                      });
                    },
                  ),const Text('Admin',style: TextStyle(color: AppColors.bleu,fontSize: 20,fontWeight: FontWeight.bold),),
                  const SizedBox(width: 20,),
                  Radio(

                    fillColor: MaterialStateColor.resolveWith((states) => AppColors.bleu),
                    focusColor: MaterialStateColor.resolveWith((states) => AppColors.bleu),
                    value: 'partenaire',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),const Text('Partenaire' ,style: TextStyle(color: AppColors.bleu,fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
              if (_selectedRole == 'partenaire')
                DropdownButtonFormField<String>(
                  value: selectedProjectId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProjectId = newValue;
                    });
                  },
                  items: projects.map((Projet projet) {
                    return DropdownMenuItem<String>(
                      value: projet.id,
                      child: Text(projet.nomProjet),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: AppColors.bleu,
                    ),
                    labelText: 'Projet',
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
                    contentPadding: const EdgeInsets.all(12),
                    prefixIcon: const Icon(Icons.business_center,color: AppColors.bleu,),

                  ),
                  iconSize: 30,
                  iconEnabledColor: AppColors.bleu,
                  iconDisabledColor: AppColors.bleu,
                  style: const TextStyle(color: AppColors.bleu,fontSize:20 ),
                ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  ElevatedButton.icon(
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
                  const SizedBox(width: 40,),
                  ElevatedButton.icon(
                    label: const Text("Ajouter"),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        // Form is valid, proceed with user creation and storage
                        // Create a Userapp object with form data
                        Userapp user = Userapp(
                          id_user: '', // Generate or assign a unique ID for the user
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          phoneNumber: phoneNumberController.text,
                          email: emailController.text,
                          photoUrl: '', // You can add functionality to upload and store a photo if needed
                          idProjet: selectedProjectId ?? '', // Assign the selected project ID if available
                          role: _selectedRole,
                          password: passwordController.text,
                        );

                        // Call the method from FirebaseServiceUser to register the user
                        FirebaseServiceUser firebaseServiceUser = FirebaseServiceUser();
                        firebaseServiceUser.registerWithEmailAndPassword(emailController.text, passwordController.text, user).then((result) {
                          if (result == null) {
                            // Registration successful, display a success message or navigate to another screen
                            CustomSnackBar.showCustomSnackBar(context, "Succès", "L'utilisateur est bien ajouté", Colors.green, Icons.done);
                            Navigator.of(context).pop(); // Close the dialog after successful registration
                          } else {
                            // Registration failed, display an error message
                            CustomSnackBar.showCustomSnackBar(context, "erreur", result, AppColors.rouge, Icons.error);
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vert,
                        foregroundColor: AppColors.blanc,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
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

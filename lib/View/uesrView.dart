import 'package:cinq_etoils/Model/FirebaseServiceUser.dart';
import 'package:cinq_etoils/Model/Users.dart';
import 'package:flutter/material.dart';

import '../Model/regexvalid.dart';
import '../style/colors.dart';
import 'DialogView/CustomSnackBar.dart';
import 'DialogView/dialogAjouterUtilisateur.dart';

class userView extends StatefulWidget {
  const userView({super.key,});

  @override
  State<userView> createState() => _userViewState();
}

class _userViewState extends State<userView> {
  final FirebaseServiceUser firebaseService=FirebaseServiceUser();
  List<Userapp> _allUsers = [];
  List<Userapp> _Users= [];
  final TextEditingController _searchController = TextEditingController();
  String indexG="";
  String indexmdp="";


  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<Userapp> userslist = await firebaseService.getUsers().first;
    setState(() {
      _Users = userslist;
      _allUsers = List.from(userslist);
    });
  }

  /*void _searchProjects(String query) async {
    if (query.isNotEmpty) {
      List<Projet> searchedProjects =
      await widget.firebaseService.rechercherProjetParNom(query);
      setState(() {
        _projects = searchedProjects;
      });
    } else {
      _projects = List.from(_allProjects);

    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              //Bar de recherche
              child: Align(
                alignment: AlignmentDirectional(0, -1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        labelStyle:const TextStyle(
                          color: AppColors.bleu,
                        ),
                        labelText: 'Recherche',
                        enabledBorder: OutlineInputBorder(
                          borderSide:const BorderSide(
                            color: AppColors.bleu,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:const BorderSide(
                            color: AppColors.bleu,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                          color: AppColors.rouge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //bouton ajouter
            Align(
              alignment: AlignmentDirectional(1, -1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 5, 4),
                child: ElevatedButton.icon(
                  label: const Text("Ajouter"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ajouteUtilisateur();
                      },
                    ).then((_) {
                      // Appeler _loadProjects() lorsque la boîte de dialogue est fermée
                      _loadUsers();
                    });
                  },
                  icon: Icon(Icons.person_add_alt_1),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.vert,
                      foregroundColor: AppColors.blanc,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
          ]),
          const Divider(
            height: 30,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          const Text(
            "Liste des Utilisateurs ",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<List<Userapp>>(
            stream: firebaseService.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: _allUsers.length,
                    itemBuilder: (context, index) {
                      final user = _allUsers[index];
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          title: Text(
                            "${user.lastName } ${user.firstName }",
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                                "Email :${user.email}\n"
                                "Telephone :${user.phoneNumber}\n"
                                "Role :${user.role}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  indexG = user.id_user;
                                  indexmdp=user.password;
                                  _showDeleteDialog(context);
                                },
                                icon: const Icon(Icons.delete,size: 30,),
                                color:AppColors.rouge,
                              ),
                              IconButton(
                                onPressed: () {
                                  _showEditDialog(context, user);
                                },
                                icon: const Icon(Icons.edit,size: 30,),
                                color: AppColors.vert,
                              ),
                            ],
                          ),
                            
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Suppression'),
          content: Text('est-ce que vous voulez supprimer cet utilisateur ? '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call the method to delete the user from Firebase
                firebaseService.deleteUser(indexG,indexmdp).then((_) {
                  // Remove the user from the local list
                  setState(() {
                    _Users.removeWhere((user) => user.id_user == indexG);
                  });
                  CustomSnackBar.showCustomSnackBar(context, "Succès", "L'utilisateur a bien  supprimé", AppColors.rouge, Icons.done);
                  // Close the dialog
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Handle any errors that occur during deletion
                  CustomSnackBar.showCustomSnackBar(context, "erreur", "échec de supprimer l'utilisateur", AppColors.rouge, Icons.error);
                  // You can show an error message here if needed
                });
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context,Userapp user) {
    bool visible = false;
    bool visible2 = false;
    TextEditingController mdp =TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: AppColors.blanc,
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        padding: const EdgeInsets.symmetric(horizontal:40,vertical: 10 ),
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.vert
                        ),
                        child: Title(color: AppColors.bleu, child: const Text("Modifier utilisateur",style: TextStyle(color: AppColors.blanc,fontSize: 30),))),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: user.lastName,
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
                     initialValue:user.firstName ,
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
                      initialValue: user.phoneNumber,
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
                     initialValue: user.email,
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return null;
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
                        }else if(value!=mdp.text){
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.rouge,
                                foregroundColor: AppColors.blanc,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text("annuler"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.vert,
                                foregroundColor: AppColors.blanc,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text("Modifier"),
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
    );
  }
}


import 'package:flutter/material.dart';

import '../../Model/Engagement.dart';
import '../../Model/FirebaseServiceClient.dart';
import '../../Model/FirebaseServiceEngagement.dart';
import '../../Model/FirebaseServiceProjet.dart';
import '../../Model/Projets.dart';
import '../../Model/clientss.dart';
import '../../Model/regexvalid.dart';
import '../../style/colors.dart';

class ajouteClients extends StatefulWidget {
  const ajouteClients({super.key});

  @override
  State<ajouteClients> createState() => _ajouteClientsState();
}

class _ajouteClientsState extends State<ajouteClients> {
  final _formKey = GlobalKey<FormState>();
  final Client _client = Client(id: '', nom: '', prenom: '', numeroTelephone: '', email: '');
  String? _selectedProjectId; // Stocke l'ID du projet sélectionné
  final FirebaseServiceEngagement _engagementService = FirebaseServiceEngagement(); // Service Firebase d'engagement
  final FirebaseServiceClient _clientService = FirebaseServiceClient(); // Service Firebase de client
  final FirebaseServiceProjet _projetService = FirebaseServiceProjet();

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<Projet> projets) {
    List<DropdownMenuItem<String>> items = [];
    for (Projet projet in projets) {
      items.add(
        DropdownMenuItem(
          value: projet.id,
          child: Text(projet.nomProjet),
        ),
      );
    }
    return items;
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.bleu),
                  child: Title(
                      color: AppColors.bleu,
                      child: const Text(
                        "Ajouter Client",
                        style: TextStyle(color: AppColors.blanc, fontSize: 25),
                      ))),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  _client.nom = value!;
                },
                validator: (value) {
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
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.bleu,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  _client.prenom = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vous devez entrer le prenom";
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
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.bleu,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  _client.numeroTelephone = value!;
                },
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vous devez entrer telephone";
                  } else if (!Validator.isValidPhoneNumber(value)) {
                    return "Entrez le téléphone comme ceci'0 et{9 N}'";
                  }
                  return null;
                },
                obscureText: false,
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
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: AppColors.bleu,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  _client.email = value!;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vous devez entrer l'Email";
                  } else if (!Validator.isValidEmail(value)) {
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
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.bleu,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Dropdown pour choisir le projet
              FutureBuilder<List<Projet>>(
                future: _projetService.getProjets().first,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant le chargement des projets
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur: ${snapshot.error}');
                  }
                  List<Projet> projets = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedProjectId,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner un projet';
                      }
                      return null;
                    },
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProjectId = newValue;
                      });
                    },
                    items: _buildDropdownMenuItems(projets),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: AppColors.bleu,
                      ),
                      labelText: 'Choisir un projet',
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
                      prefixIcon: const Icon(
                        Icons.business_center,
                        color: AppColors.bleu,
                      ),
                    ),
                    iconSize: 30,
                    iconEnabledColor: AppColors.bleu,
                    iconDisabledColor: AppColors.bleu,
                    style: const TextStyle(color: AppColors.bleu, fontSize: 20),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      label: const Text("Annuler"),
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
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    label: const Text("Ajouter"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Save client data to Firestore
                        _clientService.ajouterClient(_client).then((clientId) {
                          // Optionally, if you need to save engagement data too:
                          if (_selectedProjectId != null) {
                            Engagement engagement = Engagement(
                              id: '', // This will be auto-generated by Firestore
                              projetId: _selectedProjectId!,
                              clientId: clientId, // Use the returned client ID
                            );
                            _engagementService.ajouterEngagement(engagement);
                          }

                          // Close the dialog after successful addition
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(

                                  padding: const EdgeInsets.all(15),
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    color: AppColors.vert,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Succès",style: TextStyle(fontSize: 20,color: AppColors.blanc),),
                                          SizedBox(width: 10,),
                                          Icon(Icons.done,color: AppColors.blanc,),
                                        ],
                                      ),
                                      Text("Le client est bien ajouté",style: TextStyle(fontSize: 15,color: AppColors.blanc),),
                                    ],
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ));
                        }).catchError((error) {
                          print("Error adding client: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(

                                padding: const EdgeInsets.all(15),
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: AppColors.vert,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("erreur ",style: TextStyle(fontSize: 20,color: AppColors.blanc),),
                                        SizedBox(width: 10,),
                                        Icon(Icons.error,color: AppColors.blanc,),
                                      ],
                                    ),
                                    Text("Échec de l'ajout du client. Veuillez réessayer.",style: TextStyle(fontSize: 15,color: AppColors.blanc),),
                                  ],
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                          );
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

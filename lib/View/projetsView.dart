import 'package:cinq_etoils/Model/FirebaseServiceProjet.dart';
import 'package:cinq_etoils/style/colors.dart';
import 'package:flutter/material.dart';

import '../Model/Projets.dart';
import '../Model/regexvalid.dart';
import 'DialogView/dialogAjouterProjet.dart';

class ProjetsView extends StatefulWidget {
  final FirebaseServiceProjet firebaseService;
  const ProjetsView({super.key, required this.firebaseService});

  @override
  State<ProjetsView> createState() => _ProjetsViewState();
}

class _ProjetsViewState extends State<ProjetsView> {
  List<Projet> _allProjects = [];
  List<Projet> _projects = [];
  final TextEditingController _searchController = TextEditingController();
  //final FirebaseServiceProjet firebaseServiceProjet=FirebaseServiceProjet();
  String indexG="";

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    List<Projet> projects = await widget.firebaseService.getProjets().first;
    setState(() {
      _projects = projects;
      _allProjects = List.from(projects);
    });
  }

  void _searchProjects(String query) async {
    if (query.isNotEmpty) {
      List<Projet> searchedProjects =
      await widget.firebaseService.rechercherProjetParNom(query);
      setState(() {
        _projects = searchedProjects;
      });
    } else {
      _projects = List.from(_allProjects);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(//Bar de recherche
            child: Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: _searchProjects,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: AppColors.bleu,
                      ),
                      labelText: 'Recherche',
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
                      prefixIcon: const Icon(Icons.search,color: AppColors.bleu,),
                      suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchProjects('');
                          });

                        },
                        icon: const Icon(Icons.close,color: AppColors.rouge,),
                      ) : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //bouton ajouter
          Align(
            alignment: const AlignmentDirectional(1, -1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 5, 4),
              child: ElevatedButton.icon(
                label: const Text("Ajouter"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ajouteProjets(firebaseService: widget.firebaseService,);
                    },
                  ).then((_) {
                    // Appeler _loadProjects() lorsque la boîte de dialogue est fermée
                    _loadProjects();
                  });
                },
                icon: const Icon(Icons.add_business),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vert,
                    foregroundColor: AppColors.blanc,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ]),
        const Text("List Projets : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        StreamBuilder<List<Projet>>(
          stream: widget.firebaseService.getProjets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final projet = snapshot.data![index];
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        title: Text(
                          projet.nomProjet,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${projet.email}\n${projet.numeroTelephone}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                indexG = projet.id;
                                _showDeleteDialog(context);
                              },
                              icon: const Icon(Icons.delete,size: 30,),
                              color:AppColors.rouge,
                            ),
                            IconButton(
                              onPressed: () {
                                _showEditDialog(context, projet);
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
    );
  }
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.bleu,
          title: const Text('Confirmation :',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: AppColors.blanc),),
          content: const Text('Voulez-vous vraiment supprimer ce projet ?',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: AppColors.blanc),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vert,
                  foregroundColor: AppColors.blanc,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Annuler'),
            ),
            ElevatedButton (
              onPressed: () {
                widget.firebaseService.supprimerProjet(indexG); // Delete the project
                Navigator.of(context).pop();
                _loadProjects();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Container(
                    padding: const EdgeInsets.all(15),
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.rouge,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Succès !",style: TextStyle(fontSize: 20,color: AppColors.blanc),),
                            SizedBox(width: 10,),
                            Icon(Icons.delete_forever,color: AppColors.blanc,),
                          ],
                        ),
                        Text("Le projet a été supprimé",style: TextStyle(fontSize: 15,color: AppColors.blanc),),
                      ],
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rouge,
                  foregroundColor: AppColors.blanc,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
  void _showEditDialog(BuildContext context, Projet projet) {
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        padding: const EdgeInsets.symmetric(horizontal:40,vertical: 10 ),
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.vert
                        ),
                        child: Title(color: AppColors.bleu, child: const Text("Modifier Projet",style: TextStyle(color: AppColors.blanc,fontSize: 30),))),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: projet.nomProjet,
                      onChanged: (value) {
                        projet.nomProjet = value;
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
                          color: AppColors.vert,
                        ),
                        labelText: 'Nom de Projet',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
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
                        prefixIcon: const Icon(Icons.business_center,color: AppColors.vert,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: projet.numeroTelephone,
                      onChanged: (value) {
                        projet.numeroTelephone = value;
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
                          color: AppColors.vert,
                        ),
                        labelText: 'Tele professionnel',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
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
                        prefixIcon: const Icon(Icons.phone,color: AppColors.vert,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: projet.email,
                      onChanged: (value) {
                        projet.email = value;
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
                          color: AppColors.vert,
                        ),
                        labelText: 'Email professionnel',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
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
                        prefixIcon: const Icon(Icons.email,color: AppColors.vert,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: projet.projetUrl,
                      onChanged: (value) {
                        projet.projetUrl = value;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: AppColors.vert,
                        ),
                        labelText: 'URL Avis',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.vert,
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
                        prefixIcon: const Icon(Icons.link,color: AppColors.vert,),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  widget.firebaseService.modifierProjet(projet.id, projet);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: AppColors.jaune,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Succès !",style: TextStyle(fontSize: 20,color: AppColors.blanc),),
                                              SizedBox(width: 10,),
                                              Icon(Icons.done,color: AppColors.blanc,),
                                            ],
                                          ),
                                          Text("Le projet a été modifié",style: TextStyle(fontSize: 15,color: AppColors.blanc),),
                                        ],
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.vert,
                                  foregroundColor: AppColors.blanc,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text("Modifier"),
                            ),
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

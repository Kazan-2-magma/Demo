import 'package:flutter/material.dart';

import '../Model/Engagement.dart';
import '../Model/FirebaseServiceClient.dart';
import '../Model/FirebaseServiceEngagement.dart';
import '../Model/FirebaseServiceProjet.dart';
import '../Model/Projets.dart';
import '../Model/clientss.dart';
import '../style/colors.dart';
import 'DialogView/dialogAjouterClients.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  String? selectedProjectId;
  List<Projet> projects = []; // List to store projects
  List<String> selectedEmails = []; // Liste des emails des clients sélectionnés


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
        if (projects.isNotEmpty) {
          selectedProjectId = projects.first.id; // Select the first project by default
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
              children: [
                  Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0, -1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Container(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
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
                            contentPadding: const EdgeInsets.all(12),
                            prefixIcon: const Icon(Icons.business_center,
                              color: AppColors.bleu,),
                          ),
                          iconSize: 30,
                          iconEnabledColor: AppColors.bleu,
                          iconDisabledColor: AppColors.bleu,
                          style: const TextStyle(
                              color: AppColors.bleu, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                  // Bouton ajouter
                  Align(
                  alignment: AlignmentDirectional(1, -1),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 5, 4),
                    child: ElevatedButton.icon(
                      label: Text("Ajouter"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              bool isChecked = false;
                              return ajouteClients();
                            }).then((_) {

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
          ]
          ),
          const Text("Liste de clients :",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Divider(
            height: 30,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Client>>(
             future: selectedProjectId != null ? FirebaseServiceClient().getClientsForProject(selectedProjectId!) : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                          'Error: Something went wrong',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25.0
                          ),
                      )
                  );
                } else {
                  List<Client>? clients = snapshot.data;
                  if (clients != null && clients.isNotEmpty) {
                    return ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          margin:const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: ListTile(
                            contentPadding:const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              '${clients[index].nom} ${clients[index].prenom}',
                              style:const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Email :${clients[index].email} \nTelephone : ${clients[index]
                                  .numeroTelephone}',
                              style:const TextStyle(fontSize: 14.0),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Show a confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:const Text("Confirmation"),
                                          content:const Text("Voulez-vous vraiment supprimer ce client ?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child:const Text("Annuler"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Perform client deletion here
                                                deleteClient(clients[index].id); // Pass the client ID to the deletion method
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: Text("Supprimer"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                                Checkbox(
                                    value: selectedEmails.contains(clients[index].numeroTelephone),
                                    onChanged: (isChecked) {
                                    setState(() {
                                      if (isChecked!) {
                                        selectedEmails.add(clients[index].numeroTelephone);
                                      } else {
                                        selectedEmails.remove(clients[index].numeroTelephone);
                                      }
                                    });
                                  },)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else {
                    return const Center(child: Text('Aucun client trouvé.'));
                  }
                }
              },
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton.icon(
                label: const Text("Envoyer"),
                onPressed: (){
                  print(selectedEmails);
                },
                icon:const Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vert,
                    foregroundColor: AppColors.blanc,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
        ],
      ),
    );
  }
// Function to delete a client
  Future<void> deleteClient(String clientId) async {
    try {
      // Call the FirebaseServiceClient to delete the client
      await FirebaseServiceClient().supprimerClient(clientId);
    } catch (e) {
      print('Error deleting client: $e');
      // Handle error, e.g., show an error message to the user
    }
  }

}

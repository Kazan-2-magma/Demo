import 'package:cinq_etoils/Model/FirebaseServiceClient.dart';
import 'package:cinq_etoils/Model/FirebaseServiceProjet.dart';
import 'package:cinq_etoils/Model/clientss.dart';

import 'package:flutter/material.dart';

import '../Model/FirebaseServiceUser.dart';
import '../Model/Projets.dart';
import '../Model/Users.dart';
import '../style/colors.dart';

class Home extends StatefulWidget {
  final FirebaseServiceProjet firebaseService;
  final FirebaseServiceClient firebaseServiceClient;
  final FirebaseServiceUser firebaseServiceuser;


  const Home({super.key, required this.firebaseService, required this.firebaseServiceClient, required this.firebaseServiceuser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Projet> _projectsnumber = [];
  List<Client> _clientsnumber =[];
  List<Userapp> _Userscpt =[];

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _loadClients();
    _loadUsers();
  }
  Future<void> _loadProjects() async {
    List<Projet> projects = await widget.firebaseService.getProjets().first;
    setState(() {
      _projectsnumber = projects;
    });
  }
  Future<void> _loadClients() async {
    List<Client> Clients = await widget.firebaseServiceClient.getclients().first;
    setState(() {
      _clientsnumber = Clients;
    });
  }
  Future<void> _loadUsers() async {
    List<Userapp> userrs = await widget.firebaseServiceuser.getUsers().first;
    setState(() {
      _Userscpt = userrs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      top: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColors.bleu,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.business_center,
                            size: 50,
                            color: AppColors.blanc,
                          ),
                        ),
                      ),
                      Align(
                       alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Projets',style: TextStyle(fontSize: 40,color: AppColors.blanc),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(1, 1),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              'Nombre :',
                              style: TextStyle(fontSize: 20,color: AppColors.blanc),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "${_projectsnumber.length}",
                            style: const TextStyle(fontSize: 20,color: AppColors.blanc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColors.rouge,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.people,
                            size: 50,
                            color: AppColors.blanc,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Clients',style: TextStyle(fontSize: 40,color: AppColors.blanc),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(1, 1),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              'Nombre :',
                              style: TextStyle(fontSize: 20,color: AppColors.blanc),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "${_clientsnumber.length}",
                            style: const TextStyle(fontSize: 20,color: AppColors.blanc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColors.jaune,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.mail,
                            size: 50,
                            color: AppColors.blanc,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Messages',style: TextStyle(fontSize: 40,color: AppColors.blanc),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(1, 1),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              'Nombre :',
                              style: TextStyle(fontSize: 20,color: AppColors.blanc),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            '00',
                            style: TextStyle(fontSize: 20,color: AppColors.blanc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: AppColors.bleu,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.business_center,
                            size: 50,
                            color: AppColors.blanc,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Utilisateurs',style: TextStyle(fontSize: 40,color: AppColors.blanc),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(1, 1),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              'Nombre :',
                              style: TextStyle(fontSize: 20,color: AppColors.blanc),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "${_Userscpt.length}",
                            style: const TextStyle(fontSize: 20,color: AppColors.blanc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: (){
              },
              child: Text("Click"))


        ],
      ),
    );
  }
}

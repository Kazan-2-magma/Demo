

import 'package:cinq_etoils/Model/FirebaseServiceClient.dart';
import 'package:cinq_etoils/Model/FirebaseServiceProjet.dart';
import 'package:cinq_etoils/Model/FirebaseServiceUser.dart';
import 'package:cinq_etoils/Model/FirebaseStorageService.dart';
import 'package:cinq_etoils/View/projetsView.dart';
import 'package:cinq_etoils/View/uesrView.dart';
import 'package:cinq_etoils/style/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../Model/Users.dart';
import 'Profile.dart';
import 'clientsView.dart';
import 'homeAdmine.dart';

class pagesAdmin extends StatefulWidget {
  const pagesAdmin({super.key});

  @override
  State<pagesAdmin> createState() => _pagesAdminState();
}

class _pagesAdminState extends State<pagesAdmin> {
  final FirebaseServiceProjet firebaseService=FirebaseServiceProjet();
  final FirebaseServiceClient firebaseService1=FirebaseServiceClient();
  final FirebaseServiceUser firebaseServiceuser=FirebaseServiceUser();
  final FirebaseStorageService storageService=FirebaseStorageService();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  List<bool> pageStates = [true, false, false, false, false]; // Maintains the state of each page
  int currentIndex = 0;
  late Userapp userApp ;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Current user ID: ${user.uid}');
        Map<String, dynamic>? userData = await firebaseServiceuser.getUserInfo(user.uid);
        if (userData != null && userData.isNotEmpty) {
          print('User data from Firestore: $userData');
          setState(() {
            userApp = Userapp(
              id_user: userData['id_user'] ?? '', // Vérifiez la nullité et utilisez une valeur par défaut si nécessaire
              firstName: userData['firstName'] ?? '',
              lastName: userData['lastName'] ?? '',
              phoneNumber: userData['phoneNumber'] ?? '',
              email: userData['email'] ?? '',
              photoUrl: userData['photoUrl'] ?? '',
              idProjet: userData['idProjet'] ?? '',
              role: userData['role'] ?? '',
              password: userData['password'] ?? '',
            );
          });
        } else {
          print('User data is null or empty');
        }
      } else {
        print('Current user is null');
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  changePage(index) {
    setState(() {
      for (int i = 0; i < pageStates.length; i++) {
        pageStates[i] = (i == index); // Set the state of the current page to true, and others to false
      }
      _sideMenuKey.currentState!.closeSideMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,
      menu: Container(
        padding: const EdgeInsets.symmetric( vertical: 10),
        child: ListView(
          children: [
             ListTile(
              leading: CircleAvatar(
                backgroundImage: userApp.photoUrl.isNotEmpty ? NetworkImage(userApp.photoUrl)  // Utiliser l'image du profil si elle est disponible
                    : NetworkImage("https://firebasestorage.googleapis.com/v0/b/cinq-etoiles-f2bce.appspot.com/o/profil%2Fdefault_imag.png?alt=media&token=2746acb3-e5cd-4218-a036-e2372b93e3fa"), // Utiliser une image par défaut si l'image du profil est vide
              ),

               title: Text(
                "${userApp.firstName} ${userApp.lastName}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize:20),
              ),
              subtitle: Text(
                userApp.email,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 18,
            ),
            ButtonDecoration(
                name: "Home",
                iconData: Icons.home,
                boxColor: Colors.transparent,
                onTap: () {
                  changePage(0);
                }),
            const SizedBox(
              height: 40,
            ),
            ButtonDecoration(
                name: "Projet",
                iconData: Icons.business_center,
                boxColor: Colors.transparent,
                onTap: () {
                  changePage(1);
                }),
            const SizedBox(
              height: 40,
            ),
            ButtonDecoration(
                name: "Client",
                iconData: Icons.people,
                boxColor: Colors.transparent,
                onTap: () {
                  changePage(2);
                }),
            const SizedBox(
              height: 40,
            ),
            ButtonDecoration(
                name: "utilisateurs",
                iconData: Icons.co_present,
                boxColor: Colors.transparent,
                onTap: () {
                  changePage(3);
                }),
            const SizedBox(
              height: 40,
            ),
            ButtonDecoration(
                name: "profil",
                iconData: Icons.person,
                boxColor: Colors.transparent,
                onTap: () {
                  changePage(4);
                }),
            const SizedBox(
              height: 40,
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 40,
            ),
            ButtonDecoration(
                name: "se deconnecter",
                iconData: Icons.logout,
                boxColor: Colors.transparent,
                onTap: () {
                  firebaseServiceuser.signOut();
                }),

          ],
        ),
      ),
      background: AppColors.bleu,
      type: SideMenuType.shrinkNSlide, // check above images
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bleu,
          title: const Text("Cinq Etoils Admin",style: TextStyle(color: AppColors.blanc ,fontSize: 30,fontWeight: FontWeight.bold),),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: const Icon(Icons.menu,color: AppColors.blanc,size: 40,),
              onPressed: () {
                final state = _sideMenuKey.currentState;
                if (state!.isOpened) {
                  state.closeSideMenu(); // close side menu
                } else {
                  state.openSideMenu(); // open side menu
                }
              },
            ),
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            if (pageStates[0]) Home(firebaseService: firebaseService, firebaseServiceClient: firebaseService1, firebaseServiceuser: firebaseServiceuser,),
            if (pageStates[1]) ProjetsView(firebaseService:firebaseService,),
            if (pageStates[2]) const ClientsView(),
            if (pageStates[3]) const userView(),
            if (pageStates[4]) ProfilView(firebaseServiceUser: firebaseServiceuser, user: userApp, storageService: storageService,),
          ],
        ),
      ),
    );
  }

  ButtonDecoration({
    required String name,
    required IconData iconData,
    required onTap,
    required Color boxColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: boxColor,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 30,
              color: Colors.white,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

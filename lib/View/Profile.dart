import 'dart:io';

import 'package:cinq_etoils/View/DialogView/showEdiyPasswoedDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../Model/FirebaseServiceUser.dart';
import '../Model/FirebaseStorageService.dart';
import '../Model/Users.dart';
import '../Model/regexvalid.dart';
import '../style/colors.dart';
import 'DialogView/CustomSnackBar.dart';

class ProfilView extends StatefulWidget {
  final Userapp user;
  final FirebaseServiceUser firebaseServiceUser;
  final FirebaseStorageService storageService;


  const ProfilView({super.key, required this.firebaseServiceUser, required this.storageService ,required this.user, });

  @override
  State<ProfilView> createState() => _ProfilState();
}

class _ProfilState extends State<ProfilView> {
  bool _isUploading = false;
  late Userapp _user;
 User? user1 = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    _user = widget.user;

  }
  // Function to handle image selection
  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);// Use gallery as image source, you can change it to camera if needed

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      // Upload selected image
      File imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
      setState(() {
        _isUploading = false;
      });
    } else {
      print('No image selected.');
    }
  }

  // Function to upload image
  Future<void> _uploadImage(File imageFile) async {
    // Retrieve userId, you need to replace 'userId' with your actual userId
    String? userId = user1?.uid ;

    // Call uploadProfileImage method from FirebaseStorageService
    await widget.storageService.uploadProfileImage(userId!, imageFile);

    /// Retrieve updated user data from Firestore
    Map<String, dynamic>? userData = await widget.firebaseServiceUser.getUserInfo(user1!.uid);
    if (userData != null) {
      // Update user object with new photoUrl
      setState(() {
        _user.photoUrl = userData['photoUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    String nom=_user.firstName;
    String prenom=_user.lastName;
    String tel=_user.phoneNumber;
    String role=_user.role;
    String image=_user.photoUrl;
    String email=_user.email;


    return  Container(
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width*0.9,
                height:  MediaQuery.of(context).size.height*0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white
                ),
                child:const Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              height:  MediaQuery.of(context).size.height*0.67,
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        child: GestureDetector(
                          onTap: getImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: image != null
                                    ? NetworkImage(image)
                                    : const NetworkImage("https://firebasestorage.googleapis.com/v0/b/cinq-etoiles-f2bce.appspot.com/o/profil%2Fdefault_imag.png?alt=media&token=2746acb3-e5cd-4218-a036-e2372b93e3fa"),
                                radius: 70,
                              ),
                              if (_isUploading)
                               const CircularProgressIndicator(
                                 strokeCap: StrokeCap.round,
                                  strokeAlign: 10,
                                  strokeWidth: 9.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.bleu,),
                                  backgroundColor: AppColors.jaune,
                                ), // Show CircularProgressIndicator while uploading
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:20,vertical:20),
                        child: ElevatedButton.icon(
                          label:const Text("Modifier",style: TextStyle(fontSize: 12),),
                          onPressed: ()   {
                            print(user1!.uid);
                           _showEditDialog(context, _user,user1!.uid);
                          },
                          icon:const Icon(Icons.edit),
                          style: ElevatedButton.styleFrom(
                            fixedSize:Size.fromWidth( MediaQuery.of(context).size.width*0.4,),
                            backgroundColor: AppColors.vert,
                            foregroundColor: AppColors.blanc,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height:20,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.rouge,
                        ),
                        child:const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      const Expanded(
                        child: Text(
                          "Nom : ",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        nom,
                        style:const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        margin:const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:const Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.rouge,
                        ),
                        child:const Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.blanc,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      const Expanded(
                        child: Text(
                          "Prenom : ",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        prenom,
                        style:const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.vert,
                        ),
                        child: Icon(
                          Icons.phone,
                          size: 20,
                          color: AppColors.blanc,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text(
                          "Téléphone : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        tel,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.jaune,
                        ),
                        child: Icon(
                          Icons.email,
                          size: 20,
                          color: AppColors.blanc,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text(
                          "Adresse-email : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        email,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SizedBox(width: 20),
                    ],
                  )
                  ,SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      Container(
                        width: 30,
                        height: 30,
                        margin:const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:const Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.jaune,
                        ),
                        child:const Icon(
                          Icons.email,
                          size: 20,
                          color: AppColors.blanc,
                        ),
                      ),
                      const SizedBox(width: 20,),
                      const Expanded(
                        child: Text(
                          "Role : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Text(
                        role,
                        style:const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding:const EdgeInsets.symmetric(horizontal:30,vertical:40),
                    child: ElevatedButton.icon(
                      label:const Text("Modifier Mot de pass",style: TextStyle(fontSize: 12),),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const showEditPasswordDialog();
                          },
                        ).then((_) {
                          
                        });
                      },
                      icon:const Icon(Icons.edit),
                      style: ElevatedButton.styleFrom(
                        fixedSize:Size.fromWidth( MediaQuery.of(context).size.width,),
                        backgroundColor: AppColors.vert,
                        foregroundColor: AppColors.blanc,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
  void _showEditDialog(BuildContext context, Userapp user,String iduser) {
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
                        child: Title(color: AppColors.bleu, child: const Text("Modifier profile",style: TextStyle(color: AppColors.blanc,fontSize: 30),))),
                    const SizedBox(height: 10,),
                    TextFormField(
                      initialValue: user.lastName,
                      onChanged: (value) {
                        user.lastName = value;
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
                        labelText: 'Nom',
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
                      initialValue: user.firstName,
                      onChanged: (value) {
                        user.firstName = value;
                      },
                      validator: (value){
                        if (value!.isEmpty) {
                          return "Vous devez entrer le Prenom";
                        }
                        return null;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: AppColors.vert,
                        ),
                        labelText: 'Prenom',
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
                      initialValue: user.phoneNumber,
                      onChanged: (value) {
                        user.phoneNumber = value;
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
                      readOnly: true,
                      initialValue: user.email,
                      onChanged: (value) {
                       user.email = value;
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
                    Row(
                      children: [
                        Flexible(
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
                        const SizedBox(width: 10.0,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                widget.firebaseServiceUser.modifyUserById(iduser,user );
                                Navigator.of(context).pop();
                                CustomSnackBar.showCustomSnackBar(context, "succès", "le profil et bien modifié", AppColors.vert, Icons.done);
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
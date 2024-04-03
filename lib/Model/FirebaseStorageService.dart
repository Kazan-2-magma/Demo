import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // Retrieve image URL from Firebase Storage
  Future<String> getImageUrl(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        final ref = _storage.ref().child(imageUrl);
        return await ref.getDownloadURL();
      }
    } catch (e) {
      print('Error getting image URL: $e');
    }
    return ''; // Return empty string if retrieval fails
  }

  Future<void> uploadProfileImage(String userId, File imageFile) async {
    try {
      String imageName = 'profil_$userId.jpg';
      // Référence du chemin dans le stockage Firebase
      Reference ref = _storage.ref().child('profil').child(imageName);

      // Charger le fichier dans le stockage Firebase avec un nouveau nom
      UploadTask uploadTask = ref.putFile(imageFile);

      // Attendez que le chargement soit terminé
      TaskSnapshot taskSnapshot = await uploadTask;

      // Obtenir l'URL de téléchargement du fichier
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      // Mettre à jour la référence de l'image dans la collection "users"
      await _userCollection.doc(userId).update({'photoUrl': imageUrl});

      // Supprimer l'image existante avec le nom précédent
      await _storage.ref().child('profil').child('$userId.jpg').delete();


    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
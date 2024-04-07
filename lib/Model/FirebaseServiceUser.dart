import 'package:cinq_etoils/Model/Users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServiceUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // Register with email and password
  Future<String?> registerWithEmailAndPassword(String email, String password, Userapp user) async {
    try {
      // Register user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Save user data to Firestore
      await _userCollection.doc(result.user!.uid).set(user.toJson());
      return null; // Return null for successful registration
    } catch (e) {
      return e.toString(); // Return error message for failed registration
    }
  }

  //delete user
  Future<void> deleteUser(String userId, String password) async {
    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(email: _auth.currentUser!.email!, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);

      // Delete user from Firebase Authentication
      await _auth.currentUser?.delete();

      // Delete user document from Firestore
      await _userCollection.doc(userId).delete();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting user: $e');
      throw e; // Rethrow the error to handle it in the UI if needed
    }
  }
  // Modify user by ID
  Future<void> modifyUserById(String userId, Userapp updatedUser) async {
    try {
      // Update user document in Firestore
      await _userCollection.doc(userId).update(updatedUser.toJson());
    } catch (e) {
      print('Error modifying user: $e');
      throw e; // Rethrow the error to handle it in the UI if needed
    }
  }
  // Fonction pour récupérer toutes les informations de l'utilisateur à partir de Cloud Firestore
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await _userCollection.doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>?;
      } else {
        print('Document utilisateur non trouvé');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations de l\'utilisateur : $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in user with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null; // Return null for successful sign in
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "L'utilisateur n'a pas été trouvé.";
      } else if (e.code == 'wrong-password') {
        return "Mot de passe incorrect.";
      } else {
        return "Une erreur s'est produite : ${e.message}";
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //list de users
  Stream<List<Userapp>> getUsers() {
    return _userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Userapp(
          id_user: doc.id,
          firstName: doc['firstName'],
          lastName:doc['lastName'],
          phoneNumber:doc['phoneNumber'],
          email: doc['email'],
          photoUrl:doc['photoUrl'],
          idProjet: doc['idProjet'],
          role:doc['role'],
          password: doc['password'],
        );
      }).toList();
    });
  }
//
  Future<List<Userapp>> rechercheUserParEmailEtPassword(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await _userCollection
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      List<Userapp> users = querySnapshot.docs.map((doc) {
        return Userapp(
          id_user: doc.id,
          firstName: doc['firstName'],
          lastName: doc['lastName'],
          phoneNumber: doc['phoneNumber'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          idProjet: doc['idProjet'],
          role:doc['role'],
          password: doc['password'],

        );
      }).toList();

      return users;
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de la recherche d\'utilisateur par email et mot de passe : $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }
  // Update password for a user
  Future<void> updatePassword(String userId, String newPassword) async {
    try {
      // Update password in Firebase Authentication
      await _auth.currentUser?.updatePassword(newPassword);

      // Update password in Firestore collection
      await _userCollection.doc(userId).update({'password': newPassword});
    } catch (e) {
      print('Error updating password: $e');
      throw e; // Rethrow the error to handle it in the UI if needed
    }
  }

}


import 'package:cloud_firestore/cloud_firestore.dart';

import 'Engagement.dart';

class FirebaseServiceEngagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //************engagement************

  // Method to add an engagement to Firestore
  Future<void> ajouterEngagement(Engagement engagement) async {
    try {
      await _firestore.collection('engagements').add({
        'projetId': engagement.projetId,
        'clientId': engagement.clientId,
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'engagement: $e');
    }
  }

  // Method to delete an engagement from Firestore
  Future<void> supprimerEngagement(String engagementId) async {
    try {
      await _firestore.collection('engagements').doc(engagementId).delete();
    } catch (e) {
      print('Erreur lors de la suppression de l\'engagement: $e');
    }
  }
}

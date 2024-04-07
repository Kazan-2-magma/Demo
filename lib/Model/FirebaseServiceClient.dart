import 'package:cloud_firestore/cloud_firestore.dart';

import 'clientss.dart';



class FirebaseServiceClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> ajouterClient(Client client) async {
    try {
      DocumentReference docRef = await _firestore.collection('clients').add(client.toJson());
      return docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout du client: $e');
      throw e;
    }
  }

  // Method to delete a client from Firestore
  // Method to delete a client from Firestore and corresponding engagements
  Future<void> supprimerClient(String clientId) async {
    try {
      // Delete client document
      await _firestore.collection('clients').doc(clientId).delete();

      // Delete engagements associated with the client
      QuerySnapshot engagementsSnapshot = await _firestore
          .collection('engagements')
          .where('clientId', isEqualTo: clientId)
          .get();

      // Delete each engagement document
      for (DocumentSnapshot engagementDoc in engagementsSnapshot.docs) {
        await engagementDoc.reference.delete();
      }
    } catch (e) {
      print('Erreur lors de la suppression du client: $e');
      throw e; // Rethrow the error for error handling at a higher level
    }
  }

  Future<void> modifierClient(String clientId, Client nouveauClient) async {
    try {
      await _firestore.collection('clients').doc(clientId).update({
        'nom': nouveauClient.nom,
        'prenom': nouveauClient.prenom,
        'numeroTelephone': nouveauClient.numeroTelephone,
        'email': nouveauClient.email,
      });
    } catch (e) {
      print('Erreur lors de la modification du client: $e');
    }
  }


  //list de client
  Stream<List<Client>> getclients() {
    return _firestore.collection('clients').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Client(
          id: doc.id,
          nom: doc['nom'],
          prenom: doc['prenom'],
          numeroTelephone: doc['numeroTelephone'],
          email: doc['email'],
        );
      }).toList();
    });
  }

  Future<List<Client>> getClientsForProject(String projectId) async {
    try {
      // First, query engagements for the given project
      QuerySnapshot engagementSnapshot = await _firestore
          .collection('engagements')
          .where('projetId', isEqualTo: projectId)
          .get();

      // Extract client IDs from engagements
      List clientIds = engagementSnapshot.docs.map((doc) => doc['clientId']).toList();

      // Use client IDs to query clients
      QuerySnapshot clientSnapshot = await _firestore
          .collection('clients')
          .where(FieldPath.documentId, whereIn: clientIds)
          .get();

      // Map client documents to Client objects
      return clientSnapshot.docs.map((doc) {
        return Client(
          id: doc.id,
          nom: doc['nom'],
          prenom: doc['prenom'],
          numeroTelephone: doc['numeroTelephone'],
          email: doc['email'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching clients for project: $e');
      throw e;
    }
  }

}

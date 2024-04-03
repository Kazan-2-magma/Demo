import 'package:cloud_firestore/cloud_firestore.dart';

import 'Projets.dart';

class FirebaseServiceProjet {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //***********projet************

  //l'ajout d'un projet à Firebase
  Future<void> ajouterProjet(Projet projet) async {
    try {
      await _firestore.collection('projets').add(projet.toJson());
    } catch (e) {
      print('Erreur lors de l\'ajout du projet: $e');
    }
  }

  //supprimer un projet de Firebase
  Future<void> supprimerProjet(String projetId) async {
    try {
      await _firestore.collection('projets').doc(projetId).delete();
    } catch (e) {
      print('Erreur lors de la suppression du projet: $e');
    }
  }

  // Méthode pour modifier un projet
  Future<void> modifierProjet(String projetId, Projet nouveauProjet) async {
    try {
      await _firestore.collection('projets').doc(projetId).update({
        'nomProjet': nouveauProjet.nomProjet,
        'numeroTelephone': nouveauProjet.numeroTelephone,
        'email': nouveauProjet.email,
        'photoUrl': nouveauProjet.photoUrl,
        'projetUrl': nouveauProjet.projetUrl,
      });
    } catch (e) {
      print('Erreur lors de la modification du projet: $e');
    }
  }

  // Méthode pour rechercher un projet par nom
  Future<List<Projet>> rechercherProjetParNom(String nom) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projets')
          .where('nomProjet', isEqualTo: nom).get();
      return querySnapshot.docs.map((doc) {
        return Projet(
          id: doc.id,
          nomProjet: doc['nomProjet'],
          numeroTelephone: doc['numeroTelephone'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          projetUrl: doc['projetUrl'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la recherche du projet: $e');
      return [];
    }
  }

  //list de projet
  Stream<List<Projet>> getProjets() {
    return _firestore.collection('projets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Projet(
          id: doc.id,
          nomProjet: doc['nomProjet'],
          numeroTelephone: doc['numeroTelephone'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          projetUrl: doc['projetUrl'],
        );
      }).toList();
    });
  }
  //ou
  Future<List<Projet>> getProjetss() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('projets').get();
      return querySnapshot.docs.map((doc) {
        return Projet(
          id: doc.id,
          nomProjet: doc['nomProjet'],
          numeroTelephone: doc['numeroTelephone'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          projetUrl: doc['projetUrl'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des projets: $e');
      return []; // Retourne une liste vide en cas d'erreur
    }
  }


}

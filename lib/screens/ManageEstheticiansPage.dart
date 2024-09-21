import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageEstheticiansPage extends StatelessWidget {
  final String salonId;

  ManageEstheticiansPage({required this.salonId});

  Future<QuerySnapshot> _getEstheticians() async {
    // Récupérer les esthéticiennes pour le salon donné
    return FirebaseFirestore.instance
        .collection('estheticians')
        .where('salonId', isEqualTo: salonId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Gérer les esthéticiennes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _getEstheticians(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des esthéticiennes.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune esthéticienne inscrite pour ce salon.'));
          }

          var estheticians = snapshot.data!.docs;

          return ListView.builder(
            itemCount: estheticians.length,
            itemBuilder: (context, index) {
              var estheticianData = estheticians[index].data() as Map<String, dynamic>;
              String name = estheticianData['name'] ?? 'Nom non disponible';
              String email = estheticianData['email'] ?? 'Email non disponible';
              String phone = estheticianData['phone'] ?? 'Téléphone non disponible';

              return ListTile(
                leading: Icon(Icons.person, color: Colors.pink),
                title: Text(name),
                subtitle: Text('Email: $email\nTéléphone: $phone'),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.pink),
                  onPressed: () {
                    // Ajouter ici la logique pour modifier les détails de l'esthéticienne
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

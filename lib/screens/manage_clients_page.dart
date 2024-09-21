import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageClientsPage extends StatelessWidget {
  final String salonId;

  ManageClientsPage({required this.salonId});

  // Fonction pour récupérer les clients associés au salon
  Future<QuerySnapshot> _getClientsForSalon() async {
    return FirebaseFirestore.instance
        .collection('clients')
        .where('salon', isEqualTo: salonId) // Filtrer par salonId
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les clients'),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _getClientsForSalon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des clients.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun client trouvé pour ce salon.'));
          }

          var clients = snapshot.data!.docs;

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              var clientData = clients[index].data() as Map<String, dynamic>;
              String clientName = clientData['name'] ?? 'Nom inconnu';
              String clientEmail = clientData['email'] ?? 'Email inconnu';

              return ListTile(
                leading: Icon(Icons.person, color: Colors.pink),
                title: Text(clientName),
                subtitle: Text(clientEmail),
                onTap: () {
                  // Ajouter des actions supplémentaires si nécessaire
                },
              );
            },
          );
        },
      ),
    );
  }
}

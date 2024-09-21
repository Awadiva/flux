import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'salon_detail_page.dart'; // Import de la page des détails du salon

class SalonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des salons')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('salons').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des salons.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun salon trouvé.'));
          } else {
            final salons = snapshot.data!.docs;

            return ListView.builder(
              itemCount: salons.length,
              itemBuilder: (context, index) {
                var salonData = salons[index].data() as Map<String, dynamic>;
                String salonName = salonData['salon_name'] ?? 'Nom du salon indisponible';
                String salonId = salons[index].id;

                return ListTile(
                  title: Text(salonName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalonDetailPage(salonId: salonId),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

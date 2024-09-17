import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutSalonPage extends StatelessWidget {
  final String salonId;

  AboutSalonPage({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos du salon'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('salons').doc(salonId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des informations.'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Salon non trouvé.'));
          } else {
            var salonData = snapshot.data!.data() as Map<String, dynamic>?;
            String salonName = salonData?['salon_name'] ?? 'Nom du salon indisponible';
            String salonAddress = salonData?['address'] ?? 'Adresse non disponible';
            String salonDescription = salonData?['description'] ?? 'Description non disponible';
            String gpn = salonData?['gpn'] ?? 'Localisation non disponible'; // GPN info

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom du salon: $salonName', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Adresse: $salonAddress', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Description: $salonDescription', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Localisation (GPN): $gpn', style: TextStyle(fontSize: 16)), // Display GPN
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

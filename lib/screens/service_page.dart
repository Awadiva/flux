import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePage extends StatelessWidget {
  final String salonId;

  ServicePage({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services et Tarifs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('salons')
            .doc(salonId)
            .collection('services')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des services.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun service trouvé.'));
          } else {
            var services = snapshot.data!.docs;

            return ListView(
              children: [
                _buildCategorySection(
                  'Make up',
                  services.where((service) => service['categorie'] == 'Maquillage').toList(),
                ),
                _buildCategorySection(
                  'Hair styling',
                  services.where((service) => service['categorie'] == 'Coiffure').toList(),
                ),
                _buildCategorySection(
                  'Nail care',
                  services.where((service) => service['categorie'] == 'Soins des ongles').toList(),
                ),
                _buildCategorySection(
                  'Cosmetology',
                  services.where((service) => service['categorie'] == 'Cosmétologie').toList(),
                ),
                _buildCategorySection(
                  'SPA procedures',
                  services.where((service) => service['categorie'] == 'Procédures SPA').toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCategorySection(String categoryName, List<QueryDocumentSnapshot> services) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(categoryName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: services.map((service) {
              var serviceData = service.data() as Map<String, dynamic>;
              String serviceName = serviceData['nom'] ?? 'Service sans nom';
              double servicePrice = serviceData['prix']?.toDouble() ?? 0.0;
              String imageUrl = serviceData['imageUrl'] ?? '';

              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: Colors.grey),
                title: Text(serviceName),
                subtitle: Text('€$servicePrice'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

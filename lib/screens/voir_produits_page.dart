import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoirProduitsPage extends StatelessWidget {
  final String salonId;

  VoirProduitsPage({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits du Salon'),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('salons')
            .doc(salonId)
            .collection('produits')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des produits.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun produit disponible.'));
          } else {
            var produits = snapshot.data!.docs;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: produits.length,
              itemBuilder: (context, index) {
                var produitData = produits[index].data() as Map<String, dynamic>;
                return _buildProductCard(
                  produitData['nom'],
                  produitData['image'],
                  produitData['prix'],
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(String nom, String imagePath, double prix) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imagePath,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            nom,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('€$prix', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

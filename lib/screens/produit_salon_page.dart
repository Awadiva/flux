import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProduitSalonPage extends StatelessWidget {
  final String salonId;

  ProduitSalonPage({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Produits du Salon'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddProductDialog(context);
            },
          ),
        ],
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
            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: produits.map((produit) {
                var produitData = produit.data() as Map<String, dynamic>;
                return _buildProductCard(context, produit.id, produitData['nom'], produitData['image'], produitData['prix']);
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String produitId, String nom, String imagePath, double prix) {
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
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showEditProductDialog(context, produitId, nom, prix);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteProduct(produitId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Méthode pour afficher le formulaire d'ajout de produit
  void _showAddProductDialog(BuildContext context) {
    final TextEditingController nomController = TextEditingController();
    final TextEditingController prixController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                controller: prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () async {
                if (nomController.text.isNotEmpty &&
                    prixController.text.isNotEmpty &&
                    imageController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('salons')
                      .doc(salonId)
                      .collection('produits')
                      .add({
                    'nom': nomController.text,
                    'prix': double.parse(prixController.text),
                    'image': imageController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher le formulaire de modification d'un produit
  void _showEditProductDialog(BuildContext context, String produitId, String nomActuel, double prixActuel) {
    final TextEditingController nomController = TextEditingController(text: nomActuel);
    final TextEditingController prixController = TextEditingController(text: prixActuel.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le produit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                controller: prixController,
                decoration: InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Mettre à jour'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('salons')
                    .doc(salonId)
                    .collection('produits')
                    .doc(produitId)
                    .update({
                  'nom': nomController.text,
                  'prix': double.parse(prixController.text),
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour supprimer un produit
  void _deleteProduct(String produitId) async {
    await FirebaseFirestore.instance
        .collection('salons')
        .doc(salonId)
        .collection('produits')
        .doc(produitId)
        .delete();
  }
}

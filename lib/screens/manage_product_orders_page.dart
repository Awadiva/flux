import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductOrdersPage extends StatelessWidget {
  final String selectedSalon;

  ManageProductOrdersPage({required this.selectedSalon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Commandes - $selectedSalon', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')  // Collection contenant les commandes
            .where('salon', isEqualTo: selectedSalon)  // Filtrer par salon
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des commandes'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune commande trouvée pour ce salon.'));
          }

          List<DocumentSnapshot> orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              String clientName = '${order['firstName']} ${order['lastName']}';
              String productName = order['product'] ?? 'Produit inconnu';
              DateTime orderDate = order['timestamp'].toDate();
              String deliveryAddress = order['location'] ?? 'Adresse non fournie';

              return ListTile(
                title: Text('Client: $clientName - Produit: $productName'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date de commande: ${orderDate.toString()}'),
                    Text('Adresse de livraison: $deliveryAddress'),
                  ],
                ),
                leading: Icon(Icons.shopping_cart),
              );
            },
          );
        },
      ),
    );
  }
}

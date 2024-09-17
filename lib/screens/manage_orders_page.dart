import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductOrdersPage extends StatelessWidget {
  final String selectedSalon;

  ManageProductOrdersPage({required this.selectedSalon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Commandes - $selectedSalon'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product_orders')
            .where('salon', isEqualTo: selectedSalon)
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
              String clientName = order['client_name'] ?? 'Client inconnu';
              String productName = order['product_name'] ?? 'Produit inconnu';
              DateTime orderDate = order['order_date'].toDate();
              String deliveryAddress = order['delivery_address'] ?? 'Adresse non fournie';

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

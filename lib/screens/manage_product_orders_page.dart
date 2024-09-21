import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductOrdersPage extends StatefulWidget {
  final String selectedSalon;

  ManageProductOrdersPage({required this.selectedSalon});

  @override
  State<ManageProductOrdersPage> createState() =>
      _ManageProductOrdersPageState();
}

class _ManageProductOrdersPageState extends State<ManageProductOrdersPage> {
  String salonName = "";
  Future<void> _fetchSalonName(String salonId) async {
    try {
      // Effectue une requête sur Firestore pour obtenir les détails du salon
      DocumentSnapshot salonSnapshot = await FirebaseFirestore.instance
          .collection('salons')
          .doc(salonId)
          .get();

      if (salonSnapshot.exists) {
        var salonData = salonSnapshot.data() as Map<String, dynamic>;
        setState(() {
          salonName = salonData['salon_name'] ?? 'Nom du salon inconnu';
        });
      } else {
        setState(() {
          salonName = "";
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération du salon: $e');
    }
  }

  @override
  void initState() {
    _fetchSalonName(widget.selectedSalon);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Commandes - $salonName',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders') // Collection contenant les commandes
            .where('salon',
                isEqualTo: widget.selectedSalon) // Filtrer par salon
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erreur lors du chargement des commandes'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('Aucune commande trouvée pour ce salon.'));
          }

          List<DocumentSnapshot> orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              String clientName = '${order['firstName']} ${order['lastName']}';
              String productName = order['product'] ?? 'Produit inconnu';
              DateTime orderDate = order['timestamp'].toDate();
              String deliveryAddress =
                  order['location'] ?? 'Adresse non fournie';

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

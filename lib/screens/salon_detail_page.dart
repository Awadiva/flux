import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'salon_info_page.dart'; 
import 'about_salon_page.dart'; 
//import 'service_page.dart'; 
import 'produit_salon_page.dart'; 
//import 'voir_produits_page.dart'; 
import 'add_service_page.dart'; 
import 'manage_clients_page.dart'; 
import 'ManageEstheticiansPage.dart'; 
import 'admin_login_page.dart'; 
import 'product_page.dart';
import 'services_page.dart'; // Importez la page des services


class SalonDetailPage extends StatelessWidget {
  final String salonId;

  SalonDetailPage({required this.salonId});

  // Fonction pour récupérer les données du salon à partir de Firestore
  Future<DocumentSnapshot> _getSalonData() async {
    return FirebaseFirestore.instance.collection('salons').doc(salonId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Détails du salon', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutSalonPage(salonId: salonId), // Assurez-vous que salonId est passé correctement
                ),
              );
            },
            child: Text('À propos', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesPage(), // Redirection vers ServicesPage
      ),
    );
  },
  child: Text('Services', style: TextStyle(color: Colors.white)),
),

          TextButton(
            onPressed: () {
              // Redirection vers la page ProductPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(), // Redirection vers ProductPage
                ),
              );
            },
            child: Text('Produits', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _showAdminLogin(context); // Afficher le formulaire de connexion admin
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getSalonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des détails du salon.'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Salon non trouvé.'));
          }

          var salonData = snapshot.data!.data() as Map<String, dynamic>;
          String salonName = salonData['salon_name'] ?? 'Nom du salon';

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/salon_background.jpeg'), 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nom: $salonName', style: TextStyle(fontSize: 22, color: Colors.white)),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Bienvenue au salon !',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 2, 42),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Fonction pour afficher le formulaire de connexion admin
 void _showAdminLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AdminLoginPage(
        salonId: salonId, // Passer l'ID du salon
        onLoginSuccess: () {
          _showMenuOptions(context); // Si la connexion réussit, afficher le menu des options
        },
      ),
    ),
  );
}


  // Afficher le menu des options après la connexion réussie
  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person, color: Colors.pink),
              title: Text('Gérer les clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageClientsPage(salonId: salonId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.pink),
              title: Text('Gérer les esthéticiennes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageEstheticiansPage(salonId: salonId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.build, color: Colors.pink),
              title: Text('Gérer les services'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServicePage(salonId: salonId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits, color: Colors.pink),
              title: Text('Gérer les produits'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProduitSalonPage(salonId: salonId), // Assurez-vous que salonId est passé correctement
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.pink),
              title: Text('Voir les rapports'),
              onTap: () {
                Navigator.pushNamed(context, '/viewReports');
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.pink),
              title: Text('Info du salon'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalonInfoPage(salonId: salonId), // Assurez-vous que salonId est passé correctement
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

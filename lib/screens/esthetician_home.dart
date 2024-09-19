import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Management',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/', // Définir la route initiale
      routes: {
        '/': (context) => HomePage(), // Page d'accueil ou de connexion
        '/estheticianHome': (context) => EstheticianHome(salonId: 'Salon Example'), // Page après l'inscription
        '/manageAppointments': (context) => ManageAppointmentsPage(), // Gestion des RDV
        '/manageProductOrders': (context) => ManageProductOrdersPage(), // Gestion des commandes
      },
    );
  }
}

// Page d'accueil ou de connexion (à personnaliser selon vos besoins)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil ou de connexion'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/estheticianHome');
          },
          child: Text('Aller à l\'accueil Esthéticienne'),
        ),
      ),
    );
  }
}

// Page pour gérer les RDV
class ManageAppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les RDV'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Text('Gestion des rendez-vous ici.'),
      ),
    );
  }
}

// Page pour gérer les commandes de produit
class ManageProductOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les commandes de produit'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Text('Gestion des commandes de produits ici.'),
      ),
    );
  }
}

// Page d'accueil esthéticienne après sélection d'un salon
class EstheticianHome extends StatelessWidget {
  final String salonId;

  EstheticianHome({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink, // Couleur de l'entête en rose
        title: Text(
          'Accueil Esthéticienne - $salonId', // Nom du salon sélectionné
          style: TextStyle(color: Colors.white), // Texte en blanc
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Image de fond à ajouter dans les assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal avec les boutons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Bouton en blanc
                    foregroundColor: Colors.pink, // Texte en rose
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Action pour gérer les RDV
                    Navigator.pushNamed(context, '/manageAppointments');
                  },
                  child: Text(
                    'Gérer les RDV',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Bouton en blanc
                    foregroundColor: Colors.pink, // Texte en rose
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Action pour gérer les commandes de produit
                    Navigator.pushNamed(context, '/manageProductOrders');
                  },
                  child: Text(
                    'Gérer les commandes de produit',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

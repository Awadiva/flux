import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import pour Firebase
import 'manage_appointments_page.dart'; // Import de la page RDV
import 'manage_product_orders_page.dart'; // Import de la page commandes

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
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/estheticianHome': (context) => EstheticianHome(salonId: 'Salon Example'),
        '/manageAppointments': (context) => ManageAppointmentsPage(selectedSalon: 'Salon Example'),
        // Retirer cette ligne, car vous passez le salonId dynamiquement à partir de la navigation
      },
    );
  }
}

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

// Page d'accueil esthéticienne après sélection d'un salon
class EstheticianHome extends StatefulWidget {
  final String salonId;

  EstheticianHome({required this.salonId});

  @override
  _EstheticianHomeState createState() => _EstheticianHomeState();
}

class _EstheticianHomeState extends State<EstheticianHome> {
  String salonName = ''; // Variable pour stocker le nom du salon

  @override
  void initState() {
    super.initState();
    _fetchSalonDetails(); // Récupérer les détails du salon
  }

  // Fonction pour récupérer le nom du salon à partir de Firebase
  void _fetchSalonDetails() async {
    DocumentSnapshot salonSnapshot = await FirebaseFirestore.instance
        .collection('salons')
        .doc(widget.salonId)
        .get();

    if (salonSnapshot.exists) {
      setState(() {
        salonName = salonSnapshot['salon_name']; // Récupérer le nom du salon
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          salonName.isNotEmpty
              ? 'Accueil Esthéticienne - $salonName'
              : 'Chargement...',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Ajouter l'image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Assurez-vous que l'image est bien dans le dossier assets
                fit: BoxFit.cover, // Adapte l'image à la taille de l'écran
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigation vers ManageAppointmentsPage avec le salonId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ManageAppointmentsPage(selectedSalon: widget.salonId),
                      ),
                    );
                  },
                  child: Text(
                    'Gérer les RDV',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                // Naviguer vers la page de gestion des commandes de produits
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ManageProductOrdersPage(selectedSalon: widget.salonId),
                      ),
                    );
                  },
                  child: Text(
                    'Gérer les commandes de produit',
                    style: TextStyle(fontSize: 18),
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

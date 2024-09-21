import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'client_home.dart'; // Importer la page d'accueil du client
import 'notifications_page.dart'; // Importer la page des messages
import 'reviews_page.dart'; // Importer la page des avis

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String salonName="";
  int _selectedIndex = 3; // Index pour l'onglet "Profil"

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fonction pour charger les données utilisateur
  // _loadUserData() async {
  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection('clients').doc(user.uid).get();
  //     _nameController.text = snapshot['name'];
  //     _emailController.text = user.email ?? '';
  //     salonName= snapshot['salon'];
  //   }
  // }
  Future<void> _loadUserData() async {
  User? user = _auth.currentUser; // Récupérer l'utilisateur actuel
  if (user != null) {
    // Récupérer les informations de l'utilisateur dans la collection 'clients'
    DocumentSnapshot snapshot = await _firestore.collection('clients').doc(user.uid).get();

    // Charger les données dans les contrôleurs de texte
    _nameController.text = snapshot['name'];
    _emailController.text = user.email ?? '';

    String salonId = snapshot['salon'];

    // Requête Firebase pour récupérer le nom du salon correspondant à l'ID
    if (salonId.isNotEmpty) {
      DocumentSnapshot salonSnapshot = await _firestore.collection('salons').doc(salonId).get();

      // Vérifier si le salon existe et récupérer son nom
      if (salonSnapshot.exists) {
         salonName = salonSnapshot['salon_name']; // Assurez-vous que le champ est bien 'salon_name'
        print('Nom du salon: $salonName');
      } else {
        print('Salon non trouvé.');
      }
    }
  }
}


  // Fonction pour mettre à jour le profil
  _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('clients').doc(user.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profil mis à jour avec succès!',style: TextStyle(color: Colors.white)),
      ));
    }
  }

  // Fonction pour gérer la navigation de la barre de navigation inférieure
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientHome(selectedSalon:salonName ,)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotificationsPage(salonName: salonName,)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReviewsPage(selectedSalon: salonName,)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Client'),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ClientHome(selectedSalon: salonName,)),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: false,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Mettre à jour le profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.pink,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            tooltip: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Avis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

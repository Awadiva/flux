import 'package:flutter/material.dart';
import 'book_appointment.dart'; // Assurez-vous que BookAppointmentPage est bien importée
import 'notifications_page.dart'; // Importer la page des messages
import 'reviews_page.dart'; // Importer la page des avis
import 'client_profile.dart'; // Importer la page du profil du client

class ClientHome extends StatefulWidget {
  final String selectedSalon;

  ClientHome({required this.selectedSalon});

  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int _selectedIndex =
      0; // Variable pour suivre l'index de l'élément sélectionné

  // Méthode pour changer de page en fonction de l'index sélectionné
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Naviguer vers les pages respectives
    switch (_selectedIndex) {
      case 0:
        // Retour à la même page sans créer une nouvelle instance
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationsPage(
                    salonName: widget.selectedSalon,
                  )),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewsPage(
                    selectedSalon: widget.selectedSalon,
                  )),
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
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',
                height: 100), // Logo au centre
          ],
        ),
      ),
      body: Stack(
        children: [
          // Image en arrière-plan
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/back.png'), // Remplacez par votre image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu du corps
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page Prendre Rendez-vous
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookAppointmentPage(salonId: widget.selectedSalon
                              // Ajoutez l'ID du salon si nécessaire
                              ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Bienvenue, Client ! Réservez vos services ici.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black.withOpacity(0.7),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
            tooltip: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            tooltip: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Avis',
            tooltip: 'Avis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            tooltip: 'Profil',
          ),
        ],
      ),
    );
  }
}

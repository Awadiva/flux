import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'client_home.dart'; // Importer la page client_home
import 'reviews_page.dart'; // Importer la page des avis
import 'client_profile.dart'; // Importer la page du profil client

class NotificationsPage extends StatefulWidget {
  
final String salonName;

  NotificationsPage({required this.salonName});
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 1; // Index pour la navigation

  // Méthode pour changer de page en fonction de l'index sélectionné
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Naviguer vers les pages respectives
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientHome(selectedSalon: widget.salonName,)),
        );
        break;
      case 1:
        // Rester sur la page actuelle (Notifications)
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReviewsPage(selectedSalon: widget.salonName,)),
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

  // Fonction pour récupérer les notifications de Firestore
  Stream<QuerySnapshot> _getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ClientHome(selectedSalon: widget.salonName,)),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(child: Text('Aucune notification pour le moment.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return ListTile(
                title: Text(notification['title']),
                subtitle: Text(notification['message']),
                trailing: Icon(
                  notification['type'] == 'accepted' ? Icons.check_circle : Icons.cancel,
                  color: notification['type'] == 'accepted' ? Colors.green : Colors.red,
                ),
                onTap: () {
                  // Logique pour afficher les détails de la notification ou rediriger vers une page
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
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

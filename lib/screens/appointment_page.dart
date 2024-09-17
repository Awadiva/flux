import 'package:flutter/material.dart';
import 'register_client_page.dart'; // Import the registration page
import 'login_page.dart'; // Import the login page

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prendre rendez-vous')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterClientPage()),
                );
              },
              child: Text('Inscription'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Connexion'),
            ),
          ],
        ),
      ),
    );
  }
}

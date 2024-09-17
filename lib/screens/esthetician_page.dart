import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flux/screens/esthetician_registration_page.dart';
import 'package:flux/screens/esthetician_login_page.dart';
class EstheticianPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une esthéticienne')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstheticianRegistrationPage()),
                );
              },
              child: Text('Inscription'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstheticianLoginPage()),
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

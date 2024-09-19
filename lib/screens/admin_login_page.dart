import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart'; // Pour le hashage des mots de passe
import 'dart:convert'; // Pour encoder en UTF8

class AdminLoginPage extends StatefulWidget {
  final String salonId;
  final VoidCallback onLoginSuccess;

  AdminLoginPage({required this.salonId, required this.onLoginSuccess});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Fonction pour hacher le mot de passe
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); 
    return sha256.convert(bytes).toString();
  }

  // Fonction de connexion de l'administrateur
  void _loginAdmin() async {
    String enteredEmail = _emailController.text.trim();
    String enteredPassword = _passwordController.text.trim();
    String enteredPasswordHash = _hashPassword(enteredPassword); // Hache le mot de passe entré

    try {
      // Récupérer les données du salon correspondant à l'ID
      DocumentSnapshot salonDoc = await FirebaseFirestore.instance
          .collection('salons')
          .doc(widget.salonId)
          .get();

      if (salonDoc.exists) {
        Map<String, dynamic> salonData = salonDoc.data() as Map<String, dynamic>;
        String adminEmail = salonData['admin_email'];
        String adminPasswordHash = salonData['admin_password_hash'];

        // Vérifier si l'email et le mot de passe haché correspondent
        if (enteredEmail == adminEmail && enteredPasswordHash == adminPasswordHash) {
          widget.onLoginSuccess(); // Connexion réussie
          Navigator.pop(context); // Fermer la page de connexion
        } else {
          setState(() {
            _errorMessage = 'Email ou mot de passe incorrect.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Salon non trouvé.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la connexion. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Connexion Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginAdmin,
              child: Text('Se connecter'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

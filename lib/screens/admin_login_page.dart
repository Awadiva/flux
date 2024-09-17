import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart'; // Import pour hashage
import 'dart:convert'; // pour utf8.encode()

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

  // Fonction pour hasher le mot de passe
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Fonction de connexion de l'administrateur
  void _loginAdmin() async {
    String enteredEmail = _emailController.text;
    String enteredPassword = _passwordController.text;

    try {
      // Récupérer les données du salon depuis Firestore
      QuerySnapshot salonDocs = await FirebaseFirestore.instance
          .collection('salons')
          .where('admin_email', isEqualTo: enteredEmail)
          .get();

      if (salonDocs.docs.isNotEmpty) {
        var salonData = salonDocs.docs.first.data() as Map<String, dynamic>;
        String adminEmail = salonData['admin_email'];
        String adminPasswordHash = salonData['admin_password_hash'];

        // Hasher le mot de passe entré pour le comparer au hash stocké
        String enteredPasswordHash = hashPassword(enteredPassword);

        // Vérifier si l'email et le mot de passe sont corrects
        if (enteredEmail == adminEmail && enteredPasswordHash == adminPasswordHash) {
          // Connexion réussie
          widget.onLoginSuccess();
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

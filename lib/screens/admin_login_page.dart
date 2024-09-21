import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginPage extends StatefulWidget {
  final String salonId;
  final VoidCallback onLoginSuccess; // Pour afficher le menu après connexion

  AdminLoginPage({required this.salonId, required this.onLoginSuccess});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _obscurePassword = true; // Variable pour gérer l'affichage du mot de passe

  Future<void> _handleLogin() async {
    String enteredEmail = _emailController.text.trim();
    String enteredPassword = _passwordController.text.trim();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    try {
      // Cherche dans la collection 'salons' l'email de l'admin pour un salon donné
      DocumentSnapshot salonDoc = await FirebaseFirestore.instance
          .collection('salons')
          .doc(widget.salonId)
          .get();

      if (salonDoc.exists) {
        Map<String, dynamic> adminData = salonDoc.data() as Map<String, dynamic>;
        String storedPassword = adminData['admin_password'];

        // Vérifier si le mot de passe saisi correspond à celui enregistré
        if (enteredPassword == storedPassword &&
            adminData['admin_email'] == enteredEmail) {
          // Connexion réussie
          widget.onLoginSuccess(); // Appelle la fonction pour afficher le menu
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
        title: Text('Connexion Admin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.login, size: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword; // Change l'état
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}

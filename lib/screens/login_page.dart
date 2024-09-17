import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'client_home.dart'; // Import the client home page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSalon;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Ajouter un listener sur l'emailController pour déclencher une recherche dans Firestore
    _emailController.addListener(() {
      _fetchSalonForEmail(_emailController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire de connexion'),
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
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mot de passe'),
            ),
            SizedBox(height: 20),
            _selectedSalon != null
                ? Text('Salon sélectionné: $_selectedSalon')
                : _errorMessage != null
                ? Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            )
                : Text('Aucun salon trouvé'),
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

  Future<void> _fetchSalonForEmail(String email) async {
    if (email.isEmpty) {
      setState(() {
        _selectedSalon = null;
        _errorMessage = null;
      });
      return;
    }

    try {
      // Cherche dans la collection 'clients' par email pour récupérer le salon sélectionné
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clients')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var clientData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _selectedSalon = clientData['salon'] ?? 'Salon inconnu';
          _errorMessage = null;
        });
      } else {
        setState(() {
          _selectedSalon = null;
          _errorMessage = 'Aucun salon trouvé pour cet email';
        });
      }
    } catch (e) {
      setState(() {
        _selectedSalon = null;
        _errorMessage = 'Erreur lors de la récupération du salon';
      });
      print('Erreur lors de la récupération du salon pour l\'email: $e');
    }
  }

  void _handleLogin() {
    if (_selectedSalon != null) {
      // Ici, vous pouvez ajouter la logique pour vérifier les détails de connexion
      // Vérifier également le mot de passe si nécessaire

      // Rediriger vers ClientHomePage après la connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClientHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un email valide ou un mot de passe correct.')),
      );
    }
  }
}

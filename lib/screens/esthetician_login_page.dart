import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'esthetician_home.dart'; // Import the esthetician home page

class EstheticianLoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<EstheticianLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSalon;
  String? _errorMessage;
  String? salonName;
  bool _obscurePassword =
      true; // Ajout de cette variable pour masquer/afficher le mot de passe
  Future<void> _fetchSalonName(String salonId) async {
    if (salonId.isEmpty) {
      setState(() {
        _selectedSalon = null;
        _errorMessage = null;
      });
      return;
    }

    try {
      // Effectue une requête sur Firestore pour obtenir les détails du salon
      DocumentSnapshot salonSnapshot = await FirebaseFirestore.instance
          .collection('salons')
          .doc(salonId)
          .get();

      if (salonSnapshot.exists) {
        var salonData = salonSnapshot.data() as Map<String, dynamic>;
        setState(() {
          salonName = salonData['salon_name'] ?? 'Nom du salon inconnu';
          _errorMessage = null;
        });
      } else {
        setState(() {
          salonName = null;
          _errorMessage = 'Salon non trouvé';
        });
      }
    } catch (e) {
      setState(() {
        _selectedSalon = null;
        _errorMessage = 'Erreur lors de la récupération du nom du salon';
      });
      print('Erreur lors de la récupération du salon: $e');
    }
  }

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
              obscureText:
                  _obscurePassword, // Utilisation de la variable pour masquer/afficher le mot de passe
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                          !_obscurePassword; // Bascule entre afficher et masquer
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _selectedSalon != null
                ? Text('Salon sélectionné: $salonName')
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
      // Cherche dans la collection 'estheticians' par email pour récupérer le salon sélectionné
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('estheticians')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var clientData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _selectedSalon = clientData['salonId'] ?? 'Salon inconnu';
          _errorMessage = null;
        });
        // Appeler la fonction pour récupérer le nom du salon
        if (_selectedSalon != null && _selectedSalon != 'Salon inconnu') {
          _fetchSalonName(_selectedSalon!);
          print(_selectedSalon);
        } else {
          print(_selectedSalon);
          setState(() {
            _selectedSalon = null;
            _errorMessage = 'Aucun salon trouvé pour cet email';
          });
        }
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
      // Après une connexion réussie, rediriger vers la page EstheticianHome
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EstheticianHome(
              salonId: _selectedSalon!), // Passe le salon sélectionné
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Veuillez entrer un email valide ou un mot de passe correct.')),
      );
    }
  }
}

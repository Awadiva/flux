import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flux/screens/esthetician_home.dart'; // Import the home page

class EstheticianLoginPage extends StatefulWidget {
  @override
  _EstheticianLoginPageState createState() => _EstheticianLoginPageState();
}

class _EstheticianLoginPageState extends State<EstheticianLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSalon;
  List<String> _salons = [];

  @override
  void initState() {
    super.initState();
    _fetchSalons();
  }

  Future<void> _fetchSalons() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('salons').get();
      List<String> salons = snapshot.docs.map((doc) => doc['salon_name'] as String).toList();
      setState(() {
        _salons = salons;
      });
    } catch (e) {
      print('Error fetching salons: $e');
    }
  }

  Future<void> _loginEsthetician() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('estheticians')
          .where('email', isEqualTo: _emailController.text.trim())
          .where('password', isEqualTo: _passwordController.text.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
        var estheticianDoc = snapshot.docs.first;
        var data = estheticianDoc.data() as Map<String, dynamic>;
        String? registeredSalon = data['registered_salon'] as String?;

        if (registeredSalon != null && _salons.contains(registeredSalon)) {
          setState(() {
            _selectedSalon = registeredSalon;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connexion réussie. Salon sélectionné: $_selectedSalon')),
          );

          // Check if a salon is selected before navigating
          if (_selectedSalon != null) {
            // Redirect to EstheticianHomePage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EstheticianHome(selectedSalon: _selectedSalon!), // Safe usage
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Veuillez sélectionner un salon.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Salon enregistré non trouvé')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion Esthéticienne')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_salons.isNotEmpty)
              DropdownButton<String>(
                value: _selectedSalon,
                hint: Text('Choisissez un salon'),
                items: _salons.map((salon) {
                  return DropdownMenuItem<String>(
                    value: salon,
                    child: Text(salon),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSalon = value;
                  });
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginEsthetician,
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}

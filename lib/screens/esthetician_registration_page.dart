import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'esthetician_home.dart'; // Import de la page EstheticianHome

class EstheticianRegistrationPage extends StatefulWidget {
  @override
  _EstheticianRegistrationPageState createState() => _EstheticianRegistrationPageState();
}

class _EstheticianRegistrationPageState extends State<EstheticianRegistrationPage> {
  String? _selectedSalonId;
  Map<String, String> _salonMap = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';
  bool _obscurePassword = true; // Variable pour contrôler l'affichage du mot de passe

  @override
  void initState() {
    super.initState();
    _loadSalonNames();
  }

  // Fonction pour récupérer les salons depuis Firestore
  Future<void> _loadSalonNames() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('salons').get();
    Map<String, String> salons = {
      for (var doc in snapshot.docs) doc.id: doc['salon_name'] as String,
    };
    setState(() {
      _salonMap = salons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription Esthéticienne')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom complet'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Adresse e-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              IntlPhoneField(
                decoration: InputDecoration(labelText: 'Téléphone'),
                initialCountryCode: 'FR', // Pays par défaut
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                },
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword, // Utilisation de la variable pour masquer ou afficher le mot de passe
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Inverse l'état d'affichage du mot de passe
                      });
                    },
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Choisissez un salon'),
                value: _selectedSalonId,
                items: _salonMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSalonId = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _registerEsthetician();
                },
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerEsthetician() async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedSalonId != null &&
        _phoneNumber.isNotEmpty) {
      try {
        DocumentReference estheticianRef = await FirebaseFirestore.instance
            .collection('estheticians')
            .add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneNumber,
          'password': _passwordController.text.trim(),
          'salonId': _selectedSalonId,
        });

        await FirebaseFirestore.instance
            .collection('salons')
            .doc(_selectedSalonId)
            .update({
          'estheticians': FieldValue.arrayUnion([estheticianRef.id]),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Esthéticienne inscrite avec succès!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EstheticianHome(salonId: _selectedSalonId!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription de l\'esthéticienne.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'esthetician_home.dart'; // Import the esthetician home page

class EstheticianRegistrationPage extends StatefulWidget {
  @override
  _EstheticianRegistrationPageState createState() => _EstheticianRegistrationPageState();
}

class _EstheticianRegistrationPageState extends State<EstheticianRegistrationPage> {
  String? _selectedSalon;
  List<String> _salonNames = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _loadSalonNames();
  }

  // Fonction pour récupérer les salons de Firestore
  Future<void> _loadSalonNames() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('salons').get();
    List<String> salons = snapshot.docs.map((doc) => doc['salon_name'] as String).toList();
    setState(() {
      _salonNames = salons;
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
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mot de passe'),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Choisissez un salon'),
                value: _selectedSalon,
                items: _salonNames.map((String salon) {
                  return DropdownMenuItem<String>(
                    value: salon,
                    child: Text(salon),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSalon = newValue;
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
      _selectedSalon != null &&
      _phoneNumber.isNotEmpty) {
    try {
      // Crée un document esthéticienne dans Firestore
      DocumentReference estheticianRef = await FirebaseFirestore.instance
          .collection('estheticians')
          .add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneNumber,
        'password': _passwordController.text.trim(),
        'salon': _selectedSalon,
      });

      // Ajoute l'ID de l'esthéticienne à la liste des esthéticiennes du salon
      await FirebaseFirestore.instance
          .collection('salons')
          .doc(_selectedSalon) // ID du salon sélectionné
          .update({
        'estheticians': FieldValue.arrayUnion([estheticianRef.id]), // Ajoute l'ID de l'esthéticienne
      });

      // Message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Esthéticienne inscrite avec succès!')),
      );

      // Redirige vers la page d'accueil des esthéticiennes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EstheticianHome(selectedSalon: _selectedSalon!), // Passe le salon sélectionné
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

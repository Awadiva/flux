import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddSalonPage extends StatefulWidget {
  @override
  _AddSalonPageState createState() => _AddSalonPageState();
}

class _AddSalonPageState extends State<AddSalonPage> {
  final TextEditingController _salonNameController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _adminPasswordController = TextEditingController(); // Ajout du champ mot de passe
  String _adminPhoneNumber = '';

  // Fonction pour ajouter un salon avec les informations de l'admin à Firestore
  Future<void> _addSalon() async {
    if (_salonNameController.text.isNotEmpty &&
        _adminNameController.text.isNotEmpty &&
        _adminEmailController.text.isNotEmpty &&
        _adminPhoneNumber.isNotEmpty &&
        _adminPasswordController.text.isNotEmpty) { // Vérification du mot de passe
      await FirebaseFirestore.instance.collection('salons').add({
        'salon_name': _salonNameController.text.trim(),
        'admin_name': _adminNameController.text.trim(),
        'admin_email': _adminEmailController.text.trim(),
        'admin_phone': _adminPhoneNumber.trim(),
        'admin_password': _adminPasswordController.text.trim(), // Ajout du mot de passe
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salon ajouté avec succès!')),
      );

      // Efface tous les champs de texte après l'ajout
      _salonNameController.clear();
      _adminNameController.clear();
      _adminEmailController.clear();
      _adminPhoneNumber = ''; // Efface le numéro de téléphone
      _adminPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Salon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations de l\'Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _adminNameController,
                decoration: InputDecoration(labelText: 'Nom de l\'admin'),
              ),
              TextField(
                controller: _adminEmailController,
                decoration: InputDecoration(labelText: 'Email de l\'admin'),
                keyboardType: TextInputType.emailAddress,
              ),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Téléphone de l\'admin',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'FR', // Code du pays par défaut
                onChanged: (phone) {
                  _adminPhoneNumber = phone.completeNumber;
                },
              ),
              TextField(
                controller: _adminPasswordController, // Nouveau champ
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mot de passe de l\'admin'),
              ),
              SizedBox(height: 20),
              Text(
                'Informations du Salon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _salonNameController,
                decoration: InputDecoration(labelText: 'Nom du salon'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSalon,
                child: Text('Ajouter le salon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

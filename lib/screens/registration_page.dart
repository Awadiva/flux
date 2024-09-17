import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  final String salonType;

  RegistrationPage({required this.salonType});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? _selectedSalon;
  List<String> _salonNames = [];

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
      appBar: AppBar(
        title: Text('Formulaire d\'inscription (${widget.salonType})'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nom complet'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Adresse e-mail'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
            ),
            TextField(
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
                // Logic to handle form submission
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}

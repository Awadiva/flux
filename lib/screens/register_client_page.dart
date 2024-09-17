import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'client_home.dart'; // Import the client home page
import 'manage_clients_page.dart'; // Import the ManageClientsPage

class RegisterClientPage extends StatefulWidget {
  @override
  _RegisterClientPageState createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSalonId; // Use the salon ID instead of name
  String _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire d\'inscription'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.person_add, size: 40),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom complet'),
            ),
            IntlPhoneField(
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
              initialCountryCode: 'FR',
              onChanged: (phone) {
                _phoneNumber = phone.completeNumber;
              },
            ),
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
            FutureBuilder<List<QueryDocumentSnapshot>>(
              future: _fetchSalonDocs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur lors de la récupération des salons');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Aucun salon disponible');
                } else {
                  return DropdownButton<String>(
                    value: _selectedSalonId,
                    hint: Text('Choisissez un salon'),
                    items: snapshot.data!.map((salonDoc) {
                      return DropdownMenuItem<String>(
                        value: salonDoc.id, // Use document ID
                        child: Text(salonDoc['salon_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSalonId = value;
                      });
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _registerClient(context);
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour récupérer les documents de salons disponibles
  Future<List<QueryDocumentSnapshot>> _fetchSalonDocs() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('salons').get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching salons: $e');
      return [];
    }
  }

  // Fonction pour enregistrer un nouveau client
  Future<void> _registerClient(BuildContext context) async {
    if (_nameController.text.isNotEmpty &&
        _phoneNumber.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedSalonId != null) {
      try {
        // Crée un document client dans Firestore
        DocumentReference clientRef =
        await FirebaseFirestore.instance.collection('clients').add({
          'name': _nameController.text.trim(),
          'phone': _phoneNumber,
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'salon': _selectedSalonId,
        });

        // Ajoute le client à la liste des clients du salon sélectionné
        await FirebaseFirestore.instance
            .collection('salons')
            .doc(_selectedSalonId) // Utilise l'ID du salon
            .update({
          'clients': FieldValue.arrayUnion([clientRef.id]),
        });

        // Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Client inscrit avec succès!')),
        );

        // Redirection vers ClientHome
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClientHome(),
          ),
        );

        // Redirection vers ManageClientsPage après inscription réussie
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageClientsPage(salonId: _selectedSalonId!),
          ),
        );
      } catch (e) {
        print('Erreur lors de l\'inscription: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription du client.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
    }
  }
}

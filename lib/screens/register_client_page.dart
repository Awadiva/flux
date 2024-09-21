import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'client_home.dart'; // Import de la page d'accueil du client

class RegisterClientPage extends StatefulWidget {
  @override
  _RegisterClientPageState createState() => _RegisterClientPageState();
}

class _RegisterClientPageState extends State<RegisterClientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSalonId; // ID du salon sélectionné
  String _phoneNumber = '';
  bool _obscurePassword = true; // Variable pour masquer/afficher le mot de passe

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
              obscureText: _obscurePassword, // Utilisation de la variable pour masquer/afficher
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword; // Inverse l'état de l'icône œil
                    });
                  },
                ),
              ),
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
                        value: salonDoc.id, // Utiliser l'ID du document
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
      print('Erreur lors de la récupération des salons: $e');
      return [];
    }
  }

  // Fonction pour enregistrer un nouveau client
  // Future<void> _registerClient(BuildContext context) async {
  //   if (_nameController.text.isNotEmpty &&
  //       _phoneNumber.isNotEmpty &&
  //       _emailController.text.isNotEmpty &&
  //       _passwordController.text.isNotEmpty &&
  //       _selectedSalonId != null) {
  //     try {
  //       // Crée un document client dans Firestore
  //       DocumentReference clientRef =
  //           await FirebaseFirestore.instance.collection('clients').add({
  //         'name': _nameController.text.trim(),
  //         'phone': _phoneNumber,
  //         'email': _emailController.text.trim(),
  //         'password': _passwordController.text.trim(),
  //         'salon': _selectedSalonId, // Associer le client au salon sélectionné
  //       });

  //       // Ajoute le client à la liste des clients du salon sélectionné
  //       await FirebaseFirestore.instance
  //           .collection('salons')
  //           .doc(_selectedSalonId) // Utilise l'ID du salon
  //           .update({
  //         'clients': FieldValue.arrayUnion([clientRef.id]),
  //       });

  //       // Message de succès
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Client inscrit avec succès!')),
  //       );

        
  //       // Redirection vers la page d'accueil du client
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ClientHome(selectedSalon: ,),
  //         ),
  //       );
  //     } catch (e) {
  //       print('Erreur lors de l\'inscription: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Erreur lors de l\'inscription du client.')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Veuillez remplir tous les champs.')),
  //     );
  //   }
  // }
   // Register a new client
  Future<void> _registerClient(BuildContext context) async {
    if (_nameController.text.isNotEmpty &&
        _phoneNumber.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedSalonId != null) {
      try {
        // Create a client document in Firestore
        DocumentReference clientRef = await FirebaseFirestore.instance.collection('clients').add({
          'name': _nameController.text.trim(),
          'phone': _phoneNumber,
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'salon': _selectedSalonId, // Associate the client with the selected salon
        });

        // Add the client to the selected salon's list of clients
        await FirebaseFirestore.instance.collection('salons').doc(_selectedSalonId).update({
          'clients': FieldValue.arrayUnion([clientRef.id]),
        });

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Client inscrit avec succès!')),
        );

        // Fetch the salon's name and navigate to ClientHome
        await _navigateToClientHome(context);

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

  // Navigate to ClientHome with the selected salon's name
  Future<void> _navigateToClientHome(BuildContext context) async {
    try {
      // Fetch the salon document to retrieve its name
      DocumentSnapshot salonSnapshot =
          await FirebaseFirestore.instance.collection('salons').doc(_selectedSalonId).get();

      if (salonSnapshot.exists) {
        String salonName = salonSnapshot['salon_name'];

        // Navigate to ClientHome and pass the salon's name
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClientHome(selectedSalon: salonName),
          ),
        );
      } else {
        print('Salon introuvable');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Salon introuvable.')),
        );
      }
    } catch (e) {
      print('Erreur lors de la navigation vers ClientHome: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la navigation vers la page d\'accueil du client.')),
      );
    }
  }

}

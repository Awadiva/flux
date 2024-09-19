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
  bool _isLoadingSalons = true; // Indicateur de chargement des salons

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _loadSalonNames();
  }

  // Fonction pour récupérer les salons de Firestore avec leurs IDs
  Future<void> _loadSalonNames() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('salons').get();
      Map<String, String> salons = {
        for (var doc in snapshot.docs) doc.id: doc['salon_name'] as String,
      };
      setState(() {
        _salonMap = salons;
        _isLoadingSalons = false; // Terminer le chargement des salons
      });
    } catch (e) {
      // En cas d'erreur, mettre fin au chargement et afficher un message d'erreur
      setState(() {
        _isLoadingSalons = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des salons.')),
      );
    }
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
              SizedBox(height: 20),
              // Vérification de l'état de chargement des salons
              _isLoadingSalons
                  ? CircularProgressIndicator() // Indicateur de chargement pendant que les salons sont récupérés
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Choisissez un salon'),
                      value: _selectedSalonId,
                      items: _salonMap.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key, // L'ID du salon est utilisé comme valeur
                          child: Text(entry.value), // Le nom du salon est affiché
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
        // Crée un document esthéticienne dans Firestore
        DocumentReference estheticianRef = await FirebaseFirestore.instance
            .collection('estheticians')
            .add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneNumber,
          'password': _passwordController.text.trim(),
          'salon_id': _selectedSalonId,
        });

        // Ajoute l'ID de l'esthéticienne à la liste des esthéticiennes du salon
        await FirebaseFirestore.instance
            .collection('salons')
            .doc(_selectedSalonId)
            .update({
          'estheticians': FieldValue.arrayUnion([estheticianRef.id]), // Ajoute l'ID de l'esthéticienne
        });

        // Message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Esthéticienne inscrite avec succès!')),
        );

        // Vérification supplémentaire avant de naviguer
        if (_selectedSalonId != null) {
          // Redirige vers la page d'accueil des esthéticiennes
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EstheticianHome(salonId: _selectedSalonId!), // Passe l'ID du salon sélectionné
            ),
          );
        }
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalonInfoPage extends StatefulWidget {
  final String salonId;

  SalonInfoPage({required this.salonId});

  @override
  _SalonInfoPageState createState() => _SalonInfoPageState();
}

class _SalonInfoPageState extends State<SalonInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _gpnController = TextEditingController(); // GPN (Geolocation) controller

  @override
  void initState() {
    super.initState();
    _loadSalonInfo();
  }

  void _loadSalonInfo() async {
    DocumentSnapshot salonSnapshot = await FirebaseFirestore.instance.collection('salons').doc(widget.salonId).get();
    if (salonSnapshot.exists) {
      var salonData = salonSnapshot.data() as Map<String, dynamic>;
      _nameController.text = salonData['salon_name'] ?? '';
      _addressController.text = salonData['address'] ?? '';
      _descriptionController.text = salonData['description'] ?? '';
      _gpnController.text = salonData['gpn'] ?? ''; // Load GPN if available
    }
  }

  void _saveSalonInfo() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('salons').doc(widget.salonId).set({
        'salon_name': _nameController.text,
        'address': _addressController.text,
        'description': _descriptionController.text,
        'gpn': _gpnController.text, // Save GPN data
      });
      Navigator.pop(context); // Return to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Info du Salon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom du Salon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du salon';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'adresse';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _gpnController,
                decoration: InputDecoration(labelText: 'GPN (Localisation)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSalonInfo,
                child: Text('Enregistrer les informations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

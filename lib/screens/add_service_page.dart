import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddServicePage extends StatefulWidget {
  final String salonId;

  AddServicePage({required this.salonId});

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  String _serviceName = '';
  String _serviceCategory = '';
  double _servicePrice = 0.0;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> categories = ['Maquillage', 'Coiffure', 'Soins des ongles', 'Cosmétologie', 'Procédures SPA'];

  // Fonction pour sélectionner une image depuis la galerie ou prendre une photo via la caméra
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Utiliser file_picker pour les plateformes web et desktop
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.bytes != null) {
        // Pour le web, utiliser les bytes (données binaires) au lieu d'un fichier File
        setState(() {
          _imageFile = File(result.files.single.path!); // Cela fonctionne pour le desktop
        });
      }
    } else {
      // Utiliser image_picker pour Android/iOS
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choisir depuis la galerie'),
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context); // Fermer le bottom sheet après sélection
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Prendre une photo'),
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context); // Fermer le bottom sheet après sélection
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _addService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Téléchargement de l'image vers Firebase Storage
      String imageUrl = '';
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('salon_services_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Enregistrer le service dans Firestore
      await FirebaseFirestore.instance
          .collection('salons')
          .doc(widget.salonId)
          .collection('services')
          .add({
        'nom': _serviceName,
        'categorie': _serviceCategory,
        'prix': _servicePrice,
        'imageUrl': imageUrl, // Lien de l'image téléchargée
      });

      // Message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service ajouté avec succès')));

      // Remettre à zéro le formulaire
      _formKey.currentState!.reset();
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom du service'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de service';
                    }
                    return null;
                  },
                  onSaved: (value) => _serviceName = value!,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Catégorie'),
                  value: _serviceCategory.isNotEmpty ? _serviceCategory : null,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _serviceCategory = value!),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une catégorie';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prix (€)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Veuillez entrer un prix valide';
                    }
                    return null;
                  },
                  onSaved: (value) => _servicePrice = double.parse(value!),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile == null
                      ? Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: Icon(Icons.camera_alt, size: 50),
                        )
                      : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addService,
                  child: Text('Ajouter Service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

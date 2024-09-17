import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSalonPage extends StatefulWidget {
  final String salonId;

  EditSalonPage({required this.salonId});

  @override
  _EditSalonPageState createState() => _EditSalonPageState();
}

class _EditSalonPageState extends State<EditSalonPage> {
  final _formKey = GlobalKey<FormState>();
  String? _salonName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le salon'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('salons').doc(widget.salonId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var salonData = snapshot.data!.data() as Map<String, dynamic>;
          _salonName = salonData['salon_name'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _salonName,
                    decoration: InputDecoration(labelText: 'Nom du salon'),
                    onSaved: (value) {
                      _salonName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom de salon';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveSalon,
                    child: Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveSalon() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await FirebaseFirestore.instance
            .collection('salons')
            .doc(widget.salonId)
            .update({'salon_name': _salonName});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Salon mis à jour avec succès')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du salon')),
        );
      }
    }
  }
}

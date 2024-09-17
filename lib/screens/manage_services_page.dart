import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageServicesPage extends StatelessWidget {
  final TextEditingController _serviceController = TextEditingController();

  void _addService(BuildContext context) {
    String serviceName = _serviceController.text.trim();
    if (serviceName.isNotEmpty) {
      FirebaseFirestore.instance.collection('services').add({'name': serviceName});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service ajouté avec succès !')),
      );
      _serviceController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom de service.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Services',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(
                labelText: 'Nom du service',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _addService(context),
              child: Text('Ajouter Service',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('services').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var services = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      var service = services[index];

                      return ListTile(
                        title: Text(service['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('services').doc(service.id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Service supprimé avec succès !')),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

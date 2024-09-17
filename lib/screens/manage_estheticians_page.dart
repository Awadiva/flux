import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageEstheticiansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Esthéticiennes',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Filtrer les utilisateurs avec le rôle 'esthetician'
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'esthetician')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue.'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final estheticians = snapshot.data!.docs;

          return ListView.builder(
            itemCount: estheticians.length,
            itemBuilder: (context, index) {
              var esthetician = estheticians[index];
              return ListTile(
                title: Text(esthetician['name']),
                subtitle: Text(esthetician['email']),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des salons'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('salons').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((salon) {
              return ListTile(
                title: Text(salon['salon_name']),
                subtitle: Text('Admin: ${salon['admin_name']}'),
                onTap: () {
                  // Naviguer vers les détails du salon ou autre action
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

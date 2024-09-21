import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAppointmentsPage extends StatelessWidget {
  final String selectedSalon;

  ManageAppointmentsPage({required this.selectedSalon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les RDV - $selectedSalon', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('salon', isEqualTo: selectedSalon) // Filtrer par le salon sélectionné
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des RDV'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun RDV trouvé pour ce salon.'));
          }

          List<DocumentSnapshot> appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index].data() as Map<String, dynamic>;

              // Récupérer les détails du rendez-vous
              String firstName = appointment['first_name'] ?? 'Prénom inconnu';
              String lastName = appointment['last_name'] ?? 'Nom inconnu';
              String email = appointment['email'] ?? 'Email non fourni';
              String phone = appointment['phone'] ?? 'Téléphone non fourni';
              String date = appointment['date'] ?? 'Date non spécifiée';
              String time = appointment['time'] ?? 'Heure non spécifiée';
              List<dynamic> services = appointment['services'] ?? ['Services non spécifiés'];
              String status = appointment['status'] ?? 'Statut inconnu';
              DateTime createdAt = (appointment['created_at'] as Timestamp).toDate();

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Client: $firstName $lastName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: $email'),
                      Text('Téléphone: $phone'),
                      Text('Date: $date'),
                      Text('Heure: $time'),
                      Text('Services: ${services.join(', ')}'),
                      Text('Statut: $status'),
                      Text('Créé le: ${createdAt.toLocal()}'),
                    ],
                  ),
                  leading: Icon(Icons.calendar_today),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

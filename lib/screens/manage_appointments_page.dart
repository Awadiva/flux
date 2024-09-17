import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAppointmentsPage extends StatelessWidget {
  final String selectedSalon;

  ManageAppointmentsPage({required this.selectedSalon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les RDV - $selectedSalon'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('salon', isEqualTo: selectedSalon)
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
              String clientName = appointment['client_name'] ?? 'Client inconnu';
              DateTime appointmentDate = appointment['appointment_date'].toDate();

              return ListTile(
                title: Text('Client: $clientName'),
                subtitle: Text('Date: ${appointmentDate.toString()}'),
                leading: Icon(Icons.calendar_today),
              );
            },
          );
        },
      ),
    );
  }
}

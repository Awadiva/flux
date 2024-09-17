import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'salon_detail_page.dart';
import 'edit_salon_page.dart'; // Page pour modifier le salon

class SalonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des salons')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('salons').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des salons.'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun salon trouvé.'));
          } else {
            final salons = snapshot.data!.docs;

            return ListView.builder(
              itemCount: salons.length,
              itemBuilder: (context, index) {
                var salonData = salons[index].data() as Map<String, dynamic>;
                String salonName = salonData['salon_name'] ?? 'Nom du salon indisponible';
                String salonId = salons[index].id;

                return ListTile(
                  title: Text(salonName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Naviguer vers la page de modification du salon
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSalonPage(salonId: salonId),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, salonId);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalonDetailPage(salonId: salonId),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String salonId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer la suppression"),
          content: Text("Êtes-vous sûr de vouloir supprimer ce salon ?"),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
            ),
            TextButton(
              child: Text("Supprimer"),
              onPressed: () {
                _deleteSalon(salonId, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSalon(String salonId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('salons').doc(salonId).delete();
      Navigator.of(context).pop(); // Fermer la boîte de dialogue après la suppression
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Salon supprimé avec succès.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression du salon.")),
      );
    }
  }
}

import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  final String salonId;

  // Le constructeur attend 'salonId'
  AdminDashboardPage({required this.salonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text('Salon ID: $salonId'),
      ),
    );
  }
}

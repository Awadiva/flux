import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String paymentMethod;

  PaymentDetailsPage({required this.paymentMethod});

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Fonction pour traiter le paiement
  void _processPayment(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Logique pour traiter le paiement
      print('Méthode de paiement: $paymentMethod');
      print('Numéro de carte: ${_cardNumberController.text}');
      print('Date d\'expiration: ${_expiryDateController.text}');
      print('CVC: ${_cvcController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paiement en cours...')),
      );

      // Rediriger ou afficher une confirmation de paiement
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer des informations valides.')),
      );
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un numéro de carte valide';
    }
    if (value.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Le numéro de carte doit contenir 16 chiffres';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une date d\'expiration';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Date d\'expiration invalide. Format MM/AA';
    }
    return null;
  }

  String? _validateCVC(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un CVC valide';
    }
    if (value.length != 3 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Le CVC doit contenir 3 chiffres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Paiement',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Méthode de Paiement : $paymentMethod',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Numéro de Carte',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCardNumber,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _expiryDateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Date d\'Expiration (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateExpiryDate,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cvcController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CVC',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCVC,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _processPayment(context);  // Appelle la méthode pour traiter le paiement
                  },
                  child: Text('Confirmer le Paiement',style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

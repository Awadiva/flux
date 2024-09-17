import 'package:flutter/material.dart';
import 'payment_details_page.dart'; // Importer la page des détails de paiement

class PaymentPage extends StatefulWidget {
  final List<String> selectedServices;
  final Map<String, String> customerInfo;

  PaymentPage({required this.selectedServices, required this.customerInfo});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;

  // Confirme le paiement et redirige vers la page des détails de paiement
  void _confirmPayment() {
    if (_selectedPaymentMethod != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentDetailsPage(
            paymentMethod: _selectedPaymentMethod!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un mode de paiement')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Sélectionnez un mode de paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services sélectionnés :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            for (var service in widget.selectedServices)
              Text('- $service', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset('assets/images/credit_card_logo.jpg', height: 40),
                  SizedBox(width: 10),
                  Text('Carte de Crédit'),
                ],
              ),
              value: 'Carte de Crédit',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset('assets/images/paypal_logo.jpg', height: 40),
                  SizedBox(width: 10),
                  Text('PayPal'),
                ],
              ),
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset('assets/images/google_pay_logo.jpeg', height: 40),
                  SizedBox(width: 10),
                  Text('Google Pay'),
                ],
              ),
              value: 'Google Pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmPayment,
              child: Text('Procéder au paiement',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

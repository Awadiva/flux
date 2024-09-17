import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_page.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notre Boutique',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Notre Boutique',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Découvrez notre gamme exclusive de produits de beauté.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildProductCard(context, 'Fard à paupières', 'assets/images/eyeshadow.png', 45),
                _buildProductCard(context, 'Crème de nuit', 'assets/images/night_cream.png', 25),
                _buildProductCard(context, 'Base de maquillage', 'assets/images/makeup_base.png', 23),
                _buildProductCard(context, 'Pinceau à maquillage', 'assets/images/makeup_brush.png', 20),
                _buildProductCard(context, 'Base de maquillage', 'assets/images/makeup_base1.png', 22),
                _buildProductCard(context, 'Rouge à lèvres rose', 'assets/images/rose_lipstick.png', 15),
                _buildProductCard(context, 'Rouge à lèvres rouge', 'assets/images/red_lipstick.png', 10),
                _buildProductCard(context, 'Vernis à ongles', 'assets/images/nail_polish.png', 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String imagePath, double price) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('\$$price', style: TextStyle(fontSize: 10)),
          SizedBox(height: 6),
          ElevatedButton(
            onPressed: () {
              _showCustomerInfoForm(context, name, price);
            },
            child: Text('Acheter', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerInfoForm(BuildContext context, String productName, double price) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _locationController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Informations de Livraison',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Prénom'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre prénom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de téléphone';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'Ville'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre ville';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Localisation complète'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre localisation';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseFirestore.instance.collection('orders').add({
                            'product': productName,
                            'firstName': _nameController.text,
                            'lastName': _lastNameController.text,
                            'email': _emailController.text,
                            'phone': _phoneController.text,
                            'city': _cityController.text,
                            'location': _locationController.text,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                selectedServices: [productName],
                                customerInfo: {
                                  'firstName': _nameController.text,
                                  'lastName': _lastNameController.text,
                                  'email': _emailController.text,
                                  'phone': _phoneController.text,
                                  'city': _cityController.text,
                                  'location': _locationController.text,
                                },
                              ),
                            ),
                          );
                        } catch (e, stacktrace) {
                          print('Erreur : $e');
                          print('Stacktrace : $stacktrace');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Une erreur est survenue lors de la sauvegarde des informations.')),
                          );
                        }
                      }
                    },
                    child: Text('Procéder au paiement', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

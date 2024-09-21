import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_page.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notre Boutique', style: TextStyle(color: Colors.white)),
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
                  fontSize: screenSize.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Center(
              child: Text(
                'Découvrez notre gamme exclusive de produits de beauté.',
                style: TextStyle(fontSize: screenSize.width * 0.04),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
              _buildProductCard(context, 'Fard à paupières', 'assets/images/eyeshadow.png', 45, screenSize),
                _buildProductCard(context, 'Crème de nuit', 'assets/images/night_cream.png', 25, screenSize),
                _buildProductCard(context, 'Base de maquillage', 'assets/images/makeup_base.png', 23, screenSize),
                _buildProductCard(context, 'Pinceau à maquillage', 'assets/images/makeup_brush.png', 20, screenSize),
                _buildProductCard(context, 'Base de maquillage', 'assets/images/makeup_base1.png', 22, screenSize),
                _buildProductCard(context, 'Rouge à lèvres rose', 'assets/images/rose_lipstick.png', 15, screenSize),
                _buildProductCard(context, 'Rouge à lèvres rouge', 'assets/images/red_lipstick.png', 10, screenSize),
                _buildProductCard(context, 'Vernis à ongles', 'assets/images/nail_polish.png', 15, screenSize),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String imagePath, double price, Size screenSize) {
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
            height: screenSize.height * 0.08,
            width: screenSize.width * 0.25,
            fit: BoxFit.cover,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text(
            name,
            style: TextStyle(fontSize: screenSize.width * 0.04, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Text('\$$price', style: TextStyle(fontSize: screenSize.width * 0.035)),
          SizedBox(height: screenSize.height * 0.008),
          ElevatedButton(
            onPressed: () {
              _showCustomerInfoForm(context, name, price);
            },
            child: Text('Acheter', style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
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

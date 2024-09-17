import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services et Tarifs',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Services et Tarifs',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildServiceSection(
              context,
              'Maquillage',
              'assets/images/makeup2.jpg',
              [
                _buildServiceDetail('Maquillage (complet)', '\$50'),
                _buildServiceDetail('Maquillage des yeux', '\$20'),
                _buildServiceDetail('Maquillage des lèvres', '\$15'),
              ],
              isLeftAligned: true,
            ),
            SizedBox(height: 20),
            _buildServiceSection(
              context,
              'Coiffure',
              'assets/images/hairstyle.png',
              [
                _buildServiceDetail('Coupe de cheveux', '\$30'),
                _buildServiceDetail('Coiffure', '\$25'),
                _buildServiceDetail('Traitement capillaire', '\$40'),
              ],
              isLeftAligned: false,
            ),
            SizedBox(height: 20),
            _buildServiceSection(
              context,
              'Soin des ongles',
              'assets/images/nailcare.png',
              [
                _buildServiceDetail('Manucure', '\$20'),
                _buildServiceDetail('Pédicure', '\$25'),
                _buildServiceDetail('Nail art', '\$15'),
              ],
              isLeftAligned: true,
            ),
            SizedBox(height: 20),
            _buildServiceSection(
              context,
              'Cosmétologie',
              'assets/images/cosmetology.png',
              [
                _buildServiceDetail('Soin du visage', '\$60'),
                _buildServiceDetail('Traitement de l\'acné', '\$50'),
                _buildServiceDetail('Rajeunissement de la peau', '\$70'),
              ],
              isLeftAligned: false,
            ),
            SizedBox(height: 20),
            _buildServiceSection(
              context,
              'Procédures SPA',
              'assets/images/spa.jpg',
              [
                _buildServiceDetail('Massage relaxant', '\$80'),
                _buildServiceDetail('Massage aux pierres chaudes', '\$90'),
                _buildServiceDetail('Aromathérapie', '\$70'),
              ],
              isLeftAligned: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context, String title, String imagePath, List<Widget> services, {required bool isLeftAligned}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLeftAligned
          ? [
              Image.asset(
                imagePath,
                height: 150,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...services,
                  ],
                ),
              ),
            ]
          : [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...services,
                  ],
                ),
              ),
              SizedBox(width: 20),
              Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ],
    );
  }

  Widget _buildServiceDetail(String serviceName, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            serviceName,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 18, color: Colors.pink),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ServicesPage(),
    debugShowCheckedModeBanner: false,
  ));
}

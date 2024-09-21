import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenez les dimensions de l'écran
    final screenSize = MediaQuery.of(context).size;
    final double textScale = screenSize.width * 0.0025; // Facteur de mise à l'échelle du texte

    return Scaffold(
      appBar: AppBar(
        title: Text('Services et Tarifs', style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.05)),
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
                  fontSize: screenSize.width * 0.07, // Ajuster la taille du texte
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Ajustement dynamique de l'espacement
            _buildServiceSection(
              context,
              'Maquillage',
              'assets/images/makeup2.jpg',
              [
                _buildServiceDetail('Maquillage (complet)', '\$50', screenSize),
                _buildServiceDetail('Maquillage des yeux', '\$20', screenSize),
                _buildServiceDetail('Maquillage des lèvres', '\$15', screenSize),
              ],
              isLeftAligned: true,
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildServiceSection(
              context,
              'Coiffure',
              'assets/images/hairstyle.png',
              [
                _buildServiceDetail('Coupe de cheveux', '\$30', screenSize),
                _buildServiceDetail('Coiffure', '\$25', screenSize),
                _buildServiceDetail('Traitement capillaire', '\$40', screenSize),
              ],
              isLeftAligned: false,
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildServiceSection(
              context,
              'Soin des ongles',
              'assets/images/nailcare.png',
              [
                _buildServiceDetail('Manucure', '\$20', screenSize),
                _buildServiceDetail('Pédicure', '\$25', screenSize),
                _buildServiceDetail('Nail art', '\$15', screenSize),
              ],
              isLeftAligned: true,
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildServiceSection(
              context,
              'Cosmétologie',
              'assets/images/cosmetology.png',
              [
                _buildServiceDetail('Soin du visage', '\$60', screenSize),
                _buildServiceDetail('Traitement de l\'acné', '\$50', screenSize),
                _buildServiceDetail('Rajeunissement de la peau', '\$70', screenSize),
              ],
              isLeftAligned: false,
              screenSize: screenSize,
            ),
            SizedBox(height: screenSize.height * 0.02),
            _buildServiceSection(
              context,
              'Procédures SPA',
              'assets/images/spa.jpg',
              [
                _buildServiceDetail('Massage relaxant', '\$80', screenSize),
                _buildServiceDetail('Massage aux pierres chaudes', '\$90', screenSize),
                _buildServiceDetail('Aromathérapie', '\$70', screenSize),
              ],
              isLeftAligned: true,
              screenSize: screenSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(
    BuildContext context,
    String title,
    String imagePath,
    List<Widget> services, {
    required bool isLeftAligned,
    required Size screenSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLeftAligned
          ? [
              Image.asset(
                imagePath,
                height: screenSize.height * 0.15, // Ajuster la hauteur de l'image
                width: screenSize.width * 0.25, // Ajuster la largeur de l'image
                fit: BoxFit.cover,
              ),
              SizedBox(width: screenSize.width * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06, // Ajuster la taille du titre
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
                        fontSize: screenSize.width * 0.06, // Ajuster la taille du titre
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...services,
                  ],
                ),
              ),
              SizedBox(width: screenSize.width * 0.05),
              Image.asset(
                imagePath,
                height: screenSize.height * 0.15, // Ajuster la hauteur de l'image
                width: screenSize.width * 0.25, // Ajuster la largeur de l'image
                fit: BoxFit.cover,
              ),
            ],
    );
  }

  Widget _buildServiceDetail(String serviceName, String price, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            serviceName,
            style: TextStyle(fontSize: screenSize.width * 0.04), // Ajuster la taille du texte du service
          ),
          Text(
            price,
            style: TextStyle(fontSize: screenSize.width * 0.04, color: Colors.pink), // Ajuster la taille du prix
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

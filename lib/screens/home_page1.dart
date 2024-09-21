import 'package:flutter/material.dart';
import 'add_salon_page.dart';
import 'salon_list_page.dart';
import 'about_page.dart';
import 'esthetician_page.dart';
import 'appointment_page.dart';
import 'share.dart';

class HomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E4DC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E4DC),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            Text(
              'FluxSpa',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Image.asset('assets/images/logo.png', height: 40),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(
                Icons.store, 'Ajouter un salon', AddSalonPage(), context),
            _buildDrawerItem(
                Icons.list, 'Liste des salons', SalonListPage(), context),
            _buildDrawerItem(Icons.account_circle, 'Ajouter une esthéticienne',
                EstheticianPage(), context),
            _buildDrawerItem(Icons.calendar_today, 'Prendre rendez-vous',
                AppointmentPage(), context),
            _buildDrawerItem(Icons.info, 'À propos', AboutPage(), context),
            _buildDrawerItem(
                Icons.share, 'Partager l\'application', null, context,
                shareApp: true),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                // Logique de déconnexion
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/accueil.jpg',
                height: 300, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'L\'élégance, c\'est d\'être aussi belle à l\'intérieur qu\'à l\'extérieur',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            // Autres widgets
            // Ligne d'images de services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildServiceItem('assets/images/makeup1.jpg', 'Maquillage'),
                  _buildServiceItem('assets/images/hair.jpg', 'Coiffure'),
                  _buildServiceItem('assets/images/manicure1.jpg', 'Manucure'),
                  _buildServiceItem(
                      'assets/images/facial.jpg', 'Soin du visage'),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Section des traitements et prix avec image à gauche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image à gauche
                  Image.asset(
                    'assets/images/bp.png', // Remplacez par votre propre image
                    height: 250,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  // Liste des traitements et prix à droite
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traitements comme',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildPriceItem('Soin du visage', ''),
                        _buildPriceItem('Manucure', ''),
                        _buildPriceItem('Pédicure', ''),
                        _buildPriceItem('Soin des cheveux', ''),
                        _buildPriceItem('Massage', ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Section des produits avec photos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produits comme:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProductItem(
                          'assets/images/crème.png', 'Crème hydratante'),
                      _buildProductItem('assets/images/Shampooing.png',
                          'Shampooing revitalisant'),
                      _buildProductItem(
                          'assets/images/serum.png', 'Sérum anti-âge'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProductItem(
                          'assets/images/lotion1.png', 'Lotion tonique'),
                      _buildProductItem(
                          'assets/images/huile.png', 'Huile de massage'),
                      _buildProductItem(
                          'assets/images/baume.png', 'Baume à lèvres'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Widget pour les services
  Widget _buildServiceItem(String imagePath, String serviceName) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          serviceName,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Widget pour les prix des traitements
  Widget _buildPriceItem(String treatment, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(treatment,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(price,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Widget pour afficher les produits sans prix
  Widget _buildProductItem(String imagePath, String productName) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),
        Text(
          productName,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

ListTile _buildDrawerItem(
    IconData icon, String title, Widget? page, BuildContext context,
    {bool shareApp = false}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
      if (shareApp) {
        ShareService().shareApp();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
      }
    },
  );
}

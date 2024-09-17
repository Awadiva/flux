import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À Propos de Nous',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              'Bienvenue chez FluxSpa !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Nous offrons des services de beauté haut de gamme qui répondent à tous vos besoins, '
              'y compris les soins du visage, les massages, les manucures, les pédicures, les soins capillaires '
              'et bien plus encore.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Notre Objectif',
              content: 'Chez FluxSpa, notre objectif principal est de créer un environnement où beauté rime avec bien-être. '
                  'Nous visons à fournir des soins personnalisés qui non seulement améliorent votre apparence physique mais aussi '
                  'favorisent la relaxation et le renouveau mental. Pour nos clients, cela signifie se sentir confiant '
                  'et radieux de l’intérieur après chaque visite.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Comment Nous Aidons les Salons de Beauté',
              content: 'FluxSpa permet aux salons de beauté de simplifier leurs services, de gérer les rendez-vous et de proposer '
                  'une gamme variée de traitements grâce à une plateforme conviviale. Nous aidons les salons à augmenter leur '
                  'satisfaction client en veillant à ce que chaque client reçoive un service de première classe du moment où ils réservent '
                  'jusqu’à leur départ.',
            ),
            SizedBox(height: 20),
            _buildSection(
              title: 'Comment Nous Aidons les Clients',
              content: 'Pour les clients, FluxSpa offre un moyen pratique de découvrir, réserver et profiter d’une variété de traitements de beauté. '
                  'En quelques clics seulement, ils peuvent programmer des rendez-vous avec leurs experts de beauté préférés, en s’assurant que '
                  'leurs besoins en beauté et bien-être sont comblés sans accroc. Notre mission est d’aider nos clients à se sentir et paraître au mieux '
                  'de leur forme, avec des services aussi relaxants qu’embellissants.',
            ),
            SizedBox(height: 20),
            Text(
              'Venez nous rendre visite pour une expérience inoubliable !',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

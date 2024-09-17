import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_page1.dart'; // Import the Home Page
import 'screens/register_client_page.dart';
import 'screens/admin_dashboard_page.dart';
import 'screens/esthetician_home.dart';
import 'screens/client_home.dart';
import 'screens/book_appointment.dart';
import 'screens/notifications_page.dart';
import 'screens/about_page.dart'; // Import About Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD1mMMR85c1E_tcidIQiS9rPZIZphnSsAA",
      authDomain: "soin-4be48.firebaseapp.com",
      projectId: "soin-4be48",
      storageBucket: "soin-4be48.appspot.com",
      messagingSenderId: "650435133847",
      appId: "1:650435133847:web:774dcdef7772caf5ba84d2",
      measurementId: "G-3S3N6H0HWD",
    ),
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage1(),
        '/about': (context) => AboutPage(),
        '/register': (context) => RegisterClientPage(),
        // AdminDashboardPage: Pass salonId dynamically
        '/adminDashboardPage': (context) {
          final String salonId = ModalRoute.of(context)!.settings.arguments as String;
          return AdminDashboardPage(salonId: salonId);
        },
        // EstheticianHomePage: Ensure selectedSalon is passed
        '/estheticianHome': (context) {
          final String? selectedSalon = ModalRoute.of(context)!.settings.arguments as String?;
          if (selectedSalon != null) {
            return EstheticianHome(selectedSalon: selectedSalon);
          } else {
            return Scaffold(
              body: Center(
                child: Text('Veuillez sélectionner un salon.'),
              ),
            );
          }
        },
        '/clientHome': (context) => ClientHome(),
        '/bookAppointment': (context) => BookAppointmentPage(),
        '/messages': (context) => NotificationsPage(),
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import '../screens/client_home.dart';
// import '../screens/notifications_page.dart';
// //import '../screens/reviews_page.dart';

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
  

//   BottomNavBar({required this.selectedIndex});

//   void _onItemTapped(BuildContext context, int index) {
//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientHome()));
//         break;
//       case 1:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
//         break;
//       case 2:
//        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReviewsPage()));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: selectedIndex,
//       onTap: (index) => _onItemTapped(context, index),
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notifications',
//             tooltip: 'Notifications',
//           ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.star),
//           label: 'Reviews',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.menu),
//           label: 'Menu',
//         ),
//       ],
//     );
//   }
// }

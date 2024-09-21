import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'client_home.dart';
import 'notifications_page.dart';
import 'client_profile.dart';

class ReviewsPage extends StatefulWidget {
  final String selectedSalon;

  ReviewsPage({required this.selectedSalon});
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  int _selectedIndex = 2;

  String? _clientName;

  @override
  void initState() {
    super.initState();
    _fetchClientName();
  }

  Future<void> _fetchClientName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _clientName = userDoc['name'];
      });
    }
  }

  void _submitReview() async {
    if (_commentController.text.isNotEmpty && _clientName != null) {
      await FirebaseFirestore.instance.collection('reviews').add({
        'rating': _rating,
        'comment': _commentController.text,
        'client_name': _clientName,
        'timestamp': Timestamp.now(),
      });

      _commentController.clear();
      setState(() {
        _rating = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Avis soumis avec succès !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez laisser un commentaire.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ClientHome(
                    selectedSalon: widget.selectedSalon,
                  )),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationsPage(
                    salonName: widget.selectedSalon,
                  )),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewsPage(
                    selectedSalon: widget.selectedSalon,
                  )),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laisser un avis', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ClientHome(
                        selectedSalon: widget.selectedSalon,
                      )),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Évaluer le service', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Laisser un commentaire',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Soumettre l\'avis',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var reviews = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      var review = reviews[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: RatingBarIndicator(
                            rating: review['rating'],
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                          ),
                          title: Text(review['comment']),
                          subtitle: Text('Par ${review['client_name']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.pink,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            tooltip: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Avis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

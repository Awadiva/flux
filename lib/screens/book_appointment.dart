import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'payment_page.dart';

class BookAppointmentPage extends StatefulWidget {
  final Map<String, String>? customerInfo;
  final String salonId; // ID du salon

  BookAppointmentPage({
    this.customerInfo,
    required this.salonId, // salonId est maintenant ici
  });

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    _populateCustomerInfo();
    _fetchServices();
  }

  // Populate customer info if available
  void _populateCustomerInfo() {
    if (widget.customerInfo != null) {
      _firstNameController.text = widget.customerInfo!['first_name'] ?? '';
      _lastNameController.text = widget.customerInfo!['last_name'] ?? '';
      _emailController.text = widget.customerInfo!['email'] ?? '';
      _phoneController.text = widget.customerInfo!['phone'] ?? '';
    }
  }

  // Fetch services available for the selected salon
  void _fetchServices() async {
    try {
      var serviceSnapshots = await FirebaseFirestore.instance
          .collection('services')
          .where('salon_id', isEqualTo: widget.salonId) // Filter by salon ID
          .get();
      setState(() {
        services = serviceSnapshots.docs.map((doc) {
          return {
            'name': doc['nom'] ?? 'Service inconnu',
            'selected': false,
          };
        }).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération des services: $e");
    }
  }

  // Save the appointment to Firestore
  Future<void> _saveAppointment() async {
    List<String> selectedServices = services
        .where((service) => service['selected'] as bool)
        .map((service) => service['name'].toString())
        .toList();

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'services': selectedServices,
        'status': 'en attente',
        'created_at': DateTime.now(),
        'salon_id': widget.salonId,
      });

      print("Rendez-vous sauvegardé avec succès");
    } catch (e) {
      print("Erreur lors de la sauvegarde du rendez-vous: $e");
    }
  }

  // Check for existing appointments at the same time
  Future<bool> _checkForExistingAppointments() async {
    try {
      QuerySnapshot appointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isEqualTo: _dateController.text)
          .where('time', isEqualTo: _timeController.text)
          .where('salon_id',
              isEqualTo: widget.salonId) // Check for selected salon
          .get();

      return appointments.docs.isNotEmpty;
    } catch (e) {
      print("Erreur lors de la vérification des rendez-vous: $e");
      return false;
    }
  }

  // Show dialog when an appointment exists or allow continuation to payment
  void _showExistingAppointmentsDialog(bool conflictExists) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: conflictExists
              ? Text('Conflit de Rendez-vous')
              : Text('Pas de Conflit'),
          content: conflictExists
              ? Text(
                  'Un rendez-vous a déjà été pris pour cette date et heure. Voulez-vous choisir une autre date ?')
              : Text(
                  'Aucun rendez-vous trouvé pour cette date et heure. Vous pouvez continuer au paiement.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (conflictExists) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookAppointmentPage(
                            customerInfo: widget.customerInfo,
                            salonId: widget.salonId)),
                  );
                }
              },
              child: Text('Retour'),
            ),
            if (!conflictExists)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _saveAppointment();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        selectedServices: services
                            .where((service) => service['selected'] as bool)
                            .map((service) => service['name'].toString())
                            .toList(),
                        customerInfo: {
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'email': _emailController.text,
                          'phone': _phoneController.text,
                        },
                      ),
                    ),
                  );
                },
                child: Text('Continuer'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final spacing = screenSize.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver un Rendez-vous pour ${widget.salonId}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Veuillez remplir le formulaire ci-dessous pour faire votre réservation avec nous.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/appointment_image.jpg',
                      fit: BoxFit.cover,
                      height: screenSize.height * 0.6,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Prénom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: spacing),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: spacing),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Veuillez entrer un email valide';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: spacing),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Numéro de téléphone',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre numéro de téléphone';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: spacing),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    );

                                    if (pickedDate != null) {
                                      setState(() {
                                        _dateController.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez sélectionner une date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: TextFormField(
                                  controller: _timeController,
                                  decoration: InputDecoration(
                                    labelText: 'Heure',
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(() {
                                        _timeController.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez sélectionner une heure';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          Text(
                            'Sélectionnez un ou plusieurs services :',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: spacing),
                          Column(
                            children: services.map((service) {
                              return CheckboxListTile(
                                title: Text(service['name']),
                                value: service['selected'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    service['selected'] = value!;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: spacing),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    services
                                        .where((service) =>
                                            service['selected'] as bool)
                                        .isNotEmpty) {
                                  bool conflictExists =
                                      await _checkForExistingAppointments();
                                  _showExistingAppointmentsDialog(
                                      conflictExists);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Veuillez remplir tous les champs obligatoires et sélectionner au moins un service.'),
                                  ));
                                }
                              },
                              child: Text(
                                'Procéder au Paiement',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

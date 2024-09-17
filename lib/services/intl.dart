import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; // Assurez-vous d'importer ce package

String formatDate(DateTime date) {
  return DateFormat.yMMMMd().format(date); // Ex : 25 août 2024
}

String formatTime(TimeOfDay time) {
  // Crée une instance de DateTime à partir de TimeOfDay
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  
  // Utilisez DateFormat pour formater l'heure
  return DateFormat.jm().format(dateTime); // Ex : 2:30 PM ou 14:30 en fonction du locale
}

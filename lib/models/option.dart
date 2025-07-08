import 'package:flutter/material.dart';

class Option {
  IconData icon;
  Color color;
  String title;

  Option({required this.icon, required this.color, required this.title});

  static List<Option> optionList = [
    Option(icon: Icons.person, color: Colors.blue, title: "Transfert"),
    Option(
      icon: Icons.shopping_cart,
      color: Colors.orangeAccent,
      title: "Paiements",
    ),
    Option(
      icon: Icons.phone_android_outlined,
      color: Colors.blue,
      title: "Crédit",
    ),
    Option(
      icon: Icons.account_balance_outlined,
      color: Colors.red,
      title: "Banque",
    ),
    Option(icon: Icons.card_giftcard, color: Colors.green, title: "Cadeaux"),
    Option(
      icon: Icons.punch_clock_outlined,
      color: Colors.pinkAccent,
      title: "Coffre",
    ),
    Option(
      icon: Icons.directions_bus,
      color: Colors.orange,
      title: "Transport",
    ),
  ];
}

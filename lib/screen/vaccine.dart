import 'package:flutter/material.dart';

class VaccinePage extends StatefulWidget {
  const VaccinePage({super.key});

  @override
  State<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

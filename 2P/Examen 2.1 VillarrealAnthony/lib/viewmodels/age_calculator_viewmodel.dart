import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../models/age_model.dart';

class AgeCalculatorViewModel with ChangeNotifier {
  final TextEditingController birthDateController = TextEditingController();
  AgeModel? _age;

  AgeModel? get age => _age;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  void calculateAge() {
    if (birthDateController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Por favor selecciona una fecha');
      return;
    }

    final birthDate = DateFormat('yyyy-MM-dd').parse(birthDateController.text);
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    _age = AgeModel(years: years, months: months, days: days);
    notifyListeners();
  }

  @override
  void dispose() {
    birthDateController.dispose();
    super.dispose();
  }
}
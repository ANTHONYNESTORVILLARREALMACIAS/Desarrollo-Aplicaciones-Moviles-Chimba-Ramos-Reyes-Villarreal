import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/triangle_model.dart';

class TriangleViewModel with ChangeNotifier {
  final TextEditingController sideAController = TextEditingController();
  final TextEditingController sideBController = TextEditingController();
  final TextEditingController sideCController = TextEditingController();
  TriangleModel? _triangle;

  TriangleModel? get triangle => _triangle;

  void identifyTriangle() {
    if (sideAController.text.isEmpty ||
        sideBController.text.isEmpty ||
        sideCController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Por favor ingresa los tres lados');
      return;
    }

    final sideA = double.tryParse(sideAController.text) ?? 0;
    final sideB = double.tryParse(sideBController.text) ?? 0;
    final sideC = double.tryParse(sideCController.text) ?? 0;

    if (sideA <= 0 || sideB <= 0 || sideC <= 0) {
      Fluttertoast.showToast(msg: 'Los lados deben ser mayores que cero');
      return;
    }

    if (sideA + sideB <= sideC ||
        sideA + sideC <= sideB ||
        sideB + sideC <= sideA) {
      Fluttertoast.showToast(msg: 'No es un triángulo válido');
      return;
    }

    String type;
    if (sideA == sideB && sideB == sideC) {
      type = 'Equilátero';
    } else if (sideA == sideB || sideA == sideC || sideB == sideC) {
      type = 'Isósceles';
    } else {
      type = 'Escaleno';
    }

    _triangle = TriangleModel(
      sideA: sideA,
      sideB: sideB,
      sideC: sideC,
      type: type,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    sideAController.dispose();
    sideBController.dispose();
    sideCController.dispose();
    super.dispose();
  }
}
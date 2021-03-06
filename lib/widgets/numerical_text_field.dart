import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericalTextField extends StatelessWidget {
  const NumericalTextField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      style: TextStyle(color: Colors.white, fontSize: 18),
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (e) {
        onChanged(double.tryParse(e) ?? 0);
      },
    );
  }
}

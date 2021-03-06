import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repaint/models/layer/layer.dart';

class NumericalTextField extends StatelessWidget {
  const NumericalTextField({
    Key? key,
    this.initial,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<double> onChanged;
  final String? initial;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Text(
            '%',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
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

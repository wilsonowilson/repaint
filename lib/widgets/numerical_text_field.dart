import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericalTextField extends StatelessWidget {
  const NumericalTextField({
    Key? key,
    this.initial,
    this.textColor,
    this.fillColor,
    this.onChanged,
    required this.controller,
  }) : super(key: key);

  final ValueChanged<double>? onChanged;
  final String? initial;
  final Color? fillColor;
  final Color? textColor;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.cyanAccent,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      validator: (e) {
        if (e?.isEmpty ?? true) return 'You need a size';
        final doubleValue = double.tryParse(e ?? '');
        if (doubleValue == null) return 'You need a size';
        if (doubleValue < 100) return 'Size too small';
        if (doubleValue > 3000) return 'Size too large';
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        suffix: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Text(
            'px',
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
        prefix: SizedBox(),
        fillColor: fillColor,
        filled: true,
      ),
      style: TextStyle(color: textColor, fontSize: 18),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (e) {
        onChanged?.call(double.tryParse(e) ?? 0);
      },
    );
  }
}

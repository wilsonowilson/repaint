import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBar extends StatelessWidget {
  const EditBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final canvas = cubit.state.canvas;
    final headingStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade600,
      fontSize: 12,
    );
    final infoStyle = GoogleFonts.raleway(
      color: Colors.grey.shade600,
      fontSize: 12,
    );
    return Container(
      height: 60,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Actual Size:'.toUpperCase(),
            style: headingStyle,
          ),
          SizedBox(width: 10),
          Text(
            '${canvas.size.width}px, ${canvas.size.height}px',
            style: infoStyle,
          ),
          SizedBox(width: 30),
          Text(
            'Working Size:'.toUpperCase(),
            style: headingStyle,
          ),
          SizedBox(width: 10),
          Text(
            '${canvas.effectiveSize?.width.toStringAsFixed(1) ?? 0}px, '
            '${canvas.effectiveSize?.height.toStringAsFixed(1) ?? 0}px',
            style: infoStyle,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}

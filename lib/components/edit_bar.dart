import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';

class EditBar extends StatelessWidget {
  const EditBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    return Container(
      height: 60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 20),
          )
        ],
      ),
      child: state.selectedLayer.isNone()
          ? null
          : Row(
              children: [],
            ),
    );
  }
}

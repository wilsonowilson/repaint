import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/components/painting_area.dart';
import 'package:repaint/components/sidebar.dart';
import 'package:repaint/components/top_bar.dart';
import 'package:repaint/models/core/canvas.dart';

class CreatePage extends StatelessWidget {
  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => CanvasCubit(
        RCanvas(
          width: 1080,
          height: 2000,
          color: Colors.white,
        ),
      ),
      child: CreatePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(),
          Expanded(
            child: Row(
              children: [
                SideBar(),
                Expanded(
                  child: PaintingArea(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/components/painting_area.dart';
import 'package:repaint/components/sidebar/sidebar.dart';
import 'package:repaint/components/top_bar/top_bar.dart';
import 'package:repaint/models/core/canvas.dart';

class CreatePage extends StatefulWidget {
  static Widget create(BuildContext context, Size canvasSize) {
    return BlocProvider(
      create: (context) => CanvasCubit(
        RCanvas(
          size: canvasSize,
          color: Colors.white,
        ),
      ),
      child: CreatePage(),
    );
  }

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey repaintKey = GlobalKey();
  final TransformationController controller = TransformationController();
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
                Expanded(child: PaintingArea()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

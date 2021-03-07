import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/components/painting_area.dart';
import 'package:repaint/components/top_bar/file_saver.dart'
    if (dart.library.html) 'package:repaint/components/top_bar/file_saver_web.dart'
    as web;

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff29f19c),
            Color(0xff02a1f9),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              Text(
                'Repaint',
                style: GoogleFonts.lobster(
                  fontSize: 30,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<CanvasCubit>().deselectLayer();
                  showDialog<void>(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<CanvasCubit>(),
                      child: Center(
                        child: ScreenshotWidget(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  CupertinoIcons.cloud_download,
                  color: Colors.black,
                  size: 18,
                ),
                label: Text(
                  'Save',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenshotWidget extends StatefulWidget {
  ScreenshotWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  final canvasKey = GlobalKey();
  final repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final canvas = cubit.state.canvas;
    var effectiveCanvasSize = canvas.effectiveSize!;

    final ratioX = canvas.size.width / canvas.effectiveSize!.width;
    final ratioY = canvas.size.height / canvas.effectiveSize!.height;
    final maxRatio = max(ratioX, ratioY);
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.1,
        vertical: screenSize.height * 0.02,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Stack(
            children: [
              Center(
                child: IgnorePointer(
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: RepaintBoundary(
                      key: repaintKey,
                      child: CanvasComponent(
                        canvasKey: canvasKey,
                        effectiveCanvasSize: effectiveCanvasSize,
                        canvas: canvas,
                      ),
                    ),
                  ),
                ),
              ),
              Container(color: Colors.white70),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Export your work',
                        style: GoogleFonts.raleway(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        child: Text('Save as PNG'),
                        onPressed: () => saveWork(maxRatio),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveWork(double maxRatio) async {
    await Future<Null>.delayed(Duration(milliseconds: 2000));
    RenderRepaintBoundary boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: maxRatio);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    web.FileSaver().saveAs(pngBytes, "repaint.png");
  }
}

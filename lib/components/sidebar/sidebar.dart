import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layout/layout.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/image_picker.dart';
import 'package:repaint/components/sidebar/editing_sidebar.dart';
import 'package:repaint/components/sidebar/sidebar_heading.dart';
import 'package:repaint/models/layer/image.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/paint.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'canvas_color_editor.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool settingsOpen = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final isEditing = state.isInEditMode;

    return Container(
      height: double.maxFinite,
      width: 300,
      color: Colors.blueGrey.shade900,
      child: SidebarPanel(
        title: isEditing ? 'Edit Layer' : 'Elements',
        leading: Builder(
          builder: (context) {
            if (isEditing || settingsOpen)
              return IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isEditing)
                    cubit.deselectLayer();
                  else
                    setState(() {
                      settingsOpen = false;
                    });
                },
              );
            if (!settingsOpen)
              return IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    settingsOpen = true;
                  });
                },
              );

            return const SizedBox();
          },
        ),
        child: Margin(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Builder(builder: (context) {
            if (!isEditing && !settingsOpen)
              return ListView(
                children: [
                  TextLayerTemplates(),
                  ImageLayerTemplates(),
                  PaintLayerTemplates(),
                ],
              );
            else if (settingsOpen)
              return CanvasSettings();
            else
              return SingleChildScrollView(
                child: EditingSidebar(),
              );
          }),
        ),
      ),
    );
  }
}

class CanvasSettings extends StatefulWidget {
  @override
  _CanvasSettingsState createState() => _CanvasSettingsState();
}

class _CanvasSettingsState extends State<CanvasSettings> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final layers = cubit.state.layers;
    return Column(
      children: [
        SizedBox(height: 10),
        CanvasColorEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        SizedBox(height: 10),
        Expanded(
          child: ReorderableListView(
            buildDefaultDragHandles: false,
            proxyDecorator: (e, _, __) {
              return SizedBox(
                child: e,
              );
            },
            children: layers.map((layer) {
              final index = layers.indexOf(layer);
              return ReorderableDragStartListener(
                key: ValueKey(layer.id),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: ListTile(
                    tileColor: Colors.blueGrey.shade800,
                    title: Text(
                      layer.data.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                index: index,
              );
            }).toList(),
            onReorder: (e, f) => cubit.reorderLayers(e, f),
          ),
        ),
      ],
    );
  }
}

class SidebarPanel extends StatelessWidget {
  const SidebarPanel({
    Key? key,
    required this.child,
    required this.title,
    this.leading = const SizedBox(),
  }) : super(key: key);
  final String title;
  final Widget child;
  final Widget leading;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xFF202029),
          height: 50,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading,
              Text(
                title,
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Opacity(
                  opacity: 0,
                  child: leading,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: child,
        ),
        // Expanded(
        //   child: Scrollbar(
        //     child: ListView(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       children: children,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class TextLayerTemplates extends StatelessWidget {
  const TextLayerTemplates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText = TextLayer(
      font: availableFonts[0],
      offset: Offset(0, 0),
      size: Size(220, 40),
      style: TextStyle(
        fontSize: 16,
      ),
      text: 'Lorem ipsum dolor sit amet consecteur adespising',
    );
    final headingText = TextLayer(
      font: availableFonts[0],
      offset: Offset.zero,
      size: Size(150, 40),
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      text: 'Heading',
    );
    final subheading = TextLayer(
      font: availableFonts[0],
      offset: Offset.zero,
      size: Size(120, 25),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      text: 'Subheading',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SidebarHeading(title: 'TEXT'),
        const SizedBox(height: 8),
        _buildElementGrid([
          DraggableComponent(
            layer: headingText,
            title: 'Heading',
            icon: FontAwesomeIcons.heading,
          ),
          DraggableComponent(
            layer: subheading,
            title: subheading.text,
            icon: FontAwesomeIcons.heading,
            iconSize: 25,
          ),
          DraggableComponent(
            layer: bodyText,
            title: 'Body',
            draggingText: 'Lorem ipsum dolor sit amet \nconsecteur adespising',
            icon: FontAwesomeIcons.alignLeft,
          ),
        ]),
      ],
    );
  }
}

class ImageLayerTemplates extends StatelessWidget {
  const ImageLayerTemplates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final defaultImage = ImageLayer(
      offset: Offset.zero,
      size: Size(200, 200),
    );
    final backgroundImage = ImageLayer(
      offset: Offset.zero,
      size: cubit.state.canvas.effectiveSize ?? Size.zero,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SidebarHeading(title: 'IMAGES'),
        const SizedBox(height: 8),
        _buildElementGrid([
          DraggableComponent(
            layer: defaultImage,
            title: 'Image',
            icon: Icons.image,
          ),
          DraggableComponent(
            layer: backgroundImage,
            title: 'Background',
            icon: FontAwesomeIcons.solidImage,
          ),
        ]),
      ],
    );
  }
}

class PaintLayerTemplates extends StatelessWidget {
  const PaintLayerTemplates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPaintLayer = PaintLayer(
      size: Size(200, 200),
      offset: Offset.zero,
      color: Colors.blue,
      radius: 0,
    );
    final circlePaintLayer = PaintLayer(
      size: Size(200, 200),
      offset: Offset.zero,
      color: Colors.blue,
      shape: BoxShape.circle,
      radius: 0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SidebarHeading(title: 'SHAPES'),
        const SizedBox(height: 8),
        _buildElementGrid([
          DraggableComponent(
            title: 'Square',
            layer: defaultPaintLayer,
            icon: FontAwesomeIcons.squareFull,
          ),
          DraggableComponent(
            title: 'Circle',
            layer: circlePaintLayer,
            icon: FontAwesomeIcons.solidCircle,
          ),
        ]),
      ],
    );
  }
}

GridView _buildElementGrid(List<Widget> children) {
  return GridView(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 1.3,
    ),
    children: children,
  );
}

class DraggableComponent extends StatelessWidget {
  const DraggableComponent({
    Key? key,
    required this.layer,
    required this.title,
    required this.icon,
    this.iconSize,
    this.draggingText,
  }) : super(key: key);

  final RLayer layer;
  final String? draggingText;
  final String title;
  final IconData icon;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: 140,
      padding: EdgeInsets.all(20),
      height: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade800.withOpacity(0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              height: 27,
              child: Icon(
                icon,
                size: iconSize ?? 27,
                color: Colors.white54,
              ),
            ),
            SizedBox(height: 10),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
    return Draggable<RLayer>(
      data: layer,
      feedback: widget,
      child: GestureDetector(
        onTap: () async {
          var layerToAdd = layer;
          if (layer is ImageLayer) {
            final bytes = await ImagePicker.pickImage();
            if (bytes == null)
              return;
            else
              layerToAdd = (layer as ImageLayer).copyWith(data: bytes);
          }
          context.read<CanvasCubit>().addLayer(layerToAdd);
        },
        child: widget,
      ),
    );
  }
}

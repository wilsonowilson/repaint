import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/components/sidebar/position_editor.dart';
import 'package:repaint/components/sidebar/shadow_editor.dart';
import 'package:repaint/components/sidebar/sidebar_heading.dart';
import 'package:repaint/components/sidebar/size_editor.dart';
import 'package:repaint/components/sidebar/text_align_editor.dart';
import 'package:repaint/components/sidebar/text_color_editor.dart';
import 'package:repaint/components/sidebar/text_content_editor.dart';
import 'package:repaint/components/sidebar/text_decoration_editor.dart';
import 'package:repaint/components/sidebar/text_font_editor.dart';
import 'package:repaint/components/sidebar/text_size_editor.dart';
import 'package:repaint/components/sidebar/text_weight_editor.dart';
import 'package:repaint/models/layer/image.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';

class EditingSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: state.selectedOption.isTextLayer
          ? TextLayerEditSidebar(identityLayer: state.selectedOption)
          : state.selectedOption.isImageLayer
              ? ImageLayerEditSidebar(identityLayer: state.selectedOption)
              : const SizedBox(),
    );
  }
}

class TextLayerEditSidebar extends StatelessWidget {
  const TextLayerEditSidebar({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  Widget build(BuildContext context) {
    final layer = identityLayer.data as TextLayer;
    return Column(
      children: [
        SidebarHeading(
          title: 'DIMENSIONS',
          padding: 5,
        ),
        SizedBox(height: 15),
        LayerPositionEditor(),
        SizedBox(height: 15),
        LayerSizeEditor(),
        SizedBox(height: 15),
        SidebarHeading(
          title: 'CONTENT',
          padding: 5,
        ),
        SizedBox(height: 15),
        TextContentEditor(
          layer: layer,
          identityLayer: identityLayer,
        ),
        SizedBox(height: 25),
        SidebarHeading(
          title: 'STYLE',
          padding: 5,
        ),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        SizedBox(height: 5),
        TextFontEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        SizedBox(height: 5),
        TextColorEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        TextAlignmentEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        TextSizeEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        TextWeightEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        TextDecorationEditor(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700),
        SizedBox(height: 15),
        SidebarHeading(
          title: 'SHADOW',
          padding: 5,
        ),
        SizedBox(height: 15),
        LayerShadowEditor(),
        SizedBox(height: 15),
      ],
    );
  }
}

class ImageLayerEditSidebar extends StatelessWidget {
  const ImageLayerEditSidebar({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  Widget build(BuildContext context) {
    final layer = identityLayer.data as ImageLayer;
    return Column(
      children: [
        SidebarHeading(
          title: 'DIMENSIONS',
          padding: 5,
        ),
        SizedBox(height: 15),
        LayerPositionEditor(),
        SizedBox(height: 15),
        LayerSizeEditor(),
        // SizedBox(height: 15),
        // SidebarHeading(
        //   title: 'CONTENT',
        //   padding: 5,
        // ),
        // SizedBox(height: 15),
        // TextContentEditor(
        //   layer: layer,
        //   identityLayer: identityLayer,
        // ),
        // SizedBox(height: 25),
        // SidebarHeading(
        //   title: 'STYLE',
        //   padding: 5,
        // ),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // SizedBox(height: 5),
        // TextFontEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // SizedBox(height: 5),
        // TextColorEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // TextAlignmentEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // TextSizeEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // TextWeightEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // TextDecorationEditor(),
        // SizedBox(height: 5),
        // Divider(color: Colors.blueGrey.shade700),
        // SizedBox(height: 15),
        SidebarHeading(
          title: 'SHADOW',
          padding: 5,
        ),
        SizedBox(height: 15),
        LayerShadowEditor(),
        SizedBox(height: 15),
      ],
    );
  }
}

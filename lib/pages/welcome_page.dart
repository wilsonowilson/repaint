import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouse_parallax/mouse_parallax.dart';
import 'package:repaint/pages/create_page.dart';
import 'package:repaint/widgets/numerical_text_field.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(
        0xff151520,
      ),
      body: ParallaxStack(
        drag: Duration(milliseconds: 900),
        dragCurve: Curves.easeOutCubic,
        layers: [
          ParallaxLayer(
            xOffset: 30,
            yOffset: 30,
            xRotation: 0.1,
            yRotation: -0.1,
            child: OverflowBox(
              maxWidth: size.width + 300,
              maxHeight: size.height + 300,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1557672172-298e090bd0f1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.1,
            ),
            child: Center(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 60,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(
                      0xff151520,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 40,
                        color: Colors.black38,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Repaint',
                      style: GoogleFonts.raleway(
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        color: Colors.greenAccent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final size = await showDialog<Size?>(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: SizePicker(),
                                );
                              });
                          if (size == null) return;
                          Navigator.of(context).push<Null>(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreatePage.create(context, size),
                            ),
                          );
                        },
                        child: Text('Get started'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff202030),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SizePicker extends StatefulWidget {
  const SizePicker({
    Key? key,
  }) : super(key: key);

  @override
  _SizePickerState createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController widthCtrl;
  late final TextEditingController heightCtrl;

  @override
  void initState() {
    widthCtrl = TextEditingController(text: '1080');
    heightCtrl = TextEditingController(text: '720');
    super.initState();
  }

  @override
  void dispose() {
    widthCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        width: 600,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pick a template',
              style: GoogleFonts.raleway(
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TemplatePicker(
                      name: 'Thumbnail',
                      size: Size(1280, 720),
                      image:
                          'https://images.unsplash.com/photo-1509343256512-d77a5cb3791b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80'),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TemplatePicker(
                    name: 'Poster',
                    size: Size(792, 1008),
                    image:
                        'https://images.unsplash.com/photo-1584448141569-69f342da535c?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=980&q=80',
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: TemplatePicker(
                    name: 'Logo',
                    image:
                        'https://images.unsplash.com/photo-1599305445671-ac291c95aaa9?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80',
                    size: Size(512, 512),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Or custom',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: NumericalTextField(
                      controller: widthCtrl,
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 120,
                    child: NumericalTextField(
                      controller: heightCtrl,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final width = double.tryParse(widthCtrl.text) ?? 0;
                    final height = double.tryParse(heightCtrl.text) ?? 0;
                    if (width != 0 && height != 0)
                      Navigator.pop(context, Size(width, height));
                  }
                },
                child: Text('Start Designing'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TemplatePicker extends StatelessWidget {
  const TemplatePicker({
    Key? key,
    required this.name,
    required this.size,
    required this.image,
  }) : super(key: key);

  final String name;
  final Size size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, size);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: GoogleFonts.raleway(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('${size.width.toInt()} x ${size.height.toInt()}'),
        ],
      ),
    );
  }
}

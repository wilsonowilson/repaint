import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:universal_platform/universal_platform.dart';

class ImagePicker {
  static Future<Uint8List?> pickImage() async {
    Uint8List? bytes;
    if (UniversalPlatform.isWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        bytes = result.files[0].bytes;
      }
    } else if (UniversalPlatform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      final result = await file?.readAsBytes();
      bytes = result;
    }
    return bytes;
  }
}

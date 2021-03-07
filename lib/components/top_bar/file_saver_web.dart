import 'dart:html' as html;
import 'dart:js' as js;

import 'package:repaint/components/top_bar/file_saver.dart' as u;

class FileSaver extends u.FileSaver {
  void saveAs(List<int> bytes, String fileName) {
    js.context.callMethod("saveAs", <Object>[
      html.Blob(<List<int>>[bytes]),
      fileName
    ]);
  }
}

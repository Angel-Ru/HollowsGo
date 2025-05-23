import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../imports.dart';

class SkinImageCache {
  static Future<File?> getLocalImageFile(String skinId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = p.join(directory.path, 'skin_$skinId.png');
    final file = File(filePath);
    return await file.exists() ? file : null;
  }

  static Future<File?> downloadAndSaveImage(String url, String skinId) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File(p.join(directory.path, 'skin_$skinId.png'));
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print('Error descarregant imatge: $e');
    }
    return null;
  }

  static Future<void> preloadSkins(List<Skin> skins) async {
    for (final skin in skins) {
      final file = await getLocalImageFile(skin.id.toString());
      if (file == null) {
        await downloadAndSaveImage(skin.imatge ?? '', skin.id.toString());
      }
    }
  }
}

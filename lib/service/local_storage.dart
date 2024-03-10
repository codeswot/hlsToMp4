import 'dart:io';

import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player_test/service/api.dart';

Future<void> cacheHLSStream(String url) async {
  File? m3u8File = await getM3U8FileFromBrowser(url: url);
  // File? m3u8File = await downloadM3U8File(url: url);

  List<String> varientPath = await parseM3U8File(m3u8File!);
  print('varientPath >>> $varientPath');

  String varient = varientPath.last.split('https').last;
  String varientUrl = 'https$varient';

  final res = await downloadM3U8File(url: varientUrl);
  print('Path $res');
}

Future<List<String>> parseM3U8File(File m3u8File) async {
  List<String> varientPath = [];
  String content = await m3u8File.readAsString();

  HlsPlaylistParser parser = HlsPlaylistParser.create();
  HlsPlaylist playlist =
      await parser.parseString(Uri.parse(m3u8File.path), content);

  if (playlist is HlsMasterPlaylist) {
    for (Variant varient in playlist.variants) {
      varientPath.add(varient.url.toString());
    }
  }
  return varientPath;
}

Future<File?> saveFileToLocalDir({required String filename}) async {
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  final filePath = '${appDocumentsDir.path}/$filename.m3u8';
  final file = File(filePath);
  return file.existsSync() ? file : null;
}

void createFileIfNotExists(String filePath) {
  File file = File(filePath);

  if (!file.existsSync()) {
    // File does not exist, create it
    file.createSync(recursive: true);
  }
}

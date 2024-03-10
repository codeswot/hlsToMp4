import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_test/service/local_storage.dart';
import 'package:video_player_test/service/post.dart';

Future<ForYouPost> getForYouPost(BuildContext context) async {
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNWRlMTUxYjEtMTVjMC00Nzc3LWFhOGEtNzFkZjViMWZiOWE5IiwidXNlcm5hbWUiOiJwb3N0bWFuIiwiaWF0IjoxNzA5OTE2MDI2LCJleHAiOjE3NDE0NzM2MjZ9.0CDCBjdZHmGbMiYAiJ6ionyLpNGZWWs_W_r1ku-bED4';
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    final url =
        Uri.parse('https://www.skiiishow.com/api/read/posts/for-you-posts-all');

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final posts = jsonDecode(response.body);
      final post = ForYouPost.fromJson(posts[0]);
      await cacheHLSStream(post.post.media.first);
      await prefs.setString('forYou', post.toRawJson());
      return post;
    } else {
      throw 'Cannot fetch for you post';
    }
  } on SocketException catch (e) {
    String? localPost = prefs.getString('forYou');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(e.message),
      ),
    );
    return ForYouPost.fromRawJson(localPost!);
  } catch (e) {
    rethrow;
  }
}

Future<File?> getM3U8FileFromBrowser({required String url}) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$url.m3u8';
      createFileIfNotExists(path);
      final file = File(path);
      print('Got response >>> ${response.bodyBytes}');
      return await file.writeAsBytes(response.bodyBytes);
    } else {
      throw 'Failed to download file: ${response.body}';
    }
  } catch (e) {
    rethrow;
  }
}

Future<File?> downloadM3U8File({required String url}) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/$url';
      createFileIfNotExists(path);
      final file = File(path);
      print('Varient size >>> ${response.bodyBytes}');
      return await file.writeAsBytes(response.bodyBytes);
    } else {
      throw 'Failed to download file: ${response.body}';
    }
  } catch (e) {
    rethrow;
  }
}

Future<File> getSavedM3U8File(String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    if (await file.exists()) {
      return file;
    } else {
      throw 'File does not exist';
    }
  } catch (e) {
    throw 'Error reading file $e';
  }
}

Future<String> startServer(String filePath) async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((HttpRequest request) async {
    try {
      File file = File(filePath);
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers
          .add('Content-Type', 'application/vnd.apple.mpegurl');
      await file.openRead().pipe(request.response);
    } catch (e) {
      print('Error serving file: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.close();
    }
  });

  return 'http://127.0.0.1:${server.port}';
}

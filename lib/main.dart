import 'dart:convert';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter FFmpeg Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await getAndSaveSegmentsWithPlaylist(
                  'https://s3cdn.skiiishow.com/assets/ceb20f9a-400e-4877-b93b-cb5df84493b8/HLS/b0583a7b-4344-4637-baef-c13b9b0626ae_720.m3u8');
            },
            child: const Text('Convert HLS to MP4'),
          ),
        ),
      ),
    );
  }

  Future<void> getAndSaveSegmentsWithPlaylist(String playlistUrl) async {
    final docDir = await getApplicationDocumentsDirectory();
    List<String> hlsSegments = [];
    String baseUrl =
        'https://s3cdn.skiiishow.com/assets/ceb20f9a-400e-4877-b93b-cb5df84493b8/HLS/';
    String subdirectoryName = baseUrl.split('/')[baseUrl.split('/').length - 3];

    String workDir = '${docDir.path}/hls/$subdirectoryName';
    createDirectoryIfNotExists(workDir);

    http.Response response = await http.get(Uri.parse(playlistUrl));
    String outputPlayFilePath = '$workDir/${playlistUrl.split('/').last}';
    createFileIfNotExists(outputPlayFilePath);
    File file = File(outputPlayFilePath);
    await file.writeAsBytes(response.bodyBytes);

    if (response.statusCode == 200) {
      List<String> lines = LineSplitter.split(response.body).toList();

      for (String line in lines) {
        if (line.startsWith('#EXTINF:')) {
          String segmentUrl = baseUrl + lines[lines.indexOf(line) + 1];
          hlsSegments.add(segmentUrl);
        }
      }

      if (hlsSegments.isNotEmpty) {
        for (String segment in hlsSegments) {
          if (kDebugMode) {
            print('seg $segment');
          }

          http.Response segmentResponse = await http.get(Uri.parse(segment));

          if (segmentResponse.statusCode == 200) {
            String outputFilePath = '$workDir/${segment.split('/').last}';
            if (kDebugMode) {
              print('st $outputFilePath');
            }
            createFileIfNotExists(outputFilePath);
            File file = File(outputFilePath);
            await file.writeAsBytes(segmentResponse.bodyBytes);
          }
        }

        // Convert to MP4 using ffmpeg_kit_flutter
        await convertSegmentsToMP4(hlsSegments, workDir);
      } else {
        if (kDebugMode) {
          print('No HLS segments found in the playlist');
        }
      }
    } else {
      if (kDebugMode) {
        print('Failed to fetch HLS playlist');
      }
    }
  }

  Future<void> convertSegmentsToMP4(
      List<String> hlsSegments, String workDir) async {
    String outputFilePath = '$workDir/output.mp4';

    // Build the input list for ffmpeg_kit_flutter
    List<String> inputList = [];
    for (String segment in hlsSegments) {
      inputList.add('-i');
      inputList.add('$workDir/${segment.split('/').last}');
    }

    // Build the ffmpeg_kit_flutter command as a single string
    String command = '-y ${inputList.join(' ')} -c copy $outputFilePath';

    // Execute the ffmpeg_kit_flutter command
    final result = await FFmpegKit.executeAsync(command);
    final state = await result.getState();
    if (state == SessionState.completed) {
      if (kDebugMode) {
        print('Conversion to MP4 completed successfully.');
        final logs = await result.getAllLogsAsString();
        print('Error during conversion: $logs');
      }
    }
    if (kDebugMode) {
      print('output $outputFilePath');
    }
  }

  void createFileIfNotExists(String filePath) {
    File file = File(filePath);

    if (!file.existsSync()) {
      // File does not exist, create it
      file.createSync(recursive: true);
    }
  }

  void createDirectoryIfNotExists(String directoryPath) {
    Directory directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      // directory does not exist, create it
      directory.createSync(recursive: true);
    }
  }
}

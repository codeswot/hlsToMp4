import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:video_player_test/service/api.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  const VideoWidget({super.key, required this.videoUrl});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  // final String _videoUrl =
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  @override
  void initState() {
    super.initState();
    _checkConnectionAndInitializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _checkConnectionAndInitializeVideo() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      _initializeVideoPlayer(widget.videoUrl);

      // _initializeVideoPlayer(File(fileInfo.file.path));
    } else {
      String path =
          '/data/user/0/com.example.video_player_test/app_flutter/https://s3cdn.skiiishow.com/assets/01f30961-156b-42dd-9574-2eb4154ad736/HLS/1e150bac-b600-4bbd-bb26-1354155cad98_720.m3u8';

      _initializeVideoPlayerOffline(path);
      // final file = await getSavedM3U8File(widget.videoUrl);
      // print('cached file >>> ${file.path}');
      // final url = await startServer(file.path);
      // print('Url from local server >>> $url');
      // _initializeVideoPlayer(url);
      // _initializeVideoPlayer(file);
    }
  }

  void _initializeVideoPlayer(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
        // _controller!.setLooping(true);
      });
  }

  void _initializeVideoPlayerOffline(String path) {
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
        // _controller!.setLooping(true);
      });
  }

  // void _initializeVideoPlayer(File file) {
  //   _controller = VideoPlayerController.file(file)
  //     ..initialize().then((_) {
  //       setState(() {});
  //       _controller?.play();
  //       _controller!.setLooping(true);
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller != null && _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : const CircularProgressIndicator(),
    );
  }
}

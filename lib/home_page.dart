import 'package:flutter/material.dart';
import 'package:video_player_test/service/api.dart';
import 'package:video_player_test/video_widget.dart';

import 'service/post.dart';

class ForYouPostPage extends StatelessWidget {
  const ForYouPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('For You Post'),
      ),
      body: FutureBuilder<ForYouPost>(
        future: getForYouPost(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print('Post >>> ${snapshot.data!.post}');
            return VideoWidget(
              videoUrl: snapshot.data!.post.media.first,
            );
          }
        },
      ),
    );
  }
}

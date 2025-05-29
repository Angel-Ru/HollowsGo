import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoService {
  static Future<
      ({
        VideoPlayerController videoController,
        ChewieController chewieController
      })?> initAssetVideo({
    required String assetPath,
    required VoidCallback onVideoEnd,
    bool autoPlay = true,
    bool looping = false,
    bool allowFullScreen = false,
    bool showControls = false,
  }) async {
    try {
      final videoController = VideoPlayerController.asset(assetPath);
      await videoController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: autoPlay,
        looping: looping,
        allowFullScreen: allowFullScreen,
        showControls: showControls,
      );

      videoController.addListener(() {
        if (videoController.value.position >= videoController.value.duration) {
          onVideoEnd();
        }
      });

      return (
        videoController: videoController,
        chewieController: chewieController
      );
    } catch (e) {
      debugPrint('Error initializing video: $e');
      return null;
    }
  }

  static void disposeControllers({
    VideoPlayerController? videoController,
    ChewieController? chewieController,
  }) {
    videoController?.dispose();
    chewieController?.dispose();
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DialogVideoPlayer {
  static VideoPlayerController? _videoController;
  static ChewieController? _chewieController;

  static Future<_VideoInitResult> initVideo({
    required Map<String, dynamic>? skin,
    required VoidCallback onVideoEnd,
  }) async {
    final videoPath = skin?['video_especial'];
    if (videoPath == null || videoPath.isEmpty) {
      return _VideoInitResult(showContent: true, isReady: false);
    }

    _videoController = VideoPlayerController.asset(videoPath);
    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        showControls: false,
        allowFullScreen: false,
      );

      _videoController!.addListener(() {
        if (_videoController!.value.position >= _videoController!.value.duration) {
          onVideoEnd();
        }
      });

      return _VideoInitResult(showContent: false, isReady: true);
    } catch (_) {
      return _VideoInitResult(showContent: true, isReady: false);
    }
  }

  static Widget build() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12.withOpacity(0.7), width: 4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }

  static void dispose() {
    _videoController?.removeListener(() {});
    _videoController?.dispose();
    _chewieController?.dispose();
  }
}

class _VideoInitResult {
  final bool showContent;
  final bool isReady;

  _VideoInitResult({required this.showContent, required this.isReady});
}

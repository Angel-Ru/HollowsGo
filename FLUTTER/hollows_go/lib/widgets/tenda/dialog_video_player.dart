import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hollows_go/service/videoservice.dart';
import 'package:video_player/video_player.dart';

// Importa el CustomLoadingIndicator
import 'package:hollows_go/widgets/custom_loading_indicator.dart';

class DialogVideoPlayer {
  static VideoPlayerController? _videoController;
  static ChewieController? _chewieController;
  static bool _isLoading = false;

  static bool get isLoading => _isLoading;

  static Future<_VideoInitResult> initVideo({
    required Map<String, dynamic>? skin,
    required VoidCallback onVideoEnd,
  }) async {
    final videoPath = skin?['video_especial'];
    if (videoPath == null || videoPath.isEmpty) {
      _isLoading = false;
      return _VideoInitResult(showContent: true, isReady: false);
    }

    _isLoading = true;

    final result = await VideoService.initAssetVideo(
      assetPath: videoPath,
      onVideoEnd: onVideoEnd,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
    );

    _isLoading = false;

    if (result == null) {
      return _VideoInitResult(showContent: true, isReady: false);
    }

    _videoController = result.videoController;
    _chewieController = result.chewieController;

    return _VideoInitResult(showContent: false, isReady: true);
  }

  static Widget build() {
    if (_isLoading) {
      // Mostrem el loader mentre es carrega
      return const Center(
        child: CustomLoadingIndicator(),
      );
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const SizedBox.shrink(); // Per evitar errors si no està preparat
    }

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
    VideoService.disposeControllers(
      videoController: _videoController,
      chewieController: _chewieController,
    );
    _videoController = null;
    _chewieController = null;
    _isLoading = false;
  }
}

class _VideoInitResult {
  final bool showContent;
  final bool isReady;

  _VideoInitResult({required this.showContent, required this.isReady});
}

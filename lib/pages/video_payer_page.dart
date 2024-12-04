import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // ignore: deprecated_member_use
      _videoPlayerController = VideoPlayerController.asset(
          "assets/video/Ser");

      await _videoPlayerController.initialize();

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          allowMuting: true,
          looping: true,
          autoPlay: true,
        );
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");

      setState(() {
        _errorMessage =
            "Video playback error: Ensure the video is re-encoded with H.264 codec and resolution within 1920x1080.";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : Center(
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                ),
    );
  }
}

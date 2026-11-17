import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeDemoPlayer extends StatefulWidget {
  final String videoId;
  final String title;

  const YoutubeDemoPlayer({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<YoutubeDemoPlayer> createState() =>
      _YoutubeDemoPlayerState();
}

class _YoutubeDemoPlayerState
    extends State<YoutubeDemoPlayer> {

  late final YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        privacyEnhancedMode: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    // Limit dialog width on desktop and fit mobile screens
    final dialogWidth =
    (screenSize.width - 32).clamp(0.0, 900.0).toDouble();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenSize.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dialog Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Responsive YouTube Video Player
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: controller,
                      aspectRatio: 16 / 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
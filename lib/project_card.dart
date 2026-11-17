
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProjectCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<String> tech;
  final String? githubUrl;
  final String? youtubeUrl;

  const ProjectCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.tech,
    this.githubUrl,
    this.youtubeUrl,
  });

  // ==========================================
  // OPEN GITHUB
  // ==========================================
  Future<void> _openGitHub(
      BuildContext context,
      String url,
      ) async {
    try {
      final uri = Uri.tryParse(url);

      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host != 'github.com') {
        throw Exception('Invalid GitHub URL');
      }

      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        throw Exception('Could not open GitHub');
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open GitHub link'),
        ),
      );
    }
  }

  // ==========================================
  // GET YOUTUBE VIDEO ID
  // ==========================================
  String? _getYouTubeId(String url) {
    final uri = Uri.tryParse(url.trim());

    if (uri == null || uri.scheme != 'https') {
      return null;
    }

    final host = uri.host.toLowerCase();
    String? videoId;

    // Short YouTube URL
    if (host == 'youtu.be') {
      if (uri.pathSegments.isNotEmpty) {
        videoId = uri.pathSegments.first;
      }
    }

    // Standard YouTube URL
    else if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com')) {

      // Example: youtube.com/watch?v=VIDEO_ID
      videoId = uri.queryParameters['v'];

      if (videoId == null || videoId.isEmpty) {
        final segments = uri.pathSegments;

        // Example: youtube.com/embed/VIDEO_ID
        // Example: youtube.com/shorts/VIDEO_ID
        // Example: youtube.com/live/VIDEO_ID

        for (int i = 0; i < segments.length - 1; i++) {
          if (['embed', 'shorts', 'live'].contains(segments[i])) {
            videoId = segments[i + 1];
            break;
          }
        }
      }
    }

    // Validate YouTube video ID
    if (videoId == null ||
        !RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(videoId)) {
      return null;
    }

    return videoId;
  }

  // ==========================================
  // WATCH YOUTUBE DEMO
  // ==========================================
  void _watchDemo(BuildContext context) {
    final url = youtubeUrl;

    if (url == null || url.isEmpty) {
      return;
    }

    final videoId = _getYouTubeId(url);

    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid YouTube URL'),
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return YoutubeDemoDialog(
          videoId: videoId,
          title: title,
        );
      },
    );
  }

  // ==========================================
  // PROJECT CARD UI
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Project Icon and Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Project Description
            Text(
              description,
              style: const TextStyle(
                height: 1.6,
                color: Colors.black54,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 16),

            // Technology Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tech.map((t) {
                return Chip(
                  label: Text(
                    t,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  backgroundColor: Colors.grey.shade100,
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // GitHub and YouTube Buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                if (githubUrl != null)
                  OutlinedButton.icon(
                    onPressed: () {
                      _openGitHub(context, githubUrl!);
                    },
                    icon: const Icon(Icons.code),
                    label: const Text('GitHub Source'),
                  ),

                if (youtubeUrl != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      _watchDemo(context);
                    },
                    icon: const Icon(
                      Icons.play_circle_fill,
                    ),
                    label: const Text('Watch Demo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// YOUTUBE DEMO DIALOG
// ==========================================

class YoutubeDemoDialog extends StatefulWidget {
  final String videoId;
  final String title;

  const YoutubeDemoDialog({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<YoutubeDemoDialog> createState() =>
      _YoutubeDemoDialogState();
}

class _YoutubeDemoDialogState
    extends State<YoutubeDemoDialog> {

  late final YoutubePlayerController controller;

  // ==========================================
  // INITIALIZE YOUTUBE PLAYER
  // ==========================================
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

  // ==========================================
  // DISPOSE PLAYER
  // ==========================================
  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  // ==========================================
  // RESPONSIVE DIALOG UI
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final dialogWidth = (screenSize.width - 64)
        .clamp(0.0, 850.0)
        .toDouble();

    final dialogPadding =
    screenSize.width < 600 ? 12.0 : 20.0;

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
              padding: EdgeInsets.all(dialogPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Dialog Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: screenSize.width < 600
                                ? 18
                                : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // YouTube Video Player
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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

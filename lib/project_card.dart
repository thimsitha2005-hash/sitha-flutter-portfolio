import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<String> tech;
  final String? githubUrl;

  const ProjectCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.tech,
    this.githubUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: color),
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
            Text(
              description,
              style: const TextStyle(
                height: 1.6,
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tech
                  .map((t) => Chip(
                label: Text(t, style: const TextStyle(fontSize: 13)),
                backgroundColor: Colors.grey.shade100,
              ))
                  .toList(),
            ),
            if (githubUrl != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(githubUrl!)),
                icon: const Icon(Icons.code, size: 20),
                label: const Text('View on GitHub'),
                style: TextButton.styleFrom(
                  foregroundColor: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
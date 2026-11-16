import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'project_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Section Keys
  static final GlobalKey homeKey = GlobalKey();
  static final GlobalKey projectKey = GlobalKey();
  static final GlobalKey contactKey = GlobalKey();

  static const Color navy = Color(0xFF17243A);

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> openLink(String link) async {
    final Uri uri = Uri.parse(link);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not open $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        title: const Text(
          'THIM SITHA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => scrollToSection(homeKey),
            child: const Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => scrollToSection(projectKey),
            child: const Text('Project', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => scrollToSection(contactKey),
            child: const Text('Contact', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========== HOME / HERO ==========
                  Container(
                    key: homeKey,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // On small screens → stack vertically, image on top
                        // On larger screens → image on the right
                        final isWide = constraints.maxWidth > 900;

                        final textContent = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                          "HELLO, I'M THIM SITHA",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Flutter Developer',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: navy,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'I build beautiful and functional mobile applications\nusing Flutter and Dart.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                ElevatedButton(
                                  onPressed: () => scrollToSection(projectKey),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('View Projects'),
                                ),
                                OutlinedButton(
                                  onPressed: () => scrollToSection(contactKey),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: navy,
                                    side: const BorderSide(color: navy),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('Contact Me'),
                                ),
                              ],
                            ),
                          ],
                        );

                        final profileImage = CircleAvatar(
                          radius: isWide ? 110 : 80,
                          backgroundImage: const AssetImage('assets/images/IMG_6554.jpg'),
                          backgroundColor: Colors.grey.shade200,
                        );

                        if (isWide) {
                          // Desktop / tablet → text left, image closer on the right
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3, // text takes more space
                                child: textContent,
                              ),
                              const SizedBox(width: 40), // ← reduced gap
                              profileImage,
                            ],
                          );
                        } else {
                          // Mobile → image on top, then text
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: profileImage),
                              const SizedBox(height: 32),
                              textContent,
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  // ========== ABOUT ==========
                  const Text(
                    'About Me',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'I am a Management Information Technology student interested in Flutter development '
                        'and mobile application development. I enjoy building user-friendly applications '
                        'and integrating REST APIs.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // ========== SKILLS ==========
                  const Text(
                    'Technical Skills',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      Chip(label: Text('Flutter')),
                      Chip(label: Text('Dart')),
                      Chip(label: Text('REST API')),
                      Chip(label: Text('JSON')),
                      Chip(label: Text('Git')),
                      Chip(label: Text('GitHub')),
                      Chip(label: Text('MySQL')),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // ========== PROJECTS ==========
                  Container(
                    key: projectKey,
                    child: const Text(
                      'My Projects',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Coffee Shop App
                  const ProjectCard(
                    icon: Icons.coffee,
                    color: Colors.brown,
                    title: 'Coffee Shop App',
                    description:
                    'A coffee ordering app with a clean UI, product list, and cart screen. '
                        'Focused on layout, custom widgets, and responsive design using static data.',
                    tech: ['Flutter', 'Dart', 'UI Design'],
                    githubUrl: 'https://github.com/thimsitha2005-hash/coffee-shop-app',
                  ),

                  // E-Commerce App
                  const ProjectCard(
                    icon: Icons.shopping_bag,
                    color: Colors.blue,
                    title: 'E-Commerce Shop App',
                    description:
                    'A shopping app that fetches products from a REST API and parses JSON data. '
                        'Includes multiple screens with navigation (routing), product list, and product details.',
                    tech: ['Flutter', 'Dart', 'REST API', 'JSON', 'Navigation'],
                    githubUrl: 'https://github.com/thimsitha2005-hash/e-commerce-shop-app',
                  ),

                  const SizedBox(height: 60),

                  // ========== CONTACT ==========
                  Container(
                    key: contactKey,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    decoration: BoxDecoration(
                      color: navy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Get In Touch',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Thank you for visiting my portfolio. '
                              'Feel free to contact me for opportunities or collaboration.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            TextButton.icon(
                              onPressed: () => openLink(
                                'https://mail.google.com/mail/?view=cm&fs=1&to=thimsitha2005%40gmail.com',
                              ),
                              icon: const Icon(Icons.email, color: Colors.white),
                              label: const Text(
                                'Email',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => openLink('https://github.com/thimsitha2005-hash'),
                              icon: const Icon(Icons.code, color: Colors.white),
                              label: const Text('GitHub', style: TextStyle(color: Colors.white)),
                            ),
                            // TextButton.icon(
                            //   onPressed: () => openLink('https://www.linkedin.com/in/thim-sitha-a34777382/'),
                            //   icon: const Icon(Icons.link, color: Colors.white),
                            //   label: const Text('LinkedIn', style: TextStyle(color: Colors.white)),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portal8/screens/practice_uploader_screen.dart';

class AdvancedPracticesScreen extends StatefulWidget {
  @override
  _AdvancedPracticesScreenState createState() =>
      _AdvancedPracticesScreenState();
}

class _AdvancedPracticesScreenState extends State<AdvancedPracticesScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> practices = [];
  int _tapCount = 0;
  bool _showUploader = false;
  bool _isAdmin = false;
  late AnimationController _bgController;
  final Random _random = Random();
  late List<Offset> _stars;

  @override
  void initState() {
    super.initState();
    loadPractices();
    checkAdminStatus();
    _stars = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _stars = List.generate(25, (_) {
          return Offset(
            _random.nextDouble() * size.width,
            _random.nextDouble() * size.height,
          );
        });
      });
    });

    _bgController =
    AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  Future<void> loadPractices() async {
    final data =
    await rootBundle.loadString('assets/advanced_practices.json');
    setState(() {
      practices = json.decode(data);
    });
  }

  Future<void> checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final token = await user.getIdTokenResult(true);
    setState(() {
      _isAdmin = token.claims?['admin'] == true;
    });
  }

  void _showPracticeModal(Map<String, dynamic> practice) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("🧘 ${practice['title']}",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(practice['description'],
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white70, height: 1.4),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text("⏳ Duration: ${practice['duration']}",
                      style:
                      const TextStyle(fontSize: 14, color: Colors.cyan)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("✨ Begin Practice",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleGlyphTap() {
    setState(() {
      _tapCount++;
      if (_tapCount >= 3) {
        _showUploader = true;
      }
    });
  }

  Future<void> _launchUploader() async {
    if (!_isAdmin) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("🚫 Access Denied",
                style: TextStyle(color: Colors.white)),
            content: const Text("You are not authorized to upload practices.",
                style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK",
                    style: TextStyle(color: Colors.purpleAccent)),
              ),
            ],
          );
        },
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PracticeUploaderScreen()),
    );
  }

  Widget _buildStarfield(BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Stack(
          children: _stars
              .map((star) => Positioned(
            left: (star.dx +
                sin(_bgController.value * 2 * pi) * 0.3) %
                w,
            top: (star.dy +
                cos(_bgController.value * 2 * pi) * 0.3) %
                h,
            child: Container(
              width: 2,
              height: 2,
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
            ),
          ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            // Animated gradient background
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade900,
                        Colors.blue.shade900,
                        Colors.black
                      ],
                      stops: [
                        0.2 + 0.1 * sin(_bgController.value * 2 * pi),
                        0.6,
                        1.0
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
            _buildStarfield(constraints),

            // Content
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text("🧘 Advanced Practices",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.verified_user,
                              color: Colors.white),
                          onPressed: checkAdminStatus,
                          tooltip: "Check Admin Status",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: practices.isEmpty
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.cyan))
                        : PageView.builder(
                      itemCount: practices.length,
                      controller:
                      PageController(viewportFraction: 0.85),
                      itemBuilder: (context, index) {
                        final item = practices[index];
                        return GestureDetector(
                          onTap: () => _showPracticeModal(item),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10, sigmaY: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("🧘 ${item['title']}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight:
                                              FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                            item['description'],
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("⏳ ${item['duration']}",
                                          style: const TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Mystic glyph in bottom right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: _handleGlyphTap,
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [Colors.cyan, Colors.blueAccent],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            "▲",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_showUploader)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ElevatedButton(
                        onPressed: _launchUploader,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("📤 Upload Practices",
                            style:
                            TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

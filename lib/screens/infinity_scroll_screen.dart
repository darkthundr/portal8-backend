import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfinityScrollScreen extends StatefulWidget {
  const InfinityScrollScreen({super.key});

  @override
  State<InfinityScrollScreen> createState() => _InfinityScrollScreenState();
}

class _InfinityScrollScreenState extends State<InfinityScrollScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> sessions = [];
  bool _showUploader = false;
  int _glyphTapCount = 0;

  late PageController _pageController;
  final Map<int, AnimationController> _controllers = {};
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInfinitySessions();
  }

  Future<void> _loadInfinitySessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customPath = prefs.getString('uploadedInfinityPath');

      String data;
      if (customPath != null && File(customPath).existsSync()) {
        data = await File(customPath).readAsString();
      } else {
        data = await rootBundle.loadString('assets/infinity_scroll.json');
      }

      final List<dynamic> parsed = json.decode(data);
      final shuffled = parsed.map((e) => Map<String, dynamic>.from(e)).toList()..shuffle(_random);

      setState(() {
        sessions = shuffled;
      });
    } catch (e) {
      print("❌ Error loading JSON: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to load sessions: $e"))
      );
    }
  }

  AnimationController _getController(int index) {
    if (_controllers[index] == null) {
      _controllers[index] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..forward();
    }
    return _controllers[index]!;
  }

  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('infinityFavorites') ?? [];
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await prefs.setStringList('infinityFavorites', favorites);
    setState(() {});
  }

  Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('infinityFavorites') ?? [];
    return favorites.contains(id);
  }

  Future<void> _uploadNewJson() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      try {
        final List<dynamic> parsed = json.decode(content);
        final shuffled = parsed.map((e) => Map<String, dynamic>.from(e)).toList()..shuffle(_random);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uploadedInfinityPath', file.path);

        setState(() {
          sessions = shuffled;
          _glyphTapCount = 0;
          _showUploader = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ New sessions uploaded"))
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Failed to parse JSON: $e"))
        );
      }
    }
  }

  void _showSessionModal(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("🌀 ${session['title']}",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.white24, blurRadius: 12)]
                      ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 12),
                  Text(session['hook'],
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic
                      ),
                      textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 12),
                  Text("📖 ${session['story']}", style: const TextStyle(color: Colors.white60)),
                  const SizedBox(height: 12),
                  if (session['guidedPractice'] != null)
                    ...List<String>.from(session['guidedPractice']).map((step) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text("• $step", style: const TextStyle(color: Colors.white70)),
                        )
                    ),
                  const SizedBox(height: 12),
                  if (session['reflection'] != null)
                    Text("🪞 ${session['reflection']}", style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  if (session['scientificNote'] != null)
                    Text("🧪 ${session['scientificNote']}", style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 12),
                  if (session['cosmicAnalogy'] != null)
                    Text("🌌 ${session['cosmicAnalogy']}", style: const TextStyle(color: Colors.white60)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("✨ Close", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMysticReel(Map<String, dynamic> session, int index) {
    final id = session['id'];
    final controller = _getController(index);

    // Random transitions: fade / scale / rotate
    final effect = _random.nextInt(3);

    Widget content = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.grey.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Cosmic particle background
          ...List.generate(30, (_) {
            final x = _random.nextDouble();
            final y = _random.nextDouble();
            final size = _random.nextDouble() * 3 + 1;
            return Positioned(
              left: x * MediaQuery.of(context).size.width,
              top: y * MediaQuery.of(context).size.height,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
              ),
            );
          }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🌀 ${session['title']}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.white24, blurRadius: 12)],
                  ),
                  textAlign: TextAlign.center
              ),
              const SizedBox(height: 16),
              Text(session['hook'],
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic
                  ),
                  textAlign: TextAlign.center
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _showSessionModal(session),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text("✨ Enter Practice", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );

    switch (effect) {
      case 0:
        return FadeTransition(opacity: controller.drive(Tween(begin: 0.0, end: 1.0)), child: content);
      case 1:
        return ScaleTransition(scale: controller.drive(Tween(begin: 0.8, end: 1.0)), child: content);
      case 2:
        return RotationTransition(turns: controller.drive(Tween(begin: 0.01, end: 0.0)), child: content);
      default:
        return content;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.forEach((key, ctrl) => ctrl.dispose());
    super.dispose(); // ✅ always call super.dispose()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "∞ Infinity Scroll ∞",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: Stack(
        children: [
          sessions.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final session = sessions[index % sessions.length];
              return _buildMysticReel(session, index % sessions.length);
            },
          ),
          if (_showUploader)
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: _uploadNewJson,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
                ),
                child: const Text("📂 Upload JSON", style: TextStyle(color: Colors.white)),
              ),
            ),
          // Hidden tap for uploader
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                _glyphTapCount++;
                if (_glyphTapCount >= 5) {
                  setState(() {
                    _showUploader = true;
                  });
                }
              },
              child: const Text("✨", style: TextStyle(fontSize: 28, color: Colors.white24)),
            ),
          )
        ],
      ),
    );
  }
}

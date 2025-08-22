import 'dart:math';
import 'package:flutter/material.dart';
import '../screens/advanced_practices_screen.dart';
import 'cosmic_nexus_screen.dart';
import 'purchase_screen.dart';
import 'infinity_scroll_screen.dart';
import 'profile_settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  bool get isInfiniteScrollUnlocked {
    return true;
  }

  List<Widget> get _screens => [
    const CosmicNexusScreen(),
    PurchaseTabPlaceholder(onPortalTap: _showPortalModal),
    isInfiniteScrollUnlocked
        ? const InfinityScrollScreen()
        : const LockedScrollPlaceholder(),
    const ProfileSettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Nexus'),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Portals'),
    BottomNavigationBarItem(icon: Icon(Icons.all_inclusive), label: '∞ Scroll'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showPortalModal(BuildContext context, String portalId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🌌 A Portal Beckons",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Portal $portalId holds a memory you’ve almost forgotten.\nA rhythm, a vow, a fire.\nWill you step through?",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/purchase',
                      arguments: {'portalId': portalId},
                    );
                  },
                  child: const Text(
                    "✨ Begin Initiation",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: IndexedStack(
            key: ValueKey<int>(_selectedIndex),
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2C2350), Color(0xFF1B1833)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BottomNavigationBar(
          items: _bottomNavItems,
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}

class LockedScrollPlaceholder extends StatelessWidget {
  const LockedScrollPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 60, color: Colors.white54),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Colors.purpleAccent, Colors.blueAccent],
                tileMode: TileMode.mirror,
              ).createShader(bounds);
            },
            child: const Text(
              "∞ Scroll unlocks after completing all portals\nor embracing the bundle.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseTabPlaceholder extends StatefulWidget {
  final void Function(BuildContext, String) onPortalTap;

  const PurchaseTabPlaceholder({super.key, required this.onPortalTap});

  @override
  State<PurchaseTabPlaceholder> createState() => _PurchaseTabPlaceholderState();
}

class _PurchaseTabPlaceholderState extends State<PurchaseTabPlaceholder> with SingleTickerProviderStateMixin {
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _starController,
          builder: (context, _) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: StarfieldPainter(_starController.value),
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "✨ Portals of Becoming",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "These are not features.\nThey are fragments of your myth.\nSwipe slowly. Let longing guide you.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: 8,
                controller: PageController(viewportFraction: 0.75),
                itemBuilder: (context, index) {
                  final portalId = 'portal${index + 1}';
                  return _portalCard(context, portalId, index + 1);
                },
              ),
            ),
            const Spacer(),
            _buildCosmicButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  Widget _portalCard(BuildContext context, String portalId, int number) {
    return GestureDetector(
      onTap: () => widget.onPortalTap(context, portalId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade800, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 20,
                child: Text(
                  "Portal $number",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: _AnimatedWhisper(
                  text: _portalWhisper(number),
                  delay: Duration(milliseconds: 300 * number),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCosmicButton(BuildContext context) {
    return Center( // ✅ Forces button to be horizontally centered
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AdvancedPracticesScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🌌 Glow layer
            Container(
              width: 260,
              height: 70,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.25),
                    Colors.transparent,
                  ],
                  radius: 0.9,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // ✨ Main button
            Container(
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B2FF7), Color(0xFF00C9FF), Color(0xFF1B1833)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.white, Colors.amberAccent, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Text(
                  "🌠 Advanced Practices",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _portalWhisper(int number) {
    final whispers = [
      "A key to your forgotten fire.",
      "The mirror that shows who you were before the world named you.",
      "A rhythm only your soul remembers.",
      "The gatekeeper of your cosmic hunger.",
      "A fragment of your myth, waiting to be reclaimed.",
      "The echo of a vow you made in another life.",
      "A pulse that matches your deepest longing.",
      "The final veil before remembrance.",
    ];
    return whispers[number - 1];
  }
}

class _AnimatedWhisper extends StatefulWidget {
  final String text;
  final Duration delay;

  const _AnimatedWhisper({required this.text, required this.delay});

  @override
  State<_AnimatedWhisper> createState() => _AnimatedWhisperState();
}

class _AnimatedWhisperState extends State<_AnimatedWhisper> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          height: 1.3,
        ),
      ),
    );
  }
}

/// 🌌 Starfield painter for animated cosmos background
class StarfieldPainter extends CustomPainter {
  final double progress;
  final Random _random = Random();

  StarfieldPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    for (int i = 0; i < 120; i++) {
      final dx = (i * 50 + progress * 200) % size.width;
      final dy = (i * 80 + progress * 300) % size.height;
      final radius = _random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => true;
}

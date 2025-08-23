import 'package:flutter/material.dart';
import '../models/portal_model.dart';

class AnimatedPortalTile extends StatefulWidget {
  final Portal portal;
  final Duration delay;
  final bool isLocked;
  final VoidCallback onTap;

  const AnimatedPortalTile({
    required this.portal,
    required this.delay,
    required this.onTap,
    this.isLocked = false,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedPortalTile> createState() => _AnimatedPortalTileState();
}

class _AnimatedPortalTileState extends State<AnimatedPortalTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFreeTrial = widget.portal.id == "portal0";

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.portal.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white24,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.portal.title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 🔐 Lock overlay (if not free trial and isLocked)
              if (!isFreeTrial && widget.isLocked)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock_outline,
                        color: Colors.white70, size: 32),
                  ),
                ),

              // 🆓 Free Trial badge
              if (isFreeTrial)
                Positioned(
                  top: 8,
                  right: -20,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.deepPurple],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Free Trial",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

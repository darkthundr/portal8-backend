import 'package:flutter/material.dart';
import 'package:portal8/models/session_model.dart';
import 'package:simple_animations/simple_animations.dart';

class SessionTile extends StatefulWidget {
  final Session session;
  final bool isUnlocked;
  final VoidCallback onTap;

  const SessionTile({
    super.key,
    required this.session,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  _SessionTileState createState() => _SessionTileState();
}

class _SessionTileState extends State<SessionTile> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isLocked = !widget.isUnlocked;

    final animatedFloatingTile = PlayAnimationBuilder<double>(
      tween: Tween(begin: -5.0, end: 5.0),
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        return Transform.translate(offset: Offset(0, value), child: child);
      },
      child: _buildTileContent(theme, screenWidth, isLocked),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapCancel: () => setState(() => _isTapped = false),
        onTapUp: (_) => setState(() => _isTapped = false),
        borderRadius: BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isLocked ? Colors.black.withOpacity(0.4) : null,
            gradient: isLocked
                ? null
                : LinearGradient(
              colors: [
                _isTapped
                    ? theme.colorScheme.onPrimary.withOpacity(0.9)
                    : theme.colorScheme.primary.withOpacity(0.6),
                _isTapped
                    ? theme.colorScheme.primary.withOpacity(0.9)
                    : theme.colorScheme.onPrimary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isLocked
                  ? Colors.grey.withOpacity(0.4)
                  : _isTapped
                  ? theme.colorScheme.secondary.withOpacity(1.0)
                  : theme.colorScheme.secondary.withOpacity(0.7),
              width: 1.5,
            ),
            boxShadow: isLocked
                ? []
                : [
              BoxShadow(
                color: theme.colorScheme.secondary.withOpacity(_isTapped ? 0.4 : 0.2),
                blurRadius: _isTapped ? 25 : 15,
                spreadRadius: _isTapped ? 5 : 2,
              ),
            ],
          ),
          child: widget.isUnlocked ? animatedFloatingTile : _buildTileContent(theme, screenWidth, isLocked),
        ),
      ),
    );
  }

  Widget _buildTileContent(ThemeData theme, double screenWidth, bool isLocked) {
    return Row(
      children: [
        Icon(
          widget.isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
          color: widget.isUnlocked ? theme.colorScheme.tertiary : theme.disabledColor,
          size: screenWidth * 0.07,
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: Text(
            "${widget.session.number}. ${widget.session.title}",
            style: theme.textTheme.titleMedium?.copyWith(
              color: isLocked ? Colors.white54 : Colors.white,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (widget.isUnlocked)
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white.withOpacity(0.7),
            size: screenWidth * 0.05,
          ),
      ],
    );
  }
}
class ExpandableSection extends StatefulWidget {
  final String label;
  final dynamic content;

  const ExpandableSection({required this.label, required this.content, Key? key}) : super(key: key);

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.content == null || widget.content.toString().trim().isEmpty) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.label,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white70,
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: widget.content is List
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.content
                        .map<Widget>((item) => Text("• $item", style: TextStyle(color: Colors.white70)))
                        .toList(),
                  )
                      : Text(widget.content.toString(), style: TextStyle(color: Colors.white70)),
                ),
                crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
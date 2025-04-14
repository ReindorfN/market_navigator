import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isVertical;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    this.isVertical = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set colors based on theme
    final iconColor = isDarkMode ? Colors.white : Colors.blueAccent;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: iconColor),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isVertical
              ? content
              : Row(
                  children: [
                    Icon(icon, color: iconColor),
                    const SizedBox(width: 8),
                    Text(label, style: TextStyle(color: textColor)),
                  ],
                ),
        ),
      ),
    );
  }
}

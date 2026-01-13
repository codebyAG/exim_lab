import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:flutter/material.dart';

class QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: appCardShadow(context),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 🔹 TOP CURVED HALF
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.90),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
              ),

              // 🔹 ICON ON CURVE LINE
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(icon, size: 22, color: cs.primary),
                  ),
                ),
              ),

              // 🔹 CONTENT
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 72, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
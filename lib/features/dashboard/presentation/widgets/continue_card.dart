import 'package:exim_lab/core/constants/appcardshadow.dart';
import 'package:flutter/material.dart';

class ContinueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: appCardShadow(context),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: AssetImage('assets/course1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Export Basics – Lesson 3',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: cs.surfaceContainerHighest,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


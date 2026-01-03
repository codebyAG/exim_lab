import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Certificates',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _CertificateCard(
            title: 'Advanced Export Strategy',
            issuedDate: '12 Jan 2026',
            isUnlocked: true,
          ),
          _CertificateCard(
            title: 'Import Documentation Mastery',
            issuedDate: '—',
            isUnlocked: false,
          ),
          _CertificateCard(
            title: 'Logistics & Shipping Basics',
            issuedDate: '—',
            isUnlocked: false,
          ),
        ],
      ),
    );
  }
}

// 🔹 CERTIFICATE CARD
class _CertificateCard extends StatelessWidget {
  final String title;
  final String issuedDate;
  final bool isUnlocked;

  const _CertificateCard({
    required this.title,
    required this.issuedDate,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 HEADER ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  size: 36,
                  color: Color(0xFFFF8A00),
                ),
                _StatusChip(isUnlocked: isUnlocked),
              ],
            ),

            const SizedBox(height: 14),

            // 🔹 TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              isUnlocked
                  ? 'Issued on $issuedDate'
                  : 'Complete the course to unlock',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 18),

            // 🔹 ACTIONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isUnlocked ? () {} : null,
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isUnlocked ? () {} : null,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 STATUS CHIP
class _StatusChip extends StatelessWidget {
  final bool isUnlocked;

  const _StatusChip({required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUnlocked
            ? const Color(0xFFE8F7EF)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isUnlocked ? 'Completed' : 'Locked',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isUnlocked
              ? const Color(0xFF22C55E)
              : const Color(0xFFFF8A00),
        ),
      ),
    );
  }
}

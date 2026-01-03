import 'package:exim_lab/features/certificates/presentation/screens/certificate_preview_screen.dart';
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _CertificateTile(
            title: 'Advanced Export Strategy',
            issuedDate: '12 Jan 2026',
            isUnlocked: true,
          ),
          _CertificateTile(
            title: 'Import Documentation Mastery',
            issuedDate: '',
            isUnlocked: false,
          ),
        ],
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  final String title;
  final String issuedDate;
  final bool isUnlocked;

  const _CertificateTile({
    required this.title,
    required this.issuedDate,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1 : 0.55,
      child: GestureDetector(
        onTap: isUnlocked
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CertificatePreviewScreen(
                      courseName: title,
                      userName: 'Akash Goyal',
                      issueDate: issuedDate,
                      certificateId: 'EXIM-2026-001',
                    ),
                  ),
                );
              }
            : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 40,
                color: Color(0xFFFF8A00),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUnlocked
                          ? 'Issued on $issuedDate'
                          : 'Complete course to unlock',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isUnlocked ? Icons.chevron_right : Icons.lock_outline,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

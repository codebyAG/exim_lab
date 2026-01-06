import 'package:exim_lab/features/certificates/presentation/screens/certificate_preview_screen.dart';
import 'package:flutter/material.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text('Certificates', style: theme.textTheme.titleLarge),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
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
    final theme = Theme.of(context);

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
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.light
                    ? Colors.black.withOpacity(0.05)
                    : Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            children: [
              Icon(
                Icons.workspace_premium,
                size: 40,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      isUnlocked
                          ? 'Issued on $issuedDate'
                          : 'Complete course to unlock',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                isUnlocked ? Icons.chevron_right : Icons.lock_outline,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

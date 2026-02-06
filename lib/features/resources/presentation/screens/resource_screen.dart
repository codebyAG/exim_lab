import 'package:flutter/material.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          t.translate('resources'),
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(title: t.translate('export_guides')),
          _ResourceCard(
            title: t.translate('export_business_starter_guide'),
            type: 'PDF',
            size: '2.4 MB',
          ),
          _ResourceCard(
            title: t.translate('finding_international_buyers'),
            type: 'PDF',
            size: '1.8 MB',
          ),

          const SizedBox(height: 24),

          _SectionTitle(title: t.translate('import_documentation')),
          _ResourceCard(
            title: t.translate('import_documentation_checklist'),
            type: 'PDF',
            size: '1.2 MB',
          ),
          _ResourceCard(
            title: t.translate('hs_code_classification_guide'),
            type: 'PDF',
            size: '3.1 MB',
          ),

          const SizedBox(height: 24),

          _SectionTitle(title: t.translate('compliance_legal')),
          _ResourceCard(
            title: t.translate('iec_registration_process'),
            type: 'DOC',
            size: '850 KB',
          ),
          _ResourceCard(
            title: t.translate('gst_for_import_export'),
            type: 'PDF',
            size: '2.0 MB',
          ),
        ],
      ),
    );
  }
}

// 🔹 SECTION TITLE
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }
}

// 🔹 RESOURCE CARD
class _ResourceCard extends StatelessWidget {
  final String title;
  final String type;
  final String size;

  const _ResourceCard({
    required this.title,
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // FILE ICON
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type • $size',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          // ACTION
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Downloading $title...')));
            },
            icon: const Icon(Icons.download),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:exim_lab/localization/app_localization.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          t.translate('resources'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.insert_drive_file,
              color: Color(0xFFFF8A00),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type • $size',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              // TODO: Open / Download resource
            },
            icon: const Icon(Icons.download),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/core/services/analytics_service.dart';

class IncotermsScreen extends StatelessWidget {
  const IncotermsScreen({super.key});

  final List<Map<String, String>> _terms = const [
    {
      'code': 'EXW',
      'title': 'Ex Works',
      'desc':
          'Seller makes goods available at their premises. Buyer bears all risks and costs from there.',
    },
    {
      'code': 'FCA',
      'title': 'Free Carrier',
      'desc':
          'Seller delivers goods to a carrier or another person nominated by the buyer.',
    },
    {
      'code': 'CPT',
      'title': 'Carriage Paid To',
      'desc':
          'Seller delivers goods to the carrier and pays for carriage to the named destination.',
    },
    {
      'code': 'CIP',
      'title': 'Carriage and Insurance Paid To',
      'desc': 'Same as CPT, but seller also pays for insurance coverage.',
    },
    {
      'code': 'DAP',
      'title': 'Delivered at Place',
      'desc':
          'Seller delivers when goods are placed at the disposal of the buyer at the named destination.',
    },
    {
      'code': 'DPU',
      'title': 'Delivered at Place Unloaded',
      'desc':
          'Seller delivers when goods are unloaded at the named destination. Seller bears all risks.',
    },
    {
      'code': 'DDP',
      'title': 'Delivered Duty Paid',
      'desc':
          'Seller bears all costs and risks involved in bringing the goods to the destination, including duties.',
    },
    {
      'code': 'FAS',
      'title': 'Free Alongside Ship',
      'desc':
          'Seller delivers when goods are placed alongside the vessel nominated by the buyer (e.g. on quay).',
    },
    {
      'code': 'FOB',
      'title': 'Free on Board',
      'desc':
          'Seller delivers goods on board the vessel nominated by the buyer.',
    },
    {
      'code': 'CFR',
      'title': 'Cost and Freight',
      'desc':
          'Seller delivers goods on board the vessel. Seller pays for costs and freight to the port of destination.',
    },
    {
      'code': 'CIF',
      'title': 'Cost, Insurance and Freight',
      'desc': 'Same as CFR, but seller also pays for insurance coverage.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsService>().logToolUse(toolName: 'Incoterms');
    });

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('Incoterms 2020'),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _terms.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final term = _terms[index];
          return ExpansionTile(
            collapsedBackgroundColor: cs.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                term['code']!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              term['title']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  term['desc']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

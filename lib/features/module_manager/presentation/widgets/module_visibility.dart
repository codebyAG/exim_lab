import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/module_provider.dart';

class ModuleVisibility extends StatelessWidget {
  final String module;
  final Widget child;
  final Widget? replacement;

  const ModuleVisibility({
    super.key,
    required this.module,
    required this.child,
    this.replacement,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.select<ModuleProvider, bool>(
      (p) => p.isEnabled(module),
    );

    if (isEnabled) return child;
    return replacement ?? const SizedBox.shrink();
  }
}

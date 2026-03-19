import 'package:flutter/material.dart';

enum JourneyStepStatus {
  completed,
  active,
  locked,
}

class JourneyStep {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final JourneyStepStatus status;
  final bool isPremium;
  final List<String>? options; // For initial selection dialogs

  const JourneyStep({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.status = JourneyStepStatus.locked,
    this.isPremium = false,
    this.options,
  });

  JourneyStep copyWith({
    JourneyStepStatus? status,
  }) {
    return JourneyStep(
      id: id,
      title: title,
      description: description,
      icon: icon,
      status: status ?? this.status,
      isPremium: isPremium,
      options: options,
    );
  }
}

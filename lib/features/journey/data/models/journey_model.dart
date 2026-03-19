import 'package:flutter/material.dart';

enum JourneyStepStatus {
  completed,
  active,
  locked,
}

class JourneyQuestion {
  final String id;
  final String text;
  final List<String> options;
  final String? initialValue;

  const JourneyQuestion({
    required this.id,
    required this.text,
    required this.options,
    this.initialValue,
  });
}

class JourneyStep {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final JourneyStepStatus status;
  final bool isPremium;
  final List<JourneyQuestion>? questions;

  const JourneyStep({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.status = JourneyStepStatus.locked,
    this.isPremium = false,
    this.questions,
  });

  JourneyStep copyWith({
    JourneyStepStatus? status,
    List<JourneyQuestion>? questions,
  }) {
    return JourneyStep(
      id: id,
      title: title,
      description: description,
      icon: icon,
      status: status ?? this.status,
      isPremium: isPremium,
      questions: questions ?? this.questions,
    );
  }
}

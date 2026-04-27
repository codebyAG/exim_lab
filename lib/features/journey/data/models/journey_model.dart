import 'package:flutter/material.dart';

enum JourneyStepStatus {
  completed,
  active,
  locked,
}

class JourneyQuestion {
  final int id;
  final String text;
  final List<String> options;
  final int? correctAnswerIndex;

  const JourneyQuestion({
    required this.id,
    required this.text,
    required this.options,
    this.correctAnswerIndex,
  });

  factory JourneyQuestion.fromJson(Map<String, dynamic> json) {
    return JourneyQuestion(
      id: json['id'] ?? 0,
      text: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
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

  factory JourneyStep.fromJson(Map<String, dynamic> json) {
    final stepId = json['stepId'] ?? 0;
    
    // Map icons based on stepId
    IconData stepIcon;
    switch (stepId) {
      case 1: stepIcon = Icons.search_rounded; break;
      case 2: stepIcon = Icons.business_center_rounded; break;
      case 3: stepIcon = Icons.file_copy_rounded; break;
      case 4: stepIcon = Icons.payments_rounded; break;
      case 5: stepIcon = Icons.local_shipping_rounded; break;
      case 6: stepIcon = Icons.gavel_rounded; break;
      case 7: stepIcon = Icons.account_balance_rounded; break;
      case 8: stepIcon = Icons.inventory_2_rounded; break;
      case 9: stepIcon = Icons.verified_user_rounded; break;
      case 10: stepIcon = Icons.trending_up_rounded; break;
      case 11: stepIcon = Icons.celebration_rounded; break;
      default: stepIcon = Icons.directions_walk_rounded;
    }

    return JourneyStep(
      id: stepId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: stepIcon,
      isPremium: json['isPremium'] ?? false,
      questions: (json['questions'] as List?)
          ?.map((q) => JourneyQuestion.fromJson(q))
          .toList(),
    );
  }

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

class JourneyProgress {
  final String journeyType;
  final List<int> completedSteps;
  final int lastActiveStep;

  JourneyProgress({
    required this.journeyType,
    required this.completedSteps,
    required this.lastActiveStep,
  });

  factory JourneyProgress.fromJson(Map<String, dynamic> json) {
    return JourneyProgress(
      journeyType: json['journeyType'] ?? '',
      completedSteps: List<int>.from(json['completedSteps'] ?? []),
      lastActiveStep: json['lastActiveStep'] ?? 1,
    );
  }
}

class ProfileQuestionsData {
  final bool isComplete;
  final int completionPercentage;
  final int configVersion;
  final ProfileQuestionsBannerData banner;
  final List<ProfileQuestionItem> questions;
  final Map<String, ProfileAnswerItem> answers;
  final List<String> answeredKeys;
  final String? nextQuestionKey;
  final int totalRequired;
  final int answeredRequired;

  ProfileQuestionsData({
    required this.isComplete,
    required this.completionPercentage,
    required this.configVersion,
    required this.banner,
    required this.questions,
    required this.answers,
    required this.answeredKeys,
    required this.nextQuestionKey,
    required this.totalRequired,
    required this.answeredRequired,
  });

  factory ProfileQuestionsData.fromJson(Map<String, dynamic> json) {
    final answersJson = (json['answers'] as Map?) ?? {};
    return ProfileQuestionsData(
      isComplete: json['isComplete'] ?? false,
      completionPercentage: json['completionPercentage'] ?? 0,
      configVersion: json['configVersion'] ?? 0,
      banner: ProfileQuestionsBannerData.fromJson(
        Map<String, dynamic>.from(json['banner'] ?? {}),
      ),
      questions: (json['questions'] as List? ?? [])
          .map((q) => ProfileQuestionItem.fromJson(Map<String, dynamic>.from(q)))
          .toList(),
      answers: answersJson.map(
        (key, value) => MapEntry(
          key.toString(),
          ProfileAnswerItem.fromJson(Map<String, dynamic>.from(value)),
        ),
      ),
      answeredKeys: (json['answeredKeys'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      nextQuestionKey: json['nextQuestionKey']?.toString(),
      totalRequired: json['totalRequired'] ?? 0,
      answeredRequired: json['answeredRequired'] ?? 0,
    );
  }

  ProfileQuestionItem? questionByKey(String? key) {
    if (key == null) return null;
    for (final q in questions) {
      if (q.key == key) return q;
    }
    return null;
  }
}

class ProfileQuestionsBannerData {
  final String state;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String ctaLabel;
  final String action;
  final String actionValue;
  final bool isVisible;

  ProfileQuestionsBannerData({
    required this.state,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.ctaLabel,
    required this.action,
    required this.actionValue,
    required this.isVisible,
  });

  factory ProfileQuestionsBannerData.fromJson(Map<String, dynamic> json) {
    return ProfileQuestionsBannerData(
      state: json['state']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      ctaLabel: json['ctaLabel']?.toString() ?? '',
      action: json['action']?.toString() ?? 'none',
      actionValue: json['actionValue']?.toString() ?? '',
      isVisible: json['isVisible'] ?? false,
    );
  }
}

class ProfileQuestionItem {
  final String key;
  final String label;
  final String helperText;
  final String inputType; // text | dropdown | both
  final List<String> options;
  final bool required;
  final int order;
  final int maxLength;

  ProfileQuestionItem({
    required this.key,
    required this.label,
    required this.helperText,
    required this.inputType,
    required this.options,
    required this.required,
    required this.order,
    required this.maxLength,
  });

  factory ProfileQuestionItem.fromJson(Map<String, dynamic> json) {
    return ProfileQuestionItem(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      helperText: json['helperText']?.toString() ?? '',
      inputType: json['inputType']?.toString() ?? 'text',
      options: (json['options'] as List? ?? []).map((e) => e.toString()).toList(),
      required: json['required'] ?? false,
      order: json['order'] ?? 0,
      maxLength: json['maxLength'] ?? 200,
    );
  }
}

class ProfileAnswerItem {
  final String optionValue;
  final String textValue;
  final String value;

  ProfileAnswerItem({
    required this.optionValue,
    required this.textValue,
    required this.value,
  });

  factory ProfileAnswerItem.fromJson(Map<String, dynamic> json) {
    return ProfileAnswerItem(
      optionValue: json['optionValue']?.toString() ?? '',
      textValue: json['textValue']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exim_lab/features/profile_questions/data/models/profile_questions_model.dart';
import 'package:exim_lab/features/profile_questions/presentation/providers/profile_questions_provider.dart';

const _navy = Color(0xFF030E30);
const _gold = Color(0xFFFFD000);

/// Asks [ProfileQuestionsData.questions] one at a time, starting at
/// `nextQuestionKey`, saving each answer as it's given. Dismissible at any
/// point — answers already saved stay saved (per PROFILE_QUESTIONS.md §2).
class ProfileQuestionnaireDialog extends StatefulWidget {
  const ProfileQuestionnaireDialog({super.key});

  @override
  State<ProfileQuestionnaireDialog> createState() =>
      _ProfileQuestionnaireDialogState();
}

class _ProfileQuestionnaireDialogState
    extends State<ProfileQuestionnaireDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedOption;
  String? _currentKey;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentKey = context.read<ProfileQuestionsProvider>().data?.nextQuestionKey;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _resetInputsFor(ProfileQuestionItem question) {
    _textController.clear();
    _selectedOption = null;
    final existing = context
        .read<ProfileQuestionsProvider>()
        .data
        ?.answers[question.key];
    if (existing != null) {
      if (existing.optionValue.isNotEmpty) _selectedOption = existing.optionValue;
      if (existing.textValue.isNotEmpty) _textController.text = existing.textValue;
    }
  }

  Future<void> _submit(ProfileQuestionItem question) async {
    final optionValue = _selectedOption?.trim();
    final textValue = _textController.text.trim();

    if (question.inputType == 'dropdown' &&
        (optionValue == null || optionValue.isEmpty)) {
      setState(() => _error = 'Please choose an option');
      return;
    }
    if (question.inputType == 'text' && textValue.isEmpty) {
      setState(() => _error = 'Please enter a value');
      return;
    }
    if (question.inputType == 'both' &&
        (optionValue == null || optionValue.isEmpty) &&
        textValue.isEmpty) {
      setState(() => _error = 'Please choose an option or type your answer');
      return;
    }

    setState(() => _error = null);

    final provider = context.read<ProfileQuestionsProvider>();
    final err = await provider.submitAnswer(
      questionKey: question.key,
      optionValue: optionValue,
      textValue: textValue.isEmpty ? null : textValue,
    );

    if (!mounted) return;

    if (err != null) {
      setState(() => _error = err);
      return;
    }

    final next = provider.data?.nextQuestionKey;
    if (next == null) {
      Navigator.pop(context);
      return;
    }

    setState(() => _currentKey = next);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileQuestionsProvider>();
    final data = provider.data;
    final question = data?.questionByKey(_currentKey ?? data.nextQuestionKey);

    if (data == null || question == null) {
      // Nothing left to ask.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }

    // Keep local input state in sync when the question changes.
    if (_lastRenderedKey != question.key) {
      _lastRenderedKey = question.key;
      _resetInputsFor(question);
    }

    final progress = data.totalRequired > 0
        ? data.answeredRequired / data.totalRequired
        : 0.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: const AlwaysStoppedAnimation(_gold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (question.helperText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      question.helperText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  if (question.inputType == 'dropdown' ||
                      question.inputType == 'both')
                    _buildOptions(question),

                  if (question.inputType == 'both') const SizedBox(height: 14),

                  if (question.inputType == 'text' ||
                      question.inputType == 'both')
                    _buildTextField(question),

                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isSubmitting ? null : () => _submit(question),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: provider.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  String? _lastRenderedKey;

  Widget _buildOptions(ProfileQuestionItem question) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: question.options.map((opt) {
        final selected = _selectedOption == opt;
        return GestureDetector(
          onTap: () => setState(() => _selectedOption = opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _gold.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? _gold : Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: selected ? _gold : Colors.white.withValues(alpha: 0.85),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(ProfileQuestionItem question) {
    return TextField(
      controller: _textController,
      maxLength: question.maxLength,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: question.inputType == 'both'
            ? 'Or type your own answer'
            : 'Type your answer',
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        counterStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

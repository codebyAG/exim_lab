import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterestCaptureDialog extends StatefulWidget {
  const InterestCaptureDialog({super.key});

  @override
  State<InterestCaptureDialog> createState() => _InterestCaptureDialogState();
}

class _InterestCaptureDialogState extends State<InterestCaptureDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedInterest = "Import";

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill name if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user?.name != null && !user!.name!.contains("User")) {
        _nameController.text = user.name!;
      }
      if (user?.interestedIn != null) {
        setState(() => _selectedInterest = user?.interestedIn);
      }
    });
  }

  Future<void> _submitInterest() async {
    final name = _nameController.text.trim();
    final interest = _selectedInterest?.toLowerCase() ?? "import";

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your name")));
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await context.read<AuthProvider>().updateProfile({
      "name": name,
      "interestedIn": interest,
    });

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } else {
        final error = context.read<AuthProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? "Failed to update profile")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: BoxDecoration(
              color: const Color(0xFF030E30), // Matching Deep Navy
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
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
                children: [
                  // Avatar Section
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text("👦", style: TextStyle(fontSize: 54)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Hello there! 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Can you share a bit about you?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name Input
                  _buildLabel("Your Name"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: cs.primary,
                        size: 22,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interest Selection
                  _buildLabel("Your Interest"),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInterestItem(context, "Import"),
                        Divider(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.05),
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildInterestItem(context, "Export"),
                        Divider(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.05),
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildInterestItem(context, "Both"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Actions
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitInterest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        shadowColor: cs.primary.withValues(alpha: 0.4),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _isSubmitting ? null : () => Navigator.pop(context),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white54,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildInterestItem(BuildContext context, String value) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = _selectedInterest == value;
    return InkWell(
      onTap: () => setState(() => _selectedInterest = value),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? cs.primary
                      : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InterestCaptureDialog extends StatefulWidget {
  const InterestCaptureDialog({super.key});

  @override
  State<InterestCaptureDialog> createState() => _InterestCaptureDialogState();
}

class _InterestCaptureDialogState extends State<InterestCaptureDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedInterest = "Import";

  @override
  void initState() {
    super.initState();
    // Pre-fill name if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user?.name != null && !user!.name!.contains("User")) {
        _nameController.text = user.name!;
      }
      if (user?.interest != null) {
        setState(() => _selectedInterest = user?.interest);
      }
    });
  }

  void _launchWhatsApp() async {
    final name = _nameController.text;
    final interest = _selectedInterest ?? "None";
    final url = "https://wa.me/919871769042?text=I%20am%20$name.%20Interested%20in%20$interest.%20I%20want%20to%20buy%20Import%20Export%20Premium";
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar Section
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECCC),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text("👦", style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Hello there! 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Can you share a bit about you?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Input
                  _buildLabel("Your Name"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFF6862A), size: 22),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Interest Selection
                  _buildLabel("Your Interest"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select your interest",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFFF6862A), size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInterestItem("Import"),
                        Divider(height: 1, color: Colors.grey.shade200, indent: 16, endIndent: 16),
                        _buildInterestItem("Export"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Actions
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6862A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.black45, size: 24),
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
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInterestItem(String value) {
    final isSelected = _selectedInterest == value;
    return InkWell(
      onTap: () => setState(() => _selectedInterest = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (isSelected) 
              const Icon(Icons.check, color: Color(0xFFF6862A), size: 22)
            else
              const SizedBox(width: 22),
            const SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

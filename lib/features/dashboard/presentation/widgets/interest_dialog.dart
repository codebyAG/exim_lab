import 'package:exim_lab/core/functions/whatsapp_utils.dart';
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
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _targetMarketController = TextEditingController();

  String? _selectedCategory = "Startup / Individual";
  String? _selectedRegStatus = "Not Registered";
  String? _selectedRequirement = "Training & Knowledge";

  bool _isSubmitting = false;

  final List<String> _categories = [
    "Manufacturer",
    "Merchant Trader",
    "Startup / Individual",
    "Service Provider",
  ];

  final List<String> _regStatuses = [
    "Not Registered",
    "IEC Registered",
    "IEC & GST Registered",
    "Company Registered",
  ];

  final List<String> _requirements = [
    "Training & Knowledge",
    "Buyer / Seller Data",
    "Logistics & Shipping",
    "Funding & Finance",
    "Full Consultancy",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user?.name != null && !user!.name!.contains("User")) {
        _nameController.text = user.name!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _productController.dispose();
    _targetMarketController.dispose();
    super.dispose();
  }

  Future<void> _submitAndRedirect() async {
    final name = _nameController.text.trim();
    final product = _productController.text.trim();
    final market = _targetMarketController.text.trim();

    if (name.isEmpty || product.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in Name and Product Niche")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // 1. Update Profile (Name only as interest is now more complex)
    await context.read<AuthProvider>().updateProfile({"name": name});

    // 2. Prepare WhatsApp Message
    final message =
        "🚢 *Exim Lab - New Business Inquiry*\n\n"
        "👤 *Name:* $name\n"
        "🏢 *Category:* $_selectedCategory\n"
        "📦 *Product Niche:* $product\n"
        "📜 *Reg Status:* $_selectedRegStatus\n"
        "🌍 *Target Market:* ${market.isEmpty ? 'Not specified' : market}\n"
        "💡 *Main Need:* $_selectedRequirement";

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context);

      // 3. Redirect to WhatsApp
      WhatsAppUtils.launch(message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: BoxDecoration(
              color: const Color(0xFF030E30),
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
                  const Text("🚀", style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  const Text(
                    "Exim Business Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tailor your learning journey with 5 questions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 1. Name
                  _buildTextField(
                    "Your Full Name*",
                    _nameController,
                    Icons.person_outline,
                    "Enter your name",
                  ),
                  const SizedBox(height: 16),

                  // 2. Category
                  _buildLabel("1. Business Category"),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    _selectedCategory,
                    _categories,
                    (v) => setState(() => _selectedCategory = v),
                  ),
                  const SizedBox(height: 16),

                  // 3. Product
                  _buildTextField(
                    "2. Product Niche*",
                    _productController,
                    Icons.inventory_2_outlined,
                    "e.g. Spices, Textiles, Tech",
                  ),
                  const SizedBox(height: 16),

                  // 4. Registration
                  _buildLabel("3. Registration Status"),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    _selectedRegStatus,
                    _regStatuses,
                    (v) => setState(() => _selectedRegStatus = v),
                  ),
                  const SizedBox(height: 16),

                  // 5. Target Market
                  _buildTextField(
                    "4. Target Market",
                    _targetMarketController,
                    Icons.public_outlined,
                    "e.g. USA, Dubai, Europe",
                  ),
                  const SizedBox(height: 16),

                  // 6. Main Requirement
                  _buildLabel("5. What do you need most?"),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    _selectedRequirement,
                    _requirements,
                    (v) => setState(() => _selectedRequirement = v),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitAndRedirect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD000),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Get Export Plan on WhatsApp",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
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
              icon: const Icon(Icons.close, color: Colors.white54),
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
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFFFFD000), size: 18),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF030E30),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFFD000)),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items.map((t) {
            return DropdownMenuItem(value: t, child: Text(t));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

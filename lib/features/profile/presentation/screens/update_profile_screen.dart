import 'package:animate_do/animate_do.dart';
import 'package:exim_lab/features/login/data/models/user_model.dart';
import 'package:exim_lab/features/login/presentations/states/auth_provider.dart';
import 'package:exim_lab/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? user;
  const UpdateProfileScreen({super.key, this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _avatarController = TextEditingController(
      text: widget.user?.avatarUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(t.translate('update_profile_title')),
        centerTitle: true,
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AVATAR SECTION
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.primary, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.20),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: cs.primaryContainer,
                          backgroundImage: _avatarController.text.isNotEmpty
                              ? NetworkImage(_avatarController.text)
                              : null,
                          child: _avatarController.text.isEmpty
                              ? Icon(Icons.person, size: 48, color: cs.primary)
                              : null,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.surface, width: 2),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.5.h),

              // FIELDS
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: _buildField(
                  context: context,
                  controller: _nameController,
                  label: t.translate('full_name'),
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? t.translate('name_required') : null,
                ),
              ),

              SizedBox(height: 2.h),

              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 160),
                child: _buildField(
                  context: context,
                  controller: _emailController,
                  label: t.translate('email_address'),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 2.h),

              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 220),
                child: _buildField(
                  context: context,
                  controller: _avatarController,
                  label: t.translate('avatar_url'),
                  icon: Icons.image_outlined,
                  onChanged: (_) => setState(() {}),
                ),
              ),

              if (authProvider.error != null) ...[
                SizedBox(height: 2.h),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: cs.error, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          authProvider.error!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 4.h),

              // SAVE BUTTON
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final success =
                                  await authProvider.updateProfile({
                                "name": _nameController.text.trim(),
                                "email": _emailController.text.trim(),
                                "avatarUrl": _avatarController.text.trim(),
                              });
                              if (success && mounted) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      t.translate('profile_updated'),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                navigator.pop();
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: cs.onPrimary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            t.translate('save_changes'),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: cs.primary, size: 18),
        ),
        filled: true,
        fillColor: cs.onSurface.withValues(alpha: 0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
        labelStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
      ),
    );
  }
}

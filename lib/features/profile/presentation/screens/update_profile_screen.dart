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
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(t.translate('update_profile_title')),
        centerTitle: true,
        backgroundColor: cs.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── AVATAR CARD ───────────────────────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 450),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Tinted ring
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary.withValues(alpha: 0.08),
                            ),
                          ),
                          // Avatar
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: cs.primaryContainer,
                            backgroundImage: _avatarController.text.isNotEmpty
                                ? NetworkImage(_avatarController.text)
                                : null,
                            child: _avatarController.text.isEmpty
                                ? Icon(Icons.person,
                                    size: 44, color: cs.primary)
                                : null,
                          ),
                          // Camera badge
                          Positioned(
                            right: 2,
                            bottom: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: cs.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: cs.surface, width: 2),
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  size: 13, color: cs.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.2.h),
                      Text(
                        widget.user?.name?.isNotEmpty == true
                            ? widget.user!.name!
                            : t.translate('guest_user'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if ((widget.user?.email ?? widget.user?.mobile ?? '')
                          .isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.user?.email ?? widget.user?.mobile ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // ── FIELDS ───────────────────────────────────────────
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 80),
                child: _buildLabeledField(
                  context: context,
                  label: t.translate('full_name'),
                  controller: _nameController,
                  icon: Icons.person_outline_rounded,
                  iconColor: cs.primary,
                  validator: (v) => (v == null || v.isEmpty)
                      ? t.translate('name_required')
                      : null,
                ),
              ),

              SizedBox(height: 1.8.h),

              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 140),
                child: _buildLabeledField(
                  context: context,
                  label: t.translate('email_address'),
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  iconColor: Colors.blue,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 1.8.h),

              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: _buildLabeledField(
                  context: context,
                  label: t.translate('avatar_url'),
                  controller: _avatarController,
                  icon: Icons.image_outlined,
                  iconColor: Colors.teal,
                  onChanged: (_) => setState(() {}),
                ),
              ),

              // ERROR
              if (authProvider.error != null) ...[
                SizedBox(height: 2.h),
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(12),
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
                ),
              ],

              SizedBox(height: 4.h),

              // ── SAVE BUTTON ───────────────────────────────────────
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 260),
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
                                        t.translate('profile_updated')),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.35)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: iconColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

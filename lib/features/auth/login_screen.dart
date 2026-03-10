import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_input.dart';
import 'package:lms_core_frontend/common/components/app_label.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/common/components/left_branding_section.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/common/constants/validation_patterns.dart';
import 'package:provider/provider.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return LoginForm(
            isLoading: auth.isLoading,
            error: auth.error,
            onLogin: (email, password) async {
              final success = await auth.login(
                email: email,
                password: password,
              );
              if (success && context.mounted) {
                AppToast.success(
                  context,
                  title: 'Welcome back!',
                  description: 'You have successfully signed in.',
                );
                context.goNamed(ViewIdentifiers.home.name);
              }
            },
          );
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  final String? error;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onLogin,
    this.error,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String _emailError = '';
  String _passwordError = '';

  @override
  void didUpdateWidget(LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != null &&
        widget.error!.isNotEmpty &&
        widget.error != oldWidget.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppToast.error(
            context,
            title: 'Sign in failed',
            description: widget.error,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setEmailError(String msg) => setState(() => _emailError = msg);
  void _setPasswordError(String msg) => setState(() => _passwordError = msg);

  bool validateEmail(String email) {
    if (email.isEmpty) {
      _setEmailError('Email is required');
      return false;
    }
    if (!ValidationPatterns.emailRegex.hasMatch(email)) {
      _setEmailError('Please enter a valid email address');
      return false;
    }
    _setEmailError('');
    return true;
  }

  bool validatePassword(String password) {
    if (password.isEmpty) {
      _setPasswordError('Password is required');
      return false;
    }
    if (password.length < ValidationPatterns.minPasswordLength) {
      _setPasswordError('Password must be at least ${ValidationPatterns.minPasswordLength} characters');
      return false;
    }
    _setPasswordError('');
    return true;
  }

  void handleSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isEmailValid = validateEmail(email);
    final isPasswordValid = validatePassword(password);

    if (isEmailValid && isPasswordValid) {
      widget.onLogin(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.background1, Colors.white, AppColors.background2],
        ),
      ),
      child: Row(
        children: [
          if (isDesktop) const LeftBrandingSection(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48 : 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isDesktop) const _MobileLogo(),
                      _buildLoginCard(),
                      const SizedBox(height: 24),
                      const Text(
                        '© 2026 EduPortal. Designed for Nigerian Secondary Schools',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLoginCard() {
    return AppCard(
      children: [
        AppCardHeader(
          title: const AppCardTitle(text: 'Welcome back'),
          description: const AppCardDescription(
            text: 'Sign in to your teacher account to continue',
          ),
        ),
        AppCardContent(
          isLast: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmailField(),
              const SizedBox(height: 18),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildSignInButton(),
              const SizedBox(height: 24),
              const _OrDivider(),
              const SizedBox(height: 24),
              _buildDemoButton(),
              const SizedBox(height: 24),
              const _InfoBox(),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel(text: 'Email Address', disabled: widget.isLoading),
        const SizedBox(height: 8),
        AppInput(
          controller: _emailController,
          hintText: 'teacher@school.edu.ng',
          errorText: _emailError.isEmpty ? null : _emailError,
          enabled: !widget.isLoading,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) { if (_emailError.isNotEmpty) validateEmail(v); },
          onEditingComplete: () => validateEmail(_emailController.text.trim()),
        ),
        const SizedBox(height: 6),
        const Text(
          'Use your school email address (.edu.ng)',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppLabel(text: 'Password', disabled: widget.isLoading),
            const Spacer(),
            TextButton(
              onPressed: widget.isLoading ? null : _showForgotPasswordSnackBar,
              child: const Text(
                'Forgot password?',
                style: TextStyle(fontSize: 12, color: AppColors.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppInput(
          controller: _passwordController,
          hintText: 'Enter your password',
          errorText: _passwordError.isEmpty ? null : _passwordError,
          enabled: !widget.isLoading,
          obscureText: !_showPassword,
          onChanged: (v) { if (_passwordError.isNotEmpty) validatePassword(v); },
          onEditingComplete: () => validatePassword(_passwordController.text),
          suffixIcon: IconButton(
            onPressed: widget.isLoading
                ? null
                : () => setState(() => _showPassword = !_showPassword),
            icon: Icon(
              _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  void _showForgotPasswordSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please contact your school administrator to reset your password.',
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: handleSubmit,
        variant: ButtonVariant.primary,
        size: ButtonSize.lg,
        isLoading: widget.isLoading,
        child: const Text('Sign In'),
      ),
    );
  }

  Widget _buildDemoButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: () => context.goNamed(ViewIdentifiers.registry.name),
        variant: ButtonVariant.outline,
        size: ButtonSize.lg,
        isLoading: widget.isLoading,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.userPlus, size: 18),
            SizedBox(width: 8),
            Text('Sign up'),
          ],
        ),
      ),
    );
  }
}

// ── Приватні stateless-підвіджети ─────────────────────────────────────────────

class _MobileLogo extends StatelessWidget {
  const _MobileLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EduPortal',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Teacher Portal',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
          children: [
            TextSpan(
              text: 'For Teachers: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextSpan(
              text: 'Use your school-issued email to sign in. '
                  'Contact your administrator if you need assistance.',
            ),
          ],
        ),
      ),
    );
  }
}

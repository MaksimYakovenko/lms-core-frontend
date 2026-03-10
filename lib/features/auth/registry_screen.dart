import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/components/app_card.dart';
import 'package:lms_core_frontend/common/components/app_input.dart';
import 'package:lms_core_frontend/common/components/app_label.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/components/left_branding_section.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/auth/auth_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class RegistryScreen extends StatefulWidget {
  const RegistryScreen({super.key});

  @override
  State<RegistryScreen> createState() => _RegistryScreenState();
}

class _RegistryScreenState extends State<RegistryScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  bool _showPassword = false;
  DateTime? _birthday;

  String? _captchaId;
  String? _captchaImage;
  bool _isLoadingCaptcha = false;

  String _emailError = '';
  String _firstNameError = '';
  String _lastNameError = '';
  String _passwordError = '';
  String _birthdayError = '';
  String _captchaError = '';

  @override
  void initState() {
    super.initState();
    _loadCaptcha();
  }

  Future<void> _loadCaptcha() async {
    setState(() => _isLoadingCaptcha = true);
    try {
      final captcha = await _authService.getCaptcha();
      setState(() {
        _captchaId = captcha.captchaId;
        _captchaImage = captcha.image;
        _isLoadingCaptcha = false;
      });
    } catch (e) {
      setState(() => _isLoadingCaptcha = false);
      if (mounted) {
        AppToast.error(
          context,
          title: 'Failed to load captcha',
          description: e.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (value.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return false;
    }
    if (!emailRegex.hasMatch(value)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return false;
    }
    setState(() => _emailError = '');
    return true;
  }

  bool _validateFirstName(String value) {
    if (value.trim().isEmpty) {
      setState(() => _firstNameError = 'First name is required');
      return false;
    }
    setState(() => _firstNameError = '');
    return true;
  }

  bool _validateLastName(String value) {
    if (value.trim().isEmpty) {
      setState(() => _lastNameError = 'Last name is required');
      return false;
    }
    setState(() => _lastNameError = '');
    return true;
  }

  bool _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return false;
    }
    if (value.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      return false;
    }
    setState(() => _passwordError = '');
    return true;
  }

  bool _validateBirthday() {
    if (_birthday == null) {
      setState(() => _birthdayError = 'Birthday is required');
      return false;
    }
    setState(() => _birthdayError = '');
    return true;
  }

  bool _validateCaptcha(String value) {
    if (value.trim().isEmpty) {
      setState(() => _captchaError = 'Captcha is required');
      return false;
    }
    setState(() => _captchaError = '');
    return true;
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final initial = _birthday ?? DateTime(now.year - 18, now.month, now.day);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        DateTime? selected = initial;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'Select Birthday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: const Color(0xFF16A34A),
                      weekdayLabelTextStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      controlsTextStyle: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      dayTextStyle: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 14,
                      ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      firstDate: DateTime(1900),
                      lastDate: now,
                    ),
                    value: [selected],
                    onValueChanged: (dates) {
                      if (dates.isNotEmpty) {
                        setModalState(() => selected = dates.first);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (selected != null) {
                          setState(() {
                            _birthday = selected;
                            _birthdayError = '';
                          });
                        }
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String get _birthdayDisplayText {
    if (_birthday == null) return '';
    final d = _birthday!;
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  Future<void> _handleSubmit() async {
    final isEmailValid = _validateEmail(_emailController.text.trim());
    final isFirstNameValid = _validateFirstName(_firstNameController.text);
    final isLastNameValid = _validateLastName(_lastNameController.text);
    final isPasswordValid = _validatePassword(_passwordController.text);
    final isBirthdayValid = _validateBirthday();
    final isCaptchaValid = _validateCaptcha(_captchaController.text);

    if (isEmailValid && isFirstNameValid && isLastNameValid && isPasswordValid && isBirthdayValid && isCaptchaValid) {
      if (_captchaId == null) {
        AppToast.error(
          context,
          title: 'Captcha not loaded',
          description: 'Please refresh the captcha and try again.',
        );
        return;
      }

      final birthdayFormatted = '${_birthday!.year}-${_birthday!.month.toString().padLeft(2, '0')}-${_birthday!.day.toString().padLeft(2, '0')}';

      try {
        await _authService.signUp(
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          password: _passwordController.text,
          birthday: birthdayFormatted,
          captchaId: _captchaId!,
          captchaAnswer: _captchaController.text.trim(),
        );

        if (mounted) {
          AppToast.success(
            context,
            title: 'Registration successful!',
            description: 'Please sign in to continue.',
          );
          context.goNamed(ViewIdentifiers.login.name);
        }
      } catch (e) {
        if (mounted) {
          AppToast.error(
            context,
            title: 'Registration failed',
            description: e.toString().replaceFirst('Exception: ', ''),
          );
          // Перезавантажити капчу після невдалої спроби
          _loadCaptcha();
          _captchaController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEFF6FF),
              Colors.white,
              Color(0xFFF0FDF4),
            ],
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
                        _buildRegisterCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterCard() {
    return AppCard(
      children: [
        AppCardHeader(
          title: const AppCardTitle(text: 'Create account'),
          description: const AppCardDescription(
            text: 'Sign up to get started with EduPortal',
          ),
        ),
        AppCardContent(
          isLast: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmailField(),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildFirstNameField()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildLastNameField()),
                ],
              ),
              const SizedBox(height: 18),
              _buildPasswordField(),
              const SizedBox(height: 18),
              _buildBirthdayField(),
              const SizedBox(height: 18),
              _buildCaptchaField(),
              const SizedBox(height: 24),
              _buildSignUpButton(),
              const SizedBox(height: 24),
              _buildSignInRow(),
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
        const AppLabel(text: 'Email Address'),
        const SizedBox(height: 8),
        AppInput(
          controller: _emailController,
          hintText: 'teacher@school.edu.ng',
          errorText: _emailError.isEmpty ? null : _emailError,
          keyboardType: TextInputType.emailAddress,
          onChanged: (v) {
            if (_emailError.isNotEmpty) _validateEmail(v);
          },
          onEditingComplete: () => _validateEmail(_emailController.text.trim()),
        ),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(text: 'First Name'),
        const SizedBox(height: 8),
        AppInput(
          controller: _firstNameController,
          hintText: 'John',
          errorText: _firstNameError.isEmpty ? null : _firstNameError,
          onChanged: (v) {
            if (_firstNameError.isNotEmpty) _validateFirstName(v);
          },
          onEditingComplete: () => _validateFirstName(_firstNameController.text),
        ),
      ],
    );
  }

  Widget _buildLastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(text: 'Last Name'),
        const SizedBox(height: 8),
        AppInput(
          controller: _lastNameController,
          hintText: 'Adebayo',
          errorText: _lastNameError.isEmpty ? null : _lastNameError,
          onChanged: (v) {
            if (_lastNameError.isNotEmpty) _validateLastName(v);
          },
          onEditingComplete: () => _validateLastName(_lastNameController.text),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(text: 'Password'),
        const SizedBox(height: 8),
        AppInput(
          controller: _passwordController,
          hintText: 'Enter your password',
          errorText: _passwordError.isEmpty ? null : _passwordError,
          obscureText: !_showPassword,
          onChanged: (v) {
            if (_passwordError.isNotEmpty) _validatePassword(v);
          },
          onEditingComplete: () => _validatePassword(_passwordController.text),
          suffixIcon: IconButton(
            onPressed: () => setState(() => _showPassword = !_showPassword),
            icon: Icon(
              _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthdayField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(text: 'Birthday'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickBirthday,
          child: AbsorbPointer(
            child: AppInput(
              hintText: 'DD.MM.YYYY',
              controller: TextEditingController(text: _birthdayDisplayText),
              errorText: _birthdayError.isEmpty ? null : _birthdayError,
              suffixIcon: const Icon(
                LucideIcons.calendarDays,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptchaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLabel(text: 'Captcha'),
        const SizedBox(height: 8),
        if (_captchaImage != null) ...[
          Row(
            children: [
              _isLoadingCaptcha
                  ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Color(0xFF16A34A),
                      strokeWidth: 2,
                    ),
                  )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        base64Decode(_captchaImage!),
                        height: 75,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Failed to load captcha image',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _isLoadingCaptcha ? null : _loadCaptcha,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  side: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: const Color(0xFF111827),
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(
                  LucideIcons.refreshCw,
                  size: 24,
                ),
                label: const Text(
                  'Refresh',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        AppInput(
          controller: _captchaController,
          hintText: 'Enter captcha text',
          errorText: _captchaError.isEmpty ? null : _captchaError,
          onChanged: (v) {
            if (_captchaError.isNotEmpty) _validateCaptcha(v);
          },
          onEditingComplete: () => _validateCaptcha(_captchaController.text),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: _handleSubmit,
        variant: ButtonVariant.primary,
        size: ButtonSize.lg,
        child: const Text('Sign Up'),
      ),
    );
  }

  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        TextButton(
          onPressed: () => context.goNamed(ViewIdentifiers.login.name),
          child: const Text(
            'Sign In',
            style: TextStyle(fontSize: 13, color: Color(0xFF16A34A)),
          ),
        ),
      ],
    );
  }
}


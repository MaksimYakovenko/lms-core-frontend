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
import 'package:lms_core_frontend/common/constants/colors.dart';
import 'package:lms_core_frontend/common/constants/validation_patterns.dart';
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
          title: 'Помилка завантаження капчі',
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

  void _setError(void Function(String) setter, String msg) =>
      setState(() => setter(msg));

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      _setError((v) => _emailError = v, 'Email є обов\'язковим');
      return false;
    }
    if (!ValidationPatterns.emailRegex.hasMatch(value)) {
      _setError((v) => _emailError = v, 'Введіть коректну email-адресу');
      return false;
    }
    _setError((v) => _emailError = v, '');
    return true;
  }

  bool _validateFirstName(String value) {
    if (value.trim().isEmpty) {
      _setError((v) => _firstNameError = v, 'Ім\'я є обов\'язковим');
      return false;
    }
    _setError((v) => _firstNameError = v, '');
    return true;
  }

  bool _validateLastName(String value) {
    if (value.trim().isEmpty) {
      _setError((v) => _lastNameError = v, 'Прізвище є обов\'язковим');
      return false;
    }
    _setError((v) => _lastNameError = v, '');
    return true;
  }

  bool _validatePassword(String value) {
    if (value.isEmpty) {
      _setError((v) => _passwordError = v, 'Пароль є обов\'язковим');
      return false;
    }
    if (value.length < ValidationPatterns.minPasswordLength) {
      _setError((v) => _passwordError = v,
          'Пароль має містити щонайменше ${ValidationPatterns.minPasswordLength} символів');
      return false;
    }
    _setError((v) => _passwordError = v, '');
    return true;
  }

  bool _validateBirthday() {
    if (_birthday == null) {
      _setError((v) => _birthdayError = v, 'Дата народження є обов\'язковою');
      return false;
    }
    _setError((v) => _birthdayError = v, '');
    return true;
  }

  bool _validateCaptcha(String value) {
    if (value.trim().isEmpty) {
      _setError((v) => _captchaError = v, 'Captcha є обов\'язковою');
      return false;
    }
    _setError((v) => _captchaError = v, '');
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
                    ),                  ),
                  const Text(
                    'Оберіть дату народження',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: AppColors.accent,
                      weekdayLabelTextStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      controlsTextStyle: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      dayTextStyle: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      todayTextStyle: const TextStyle(
                        color: AppColors.accent,
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
                      onPressed: () {
                        if (selected != null) {
                          setState(() {
                            _birthday = selected;
                            _birthdayError = '';
                          });
                        }
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Підтвердити',
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
    return _formatDate(_birthday!, separator: '.');
  }

  static String _formatDate(DateTime d, {String separator = '-'}) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return separator == '.'
        ? '$day$separator$m$separator$y'
        : '$y$separator$m$separator$day';
  }

  Future<void> _handleSubmit() async {
    final allValid = [
      _validateEmail(_emailController.text.trim()),
      _validateFirstName(_firstNameController.text),
      _validateLastName(_lastNameController.text),
      _validatePassword(_passwordController.text),
      _validateBirthday(),
      _validateCaptcha(_captchaController.text),
    ].every((v) => v);

    if (!allValid) return;

    if (_captchaId == null) {
      AppToast.error(
        context,
        title: 'Капча не завантажена',
        description: 'Будь ласка, оновіть капчу та спробуйте ще раз.',
      );
      return;
    }

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text,
        birthday: _formatDate(_birthday!),
        captchaId: _captchaId!,
        captchaAnswer: _captchaController.text.trim(),
      );

      if (mounted) {
        AppToast.success(
          context,
          title: 'Реєстрація успішна!',
          description: 'Будь ласка, увійдіть у систему, щоб продовжити.',
        );
        context.goNamed(ViewIdentifiers.login.name);
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Помилка реєстрації',
          description: e.toString().replaceFirst('Exception: ', ''),
        );
        _loadCaptcha();
        _captchaController.clear();
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
          title: const AppCardTitle(text: 'Створити акаунт'),
          description: const AppCardDescription(
            text: 'Зареєструйтесь, щоб почати роботу з EduPortal',
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
        const AppLabel(text: 'Електронна пошта'),
        const SizedBox(height: 8),
        AppInput(
          controller: _emailController,
          hintText: 'user@knu.ua',
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
        const AppLabel(text: 'Ім\'я'),
        const SizedBox(height: 8),
        AppInput(
          controller: _firstNameController,
          hintText: 'Іван',
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
        const AppLabel(text: 'Прізвище'),
        const SizedBox(height: 8),
        AppInput(
          controller: _lastNameController,
          hintText: 'Петренко',
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
        const AppLabel(text: 'Пароль'),
        const SizedBox(height: 8),
        AppInput(
          controller: _passwordController,
          hintText: 'Введіть ваш пароль',
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
              color: AppColors.textSecondary,
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
        const AppLabel(text: 'Дата народження'),
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
                color: AppColors.textSecondary,
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
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
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
                              'Не вдалося завантажити зображення капчі',
                              style: TextStyle(
                                color: AppColors.textSecondary,
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
                  foregroundColor: AppColors.textPrimary,
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(
                  LucideIcons.refreshCw,
                  size: 24,
                ),
                label: const Text(
                  'Оновити',
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
          hintText: 'Введіть текст капчі',
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
        child: const Text('Зареєструватись'),
      ),
    );
  }

  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Вже маєте акаунт?',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () => context.goNamed(ViewIdentifiers.login.name),
          child: const Text(
            'Увійти',
            style: TextStyle(fontSize: 13, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}


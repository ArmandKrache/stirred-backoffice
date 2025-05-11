import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/core/extensions/widget_ref.dart';
import 'package:stirred_backoffice/presentation/providers/current_data.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_button.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final result = await ref.read(currentDataNotifierProvider.notifier).login(
            username: _usernameController.text,
            password: _passwordController.text,
          );

      result.when(
        success: (_) {
          // Navigation redirection is handled by the notifier
        },
        failure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message ?? 'An error occurred'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.colors;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(StirSpacings.medium24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StirText.headlineMedium(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: StirSpacings.small8),
                  StirText.bodyLarge(
                    'Sign in to continue',
                    color: colors.onSurfaceVariantLowEmphasis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: StirSpacings.medium32),
                  StirTextField(
                    controller: _usernameController,
                    hint: 'Username',
                    leadingIconData: Icons.person_outline,
                    isRequired: true,
                  ),
                  const SizedBox(height: StirSpacings.small16),
                  StirTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    leadingIconData: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    trailingIconData: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    onTrailingIconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: StirSpacings.small8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const StirText.labelLarge('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: StirSpacings.medium24),
                  StirButton.primary(
                    label: 'Sign In',
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: StirSpacings.small16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_management/core/extensions/build_context_extension.dart';
import '../../../config/localization/language_provider.dart';
import '../../../config/themes/theme_provider.dart';
import '../models/auth_state.dart';
import '../validators/auth_validator.dart';
import '../viewmodels/auth_view_model.dart';
import '../../../core/commom/components/components_export.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(authViewModelProvider.notifier);
      await viewModel.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final loginForm = ref.watch(loginFormProvider);
    final isLoading = authState is AuthLoading;

    // Listen to auth state changes
    ref.listen(authViewModelProvider, (previous, next) {
      if (next is AuthSuccess) {
        context.showSuccessSnackBar('Welcome ${next.email}');
        // Navigate to home
        // context.goToHome();
      } else if (next is AuthError) {
        context.showErrorSnackBar(next.message);
      }
    });

    return AppScaffold(
      actions: [
        AppIconButton(
          icon: Icons.dark_mode,
          onPressed: () {
            final currentTheme = ref.read(themeProvider);
            ref.read(themeProvider.notifier).switchMode(!currentTheme);
          },
        ),
        AppIconButton(
          icon: Icons.language,
          onPressed: () {
            final currentLocale = ref.read(languageProvider);
            final newLocale = currentLocale.languageCode == 'en'
                ? const Locale('ne')
                : const Locale('en');
            ref
                .read(languageProvider.notifier)
                .changeLanguage(newLocale.languageCode);
          },
        ),
      ],
      title: Text(context.l10n.login),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                label: context.l10n.email,
                hintText: 'user@example.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email),
                validator: AuthValidator.validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(context, loginForm, isLoading),
              const SizedBox(height: 24),
              PrimaryButton(
                label: context.l10n.login,
                loading: isLoading,
                width: double.infinity,
                onPressed: isLoading ? null : _handleLogin,
              ),
              const SizedBox(height: 24),
              _buildSignUpLink(context, isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/logo.png', width: 40, height: 40),
            ),
            // Icon(
            //   Icons.event,
            //   size: 40,
            //   color: context.colorScheme.primary,
            // ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.welcomeMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    LoginState loginForm,
    bool isLoading,
  ) {
    return CustomTextField(
      controller: _passwordController,
      label: context.l10n.password,
      obscureText: !loginForm.showPassword,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          loginForm.showPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: isLoading
            ? null
            : () {
                ref
                    .read(loginFormProvider.notifier)
                    .update(
                      (state) =>
                          state.copyWith(showPassword: !loginForm.showPassword),
                    );
              },
      ),
      validator: AuthValidator.validatePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildSignUpLink(BuildContext context, bool isLoading) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.dontHaveAccount),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: isLoading ? null : () => context.goToSignup(),
            child: Text(
              context.l10n.signUp,
              style: TextStyle(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

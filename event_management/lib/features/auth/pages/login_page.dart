import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_management/core/extensions/build_context_extension.dart';
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
      title: Text(context.l10n.login),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildEmailField(context),
              const SizedBox(height: 16),
              _buildPasswordField(context, loginForm, isLoading),
              const SizedBox(height: 24),
              _buildSignInButton(context, isLoading),
              const SizedBox(height: 20),
              _buildDivider(context),
              const SizedBox(height: 20),
              _buildSocialButtons(context, isLoading),
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
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.event,
              size: 40,
              color: context.colorScheme.primary,
            ),
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

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      controller: _emailController,
      label: context.l10n.email,
      hintText: 'user@example.com',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email),
      validator: AuthValidator.validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

  Widget _buildSignInButton(BuildContext context, bool isLoading) {
    return PrimaryButton(
      label: context.l10n.login,
      loading: isLoading,
      width: double.infinity,
      onPressed: isLoading ? null : _handleLogin,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.orContinueWith,
            style: context.textTheme.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context, bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialButton(
          icon: Icons.g_mobiledata,
          label: 'Google',
          onPressed: isLoading
              ? null
              : () => context.showSnackBar('Google login coming soon'),
        ),
        _SocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          onPressed: isLoading
              ? null
              : () => context.showSnackBar('Facebook login coming soon'),
        ),
        _SocialButton(
          icon: Icons.apple,
          label: 'Apple',
          onPressed: isLoading
              ? null
              : () => context.showSnackBar('Apple login coming soon'),
        ),
      ],
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

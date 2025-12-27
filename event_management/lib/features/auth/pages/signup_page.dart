import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_management/core/extensions/build_context_extension.dart';
import '../../../core/commom/components/components_export.dart';
import '../models/auth_state.dart';
import '../validators/auth_validator.dart';
import '../viewmodels/auth_view_model.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(authViewModelProvider.notifier);
      await viewModel.signUp(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final signupForm = ref.watch(signupFormProvider);
    final isLoading = authState is AuthLoading;

    // Listen to auth state changes
    ref.listen(authViewModelProvider, (previous, next) {
      if (next is AuthSuccess) {
        context.showSuccessSnackBar('Account created! Welcome ${next.email}');
        // Navigate to home or login
        // context.goToHome();
      } else if (next is AuthError) {
        context.showErrorSnackBar(next.message);
      }
    });

    return AppScaffold(
      title: Text(context.l10n.signUp),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildNameField(context),
              const SizedBox(height: 16),
              _buildEmailField(context),
              const SizedBox(height: 16),
              _buildPasswordField(context, signupForm, isLoading),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(context, signupForm, isLoading),
              const SizedBox(height: 28),
              _buildSignUpButton(context, isLoading),
              const SizedBox(height: 20),
              _buildDivider(context),
              const SizedBox(height: 20),
              _buildSocialButtons(context, isLoading),
              const SizedBox(height: 24),
              _buildLoginLink(context, isLoading),
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
              Icons.person_add,
              size: 40,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Create Your Account',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Join us and manage your events easily',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return CustomTextField(
      controller: _nameController,
      label: context.l10n.fullName,
      hintText: 'John Doe',
      keyboardType: TextInputType.name,
      prefixIcon: const Icon(Icons.person),
      validator: AuthValidator.validateFullName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
    SignupState signupForm,
    bool isLoading,
  ) {
    return CustomTextField(
      controller: _passwordController,
      label: context.l10n.password,
      obscureText: !signupForm.showPassword,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          signupForm.showPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: isLoading
            ? null
            : () {
                ref
                    .read(signupFormProvider.notifier)
                    .update(
                      (state) => state.copyWith(
                        showPassword: !signupForm.showPassword,
                      ),
                    );
              },
      ),
      validator: AuthValidator.validatePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildConfirmPasswordField(
    BuildContext context,
    SignupState signupForm,
    bool isLoading,
  ) {
    return CustomTextField(
      controller: _confirmPasswordController,
      label: context.l10n.confirmPassword,
      obscureText: !signupForm.showConfirmPassword,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(
          signupForm.showConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: isLoading
            ? null
            : () {
                ref
                    .read(signupFormProvider.notifier)
                    .update(
                      (state) => state.copyWith(
                        showConfirmPassword: !signupForm.showConfirmPassword,
                      ),
                    );
              },
      ),
      validator: (value) => AuthValidator.validateConfirmPassword(
        value,
        _passwordController.text,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildSignUpButton(BuildContext context, bool isLoading) {
    return PrimaryButton(
      label: context.l10n.signUp,
      loading: isLoading,
      width: double.infinity,
      onPressed: isLoading ? null : _handleSignup,
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
              : () => context.showSnackBar('Google signup coming soon'),
        ),
        _SocialButton(
          icon: Icons.facebook,
          label: 'Facebook',
          onPressed: isLoading
              ? null
              : () => context.showSnackBar('Facebook signup coming soon'),
        ),
        _SocialButton(
          icon: Icons.apple,
          label: 'Apple',
          onPressed: isLoading
              ? null
              : () => context.showSnackBar('Apple signup coming soon'),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context, bool isLoading) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.alreadyHaveAccount),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: isLoading ? null : () => context.pop(),
            child: Text(
              context.l10n.login,
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

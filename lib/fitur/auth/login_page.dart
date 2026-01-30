import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input.dart';
import '../../core/routes/app_routes.dart';
import 'auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),

              Center(
                child: Image.asset(
                  'assets/images/logo tulis merah.png',
                  width: 380,
                ),
              ),

              const SizedBox(height: 30),

              Text('Login to your account', style: AppTextStyle.bodyMedium),

              const SizedBox(height: 14),

              // USERNAME
              CustomInput(
                hint: 'Username',
                controller: controller.emailController,
                prefixIcon: const Icon(Icons.person_outline),
              ),

              const SizedBox(height: 10),

              // PASSWORD
              Obx(
                () => CustomInput(
                  hint: 'Password',
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // SIGN IN
              Obx(
                () => CustomButton(
                  text: 'Sign in',
                  onPressed: controller.signIn,
                  isLoading: controller.isLoading.value,
                ),
              ),

              const SizedBox(height: 25),

              // SIGN UP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyle.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearFields();
                      Get.toNamed(AppRoutes.register);
                    },
                    child: Text(
                      'Sign up',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  '- Or sign in with -',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              const SizedBox(height: 15),

              // GOOGLE BUTTON
              Obx(
                () => OutlinedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google.png', width: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Google',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

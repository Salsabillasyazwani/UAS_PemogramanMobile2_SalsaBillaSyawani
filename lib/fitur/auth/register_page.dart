import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_input.dart';
import 'auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
            children: [
              const SizedBox(height: 45),

              Image.asset('assets/images/logo tulis merah.png', width: 380),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create your account',
                  style: AppTextStyle.bodyMedium,
                ),
              ),

              const SizedBox(height: 14),

              CustomInput(
                hint: 'Name',
                controller: controller.nameController,
                prefixIcon: const Icon(Icons.person_outline),
              ),

              const SizedBox(height: 8),

              CustomInput(
                hint: 'Username',
                controller: controller.usernameController,
                prefixIcon: const Icon(Icons.alternate_email),
              ),

              const SizedBox(height: 8),

              CustomInput(
                hint: 'Email Address',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),

              const SizedBox(height: 8),

              // --- INPUT NOMOR HP BARU ---
              CustomInput(
                hint: 'Phone Number',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_android_outlined),
              ),
              const SizedBox(height: 8),

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

              const SizedBox(height: 8),

              CustomInput(
                hint: 'Confirm password',
                controller: controller.confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
              ),

              const SizedBox(height: 8),

              Obx(
                () => CustomButton(
                  text: 'Sign up',
                  onPressed: controller.signUp,
                  isLoading: controller.isLoading.value,
                ),
              ),

              const SizedBox(height: 17),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyle.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.clearFields();
                      Get.back();
                    },
                    child: Text(
                      'Sign in',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text('- Or sign up with -', style: AppTextStyle.bodySmall),

              const SizedBox(height: 8),
              Obx(
                () => OutlinedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google.png', width: 13),
                      const SizedBox(width: 5),
                      const Text('Google'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

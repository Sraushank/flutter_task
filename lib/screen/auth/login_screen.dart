import 'package:flutter/material.dart';
import 'package:flutter_task/screen/utils/extensions/app_extensions.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../widget/button/custom_button.dart';
import '../widget/textfielde/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    AuthController loginController = Get.put(AuthController());
    final formKey = GlobalKey<FormState>();

    var isPasswordVisible = false.obs;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(context.screenWidth / 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                hintText: 'Email',
                controller: emailController,
                icon: Icons.alternate_email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
              ),
              const SizedBox(height: 16.0),
              Obx(() => CustomTextField(
                hintText: 'Password',
                controller: passwordController,
                icon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: !isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                ),
              )),
              const SizedBox(height: 16.0),
              Obx(() => CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    loginController.loginEmail(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  }
                },
                text: 'Submit',
                loading: loginController.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../screen/home/home_screen.dart';
import '../../screen/utils/colors/app_colors.dart';
import '../store/sherar_prefrence.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  SharedPreferenceService shearprefrence = SharedPreferenceService();
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final url = Uri.parse('https://reqres.in/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        print("Login successful: ${responseData['token']}");
        shearprefrence.writeData(responseData['token']);
        Get.showSnackbar(GetSnackBar(
          title: "Login",
          message: "Login Success",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColor.lightPrimaryColor,
          borderRadius: 10,
          snackPosition: SnackPosition.TOP,
        ));
        Get.offAll(HomeScreen());
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Login Error",
          message: "Check Email and Password",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColor.lightPrimaryColor,
          borderRadius: 10,
          snackPosition: SnackPosition.TOP,
        ));
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Login Error",
        message: "An error occurred. Please try again.",
        duration: const Duration(seconds: 3),
        backgroundColor: AppColor.lightPrimaryColor,
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
      ));
    } finally {
      isLoading.value = false;
    }
  }
}

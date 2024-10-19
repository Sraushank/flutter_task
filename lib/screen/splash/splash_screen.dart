import 'package:flutter/material.dart';
import 'package:flutter_task/screen/auth/login_screen.dart';
import 'package:flutter_task/screen/home/home_screen.dart';
import '../../controllers/store/sherar_prefrence.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SharedPreferenceService sharedPreferenceService = SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    navigateBasedOnToken();
  }

  Future<void> navigateBasedOnToken() async {
    String? token = await sharedPreferenceService.readData();
    await Future.delayed(const Duration(seconds: 3));

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: CircleAvatar(
          backgroundColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Text("Hacker",style:TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold) ,),
              ),
              Container(
                margin: EdgeInsets.only(left: 40),
                child: Text("Kernel",style:TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold) ,),
              )
            ],
          ),
          radius: 80,
        ),
      ),
    );
  }
}

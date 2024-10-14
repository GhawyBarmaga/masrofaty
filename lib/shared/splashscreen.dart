import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../register/login_screen.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({super.key});

  @override
  State<SplasScreen> createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAll(() => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height*0.8,
        child: Column(
          children: [
            Image.asset(
              'assets/images/masrofy.png',
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

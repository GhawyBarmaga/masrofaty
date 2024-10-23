// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';






import '../shared/components.dart';

import '../shared/foregetpass.dart';
import '../views/masrofy/masrofy_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ischecked = false;
  final localstorage = GetStorage();
  bool issecure = true;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController password = TextEditingController();

//=========================================================================

  @override
  void initState() {
    email.text = localstorage.read("email") ?? "";
    password.text = localstorage.read("password") ?? "";
   
    isloading = false;
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //==================================login user================
    Future<void> loginUser({
      required String email,
      required String password,
    }) async {
      try {
        if (email.isNotEmpty || password.isNotEmpty) {
          
          if (ischecked == true) {
            localstorage.write("email", email.trim());
            localstorage.write("password", password.trim());
          }
          isloading = true;
          setState(() {});
          // logging in user with email and password
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          //     .then((userCredential) {
          //   _auth.currentUser?.reload();
          //   log("userCredential ${userCredential.user?.uid}");
          // }).catchError((e) {
          //   log(e.toString());
          // });

          Get.offAll(() => const MasrofyScreen());
          setState(() {});
          isloading = false;
        } else {
          Get.snackbar("😊", "حاول مره اخرى",
              backgroundColor: Colors.black26, colorText: Colors.red);
          setState(() {});
          isloading = false;
        }
      } catch (err) {
        Get.snackbar("😒", err.toString(),
            backgroundColor: Colors.white, colorText: Colors.red);
        setState(() {});
        isloading = false;
      }
    }

    return SafeArea(
        child: AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
          body: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/login.png"),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomForm(
                  text: "ادخل ايميلك",
                  type: TextInputType.emailAddress,
                  name: email,
                  sufxicon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomPass(
                    text: "ادخل كلمة المرور",
                    type: TextInputType.visiblePassword,
                    issecure: issecure,
                    name: password,
                    sufxicon: InkWell(
                      onTap: () {
                        issecure = !issecure;
                        setState(() {});
                      },
                      child: Icon(
                          issecure ? Icons.visibility_off : Icons.visibility),
                    )),
              ),
              Row(
                children: [
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: const Text(
                        "اعادة تعيين كلمة المرور",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const Spacer(),
                  Checkbox(
                      activeColor: HexColor("8a2be2"),
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      value: ischecked,
                      onChanged: (value) {
                        ischecked = !ischecked;
                        setState(() {});
                      }),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "تذكرني",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: Get.width * 0.8,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      loginUser(email: email.text, password: password.text);
                    },
                    child: isloading
                        ? const Center(
                            child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ))
                        : const Center(
                            child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Center(
                        child: Text(
                      "ليس لديك حساب؟",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const RegisterScreen());
                      },
                      child: const Text("تسجيل حساب جديد",
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
             
            ],
          ),
        ),
      )),
    ));

  }
}
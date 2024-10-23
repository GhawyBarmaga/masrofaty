import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';


import '../shared/components.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool issecure = true;
  bool isloading = false;
  TextEditingController emailaddress = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController username = TextEditingController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    emailaddress.text = "";
    password.text = "";
    username.text = "";
    isloading = false;
    super.initState();
  }

  @override
  void dispose() {
    emailaddress.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //============================validate email=================================
    bool validateEmail(String email) {
      const pattern = r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com)$';
      final regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    //============================Register user==================================
    Future<void> signupUser({
      required String email,
      required String password,
      required String name,
    }) async {
      try {
        if (validateEmail(email) == false) {
          Get.snackbar("😒", " @gmail او @outlook البريد الالكترونى غير صحيح",
              backgroundColor: Colors.white, colorText: Colors.red);
          // isloading = false;

          return;
        }
        if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
          isloading = true;
          setState(() {});
          // register user in auth with email and password
          UserCredential cred =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          //==== add user to your  firestore database=================

          await FirebaseFirestore.instance
              .collection("users")
              .doc(cred.user!.uid)
              .set({
            'name': name,
            'uid': cred.user!.uid,
            'email': email,
            'current_balance': 0,
          });

          isloading = false;
          setState(() {});
          // Get.snackbar("👍", "تم التسجيل بنجاح",
          //     backgroundColor: Colors.white, colorText: Colors.red);

          Get.offAll(() => const LoginScreen());
        } else {
          Get.snackbar("😒", "تأكد من ملىء جميع الخانات",
              backgroundColor: Colors.white, colorText: Colors.red);
        }
      } catch (err) {
        if (err.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          Get.snackbar("😒", "الايميل مستخدم من قبل",
              backgroundColor: Colors.white, colorText: Colors.red);
          isloading = false;
          setState(() {});
        } else {
          Get.snackbar("😒", err.toString(),
              backgroundColor: Colors.amber, colorText: Colors.red);
          isloading = false;
          setState(() {});
        }
      }
    }

    //===================================================================================
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: Get.width,
            height: Get.height * .5,
            padding: EdgeInsets.only(top: Get.height * .15, left: 15),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              HexColor("666666"),
              HexColor("333333"),
              HexColor("101010")
            ])),
            //child: Lottie.asset("assets/animations/login.json.json"),
            child: Text(
              "👋مرحبا بك".tr,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.only(top: Get.height * .3),
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
                color: HexColor("f5f5f5"),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(children: [
              const SizedBox(
                height: 30.0,
              ),
              CustomForm(
                text: "ادخل اسمك".tr,
                type: TextInputType.name,
                name: username,
                sufxicon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 30.0,
              ),
              CustomForm(
                text: "ادخل ايميلك".tr,
                type: TextInputType.emailAddress,
                name: emailaddress,
                sufxicon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 30.0,
              ),
              CustomPass(
                  text: "ادخل كلمة المرور".tr,
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
              const SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                  onTap: () {
                    signupUser(
                        email: emailaddress.text,
                        password: password.text,
                        name: username.text);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            HexColor("666666"),
                            HexColor("333333"),
                            HexColor("101010")
                          ]),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: isloading
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: Text(
                                  "تسجيل الدخول".tr,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ))))),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Center(
                      child: Text(
                    "لديك حساب بالفعل؟".tr,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Text("تسجيل الدخول".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
            ]),
          )
        ]),
      ),
    );
  }
}







// // ignore_for_file: must_be_immutable

// import 'package:ealanat_baladna/controller/registercontroller.dart';
// import 'package:ealanat_baladna/widgets/components.dart';
// import 'package:ealanat_baladna/widgets/otp_txt.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(RegisterController());
//     return GetBuilder<RegisterController>(builder: (RegisterController ctrl) {
//       return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(),
//           body: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: ctrl.formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "تسجيل حساب جديد",
//                       style: TextStyle(
//                           color: Colors.deepPurple,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 25),
//                     ),
//                     SizedBox(
//                       width: Get.width * .9,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: CustomForm(
//                             text: " الاسم ...",
//                             type: TextInputType.name,
//                             name: ctrl.username,
//                             sufxicon: const Icon(Icons.person)),
//                       ),
//                     ),
//                     SizedBox(height: Get.height / 18),
//                     SizedBox(
//                       width: Get.width * .9,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: CustomForm(
//                             // validator: (val) {
//                             //   if ( val==null) {
//                             //     return "يجب ادخال رقم التليفون";
//                             //   }
//                             //   return null;
//                             // },
//                             text: "رقم الهاتف",
//                             formating: [LengthLimitingTextInputFormatter(11)],
//                             type: TextInputType.phone,
//                             name: ctrl.phonenum,
//                             sufxicon: const Icon(Icons.phone_android)),
//                       ),
//                     ),
//                     SizedBox(height: Get.height / 30),
//                     OtpText(
//                       otpController: ctrl.otpController,
//                       isshow: ctrl.otpisshow,
//                       onComplete: (otp) {
//                         ctrl.otpentered = int.parse(otp);
//                       },
//                     ),
//                     SizedBox(height: Get.height / 30),
//                     ElevatedButton(
//                       style: const ButtonStyle(
//                           backgroundColor:
//                               MaterialStatePropertyAll<Color>(Colors.black)),
//                       onPressed: () {
//                         if (ctrl.otpisshow) {
//                           ctrl.addUser();
//                         } else {
//                           ctrl.sendOtp();
//                         }
//                       },
//                       child: Text(
//                         ctrl.otpisshow ? "  تسجيل الحساب" : "ارسال ال otp ",
//                         style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 3,
//                     ),
//                     TextButton(
//                         onPressed: () {},
//                         child: const Text(
//                           "الدخول",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ))
//                   ],
//                 ),
//               ),
//             ),
//           ));
//     });
//   }
// }

// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controller/masrofy.dart';

import '../../shared/components.dart';

class add_transaction extends StatelessWidget {
  final usercurrent;
  const add_transaction({
    super.key,
    required this.usercurrent,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MasrofyController>(
      builder: (MasrofyController controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("اضافة المصروف",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(
            width: 15.0,
          ),
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 25,
            child: IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(actions: [
                    const SizedBox(height: 10.0),
                    CustomForm(
                      text: " نوع المصروف",
                      type: TextInputType.name,
                      name: controller.expenses,
                    ),
                    const SizedBox(height: 10.0),
                    // const MasrofItem(),
                    const SizedBox(height: 10.0),
                    CustomForm(
                      text: "المبلغ".tr,
                      type: TextInputType.number,
                      name: controller.amount,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //========================================Add Transactions=============================

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              controller.addtransaction(usercurrent);

                              Get.back();
                            },
                            child: const Text(
                              "اضافة المصروف",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),

                        //========================================================================
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.cancel)),
                      ],
                    ),
                  ]));
                },
                icon: const Icon(Icons.add)),
          ),
          const SizedBox(
            width: 20.0,
          ),
          //============================Total Masrof============================
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection("transactions")
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                int totamasrofat = 0;
                int sum = 0;

                if (snapshot.hasData) {
                  for (var result in snapshot.data!.docs) {
                    sum = sum + int.parse(result.data()['amount'].toString());
                  }
                  totamasrofat = sum;

                  //     totamasrofat;
                }
                return Text(
                    // ignore: unnecessary_brace_in_string_interps
                    "$totamasrofat"
                    " "
                    "EGP",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red));
              }),
        ],
      ),
    );
  }
}

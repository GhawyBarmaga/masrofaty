import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../controller/masrofy.dart';
import '../../shared/components.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MasrofyController>(
      builder: (MasrofyController controller) => Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(20.0),
        height: Get.height * .18,
        width: double.infinity,
        decoration: BoxDecoration(
            color: HexColor("0e2f44"),
            borderRadius: BorderRadius.circular(20.0)),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "رصيدك حاليا".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            snapshot.data?.docs[0]['current_balance'] == null
                                ? "0"
                                : "${snapshot.data?.docs[0]['current_balance']}"
                                    " "
                                    "EGP",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green))
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.cyan,
                      radius: 25,
                      child: IconButton(
                          onPressed: () {
                            //=============================================alert dialog=============================
                            Get.dialog(AlertDialog(actions: [
                              CustomForm(
                                text: "الرصيد الجديد".tr,
                                type: TextInputType.number,
                                name: controller.balance,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        controller.addbalance(
                                            snapshot.data?.docs[0]['uid']);
                                        Get.back();
                                      },
                                      child: Text(
                                        "اضافة الرصيد".tr,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(Icons.cancel))
                                ],
                              ),
                            ]));
                          },
                          //====================================================================================================
                          icon: const Icon(Icons.add)),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

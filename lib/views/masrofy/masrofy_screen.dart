// ignore_for_file: collection_methods_unrelated_type

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hexcolor/hexcolor.dart';

import '../../controller/masrofy.dart';
import '../../register/login_screen.dart';

import 'add_transaction.dart';
import 'balance_screen.dart';

class MasrofyScreen extends StatelessWidget {
  const MasrofyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("0e2f44"),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: HexColor("0e2f44"),
        title: GetBuilder<MasrofyController>(
          builder: (MasrofyController controller) => TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              controller.resetBalance();
            },
            child: const Text(
              "Reset Balance",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.red,
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                const BalanceScreen(),
                const SizedBox(
                  height: 10.0,
                ),
                //================================Delete Transaction==========================
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          Get.find<MasrofyController>()
                              .deletetransaction(snapshot.data?.docs[0]['uid']);
                        },
                        child: const Text(
                          "ٌReset Transactions",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      );
                      //==========================================================================
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return add_transaction(
                          usercurrent: snapshot.data?.docs[0]['uid'],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                // const Divider(
                //   thickness: 4.0,
                //   color: Colors.amber,
                // ),
                SizedBox(
                  height: Get.height * .5,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("transactions")
                          .orderBy("current_date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.amber,
                          ));
                        }
                        if (snapshot.hasData) {
                          return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.all(8.0),
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            snapshot.data?.docs[index]
                                                ["masrofitem"],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                snapshot.data?.docs[index]
                                                    ["current_date"],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                            const Spacer(),
                                            Text(
                                                "${snapshot.data?.docs[index]["amount"]} EGP",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: snapshot.data?.docs.length ?? 0);
                        } else {
                          return const Text("no data yet");
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

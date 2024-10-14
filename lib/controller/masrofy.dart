// ignore_for_file: avoid_single_cascade_in_expression_statements, collection_methods_unrelated_type

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class MasrofyController extends GetxController {
  String dropdownValue = 'كهربا';
  int totalmasrof = 0;
  int total = 0;
  int sum = 0;
  int totalbalance = 0;
  final TextEditingController amount = TextEditingController();
  final TextEditingController balance = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser?.uid;

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  oninInit() {
    amount.clear();
    dropdownValue == "";
    balance.clear();
    super.onInit();
    update();
  }

  @override
  void dispose() {
    amount.dispose();
    balance.dispose();

    super.dispose();
  }

//=======================Add Balance==============================================
  void addbalance(userid) async {
    try {
      DocumentReference ref =
          FirebaseFirestore.instance.collection("users").doc(userid);

      ref.update({
        "current_balance": FieldValue.increment(int.parse(balance.text)),
      });
      update();
      balance.clear();
    } catch (e) {
      log(e.toString());
    }
  }

//=======================Add transactions==========================================
  void addtransaction(usercurrent) async {
    try {
      if (amount.text.isEmpty || dropdownValue.isEmpty) {
        return;
      }
      QuerySnapshot db = await FirebaseFirestore.instance
          .collection("users")
          .doc(usercurrent)
          .collection("transactions")
          .get();
//========================Add Transaction=============================
      await FirebaseFirestore.instance
          .collection("users")
          .doc(usercurrent)
          .collection("transactions")
          .add({
        "masrofitem": dropdownValue.toString(),
        "current_date": formatter.format(now),
        "amount": int.parse(amount.text)
      });
      update();
      editbalance();
      //=====================check if more than 15 transactions =================================
      if (db.docs.length > 14) {
        deletetransaction(usercurrent);
        Get.snackbar("تحذير",
            "بعد عمل اكثر من 15 حركة سيتم حذفهم دون المساس برصيدك \nويمكنك اضافة حركات جديده ويمكنك الضغط ايضا على Reset TRansactions",
            duration: const Duration(seconds: 15),
            backgroundColor: Colors.white);
      }
      update();
      amount.clear();
      dropdownValue == "";
    } catch (e) {
      log(e.toString());
    }
  }

  //=====================Edit Current Balance==========================================
  void editbalance() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "current_balance": FieldValue.increment(-int.parse(amount.text)),
      });

      update();
    } catch (e) {
      log(e.toString());
    }
  }

  //=====================Reset Balance==========================================

  void resetBalance() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        "current_balance": 0,
      });
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  //=================================delete transaction=============================
  void deletetransaction(id) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("transactions");
      var snapshot = await collection.get();
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }

      update();
    } catch (e) {
      log(e.toString());
    }
  }
}

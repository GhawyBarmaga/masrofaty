import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/masrofy.dart';

class MasrofItem extends StatefulWidget {
  const MasrofItem({super.key});

  @override
  State<MasrofItem> createState() => _MasrofItemState();
}

class _MasrofItemState extends State<MasrofItem> {
  List<String> items = [
    "كهربا",
    "غاز",
    "مياه",
    "ايجار",
    "مواصلات",
    "قروض",
    "اقساط",
    "اكل وشرب",
    "استثمار",
    "صيانه واصلاح",
    "مدارس",
    "اعياد",
    "دروس",
    "زوجه ثانيه",
    "مصاريف اخرى",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MasrofyController>(
      builder: (MasrofyController controller) => DropdownButton(
        dropdownColor: Colors.white,
        value: controller.dropdownValue,
        isExpanded: true,
        hint: const Text("اختر المصروف"),
        items: items
            .map((x) => DropdownMenuItem(
                  value: x,
                  child: Text(x.toString().tr),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            controller.dropdownValue = value.toString();
          });
        },
      ),
    );
  }
}

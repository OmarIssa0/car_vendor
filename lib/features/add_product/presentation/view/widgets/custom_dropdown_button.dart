import 'package:car_vendor/core/utils/app_color.dart';
import 'package:car_vendor/features/lang/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// ignore: must_be_immutable
class CustomDropdown extends StatefulWidget {
  CustomDropdown({super.key, this.value, required this.title, this.items});

  String? value;
  final String title;
  List<DropdownMenuItem<String>>? items;

  @override
  State<CustomDropdown> createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  // String? _yearValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: AppColor.kSilver.withOpacity(.2),
          )),
      child: DropdownButton(
        isExpanded: true,

        underline: const SizedBox(),
        icon: const Icon(IconlyLight.arrow_down_2),
        dropdownColor: Colors.white,
        // value: _yearValue,
        value: widget.value,
        hint: Text(
          widget.value ?? widget.title.tr(context),
          style: const TextStyle(
            color: AppColor.kSilver,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        // items: YearProvider.yearDropDownList,
        items: widget.items,
        onChanged: (value) {
          setState(() {
            widget.value = value;
          });
        },
      ),
    );
  }
}

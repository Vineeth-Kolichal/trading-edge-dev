import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

enum EntryType { profit, loss, deposite, withdraw }
const String defaultUserImage= 'https://firebasestorage.googleapis.com/v0/b/my-tradebook.appspot.com/o/user_profile_images%2Fuser_image_drawer.png?alt=media&token=259f68a2-dfcb-4be3-9028-781154c58fe6';
final defaultPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 50,
    height: 52,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: const Color.fromARGB(31, 148, 144, 144),
      border: Border.all(color: const Color.fromRGBO(1, 80, 145, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );
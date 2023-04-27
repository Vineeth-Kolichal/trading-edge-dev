import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_tradebook/screens/login/screen_login.dart';

Widget gridColumnItem({
  required BuildContext context,
  required String title,
  required String content,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AutoSizeText(title,
            presetFontSizes: const [13.0, 12.0, 11.0, 8.0],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey)),
      ),
      sizedBoxTen,
      Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      )
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:listeny/constants/constants.dart';

Center noSongsWidget() {
  return const Center(
    child: Text(
      'No Songs Found',
      style: TextStyle(color: textColor, fontSize: 20),
    ),
  );
}

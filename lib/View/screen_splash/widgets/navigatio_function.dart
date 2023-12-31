import 'package:flutter/material.dart';
import 'package:listeny/View/widgets/bottom_nav.dart';

navigationFunc(context) async {
  await Future.delayed(const Duration(milliseconds: 3000));
  // ignore: use_build_context_synchronously
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (ctx) => const ScreenMain()));
}

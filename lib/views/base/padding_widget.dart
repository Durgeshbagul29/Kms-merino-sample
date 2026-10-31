import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
  const PaddingWidget(this.child,{super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top:20,bottom:10),
      child: child,
    );
  }
}
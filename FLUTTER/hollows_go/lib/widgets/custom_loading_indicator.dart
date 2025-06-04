import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;

  const CustomLoadingIndicator({Key? key, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/loading/loading.gif',
        width: size,
        height: size,
      ),
    );
  }
}

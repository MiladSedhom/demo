import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        Opacity(
          opacity: 0.6,
          child: Container(
            color: Colors.black,
          ),
        ),
        const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ))
      ]),
    );
  }
}

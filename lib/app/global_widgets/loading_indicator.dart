import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../core/theme/app_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.white),
        padding: const EdgeInsets.all(16),
        child: LoadingAnimationWidget.fourRotatingDots(
            color: AppColor.PRIMARY_500, size: 24),
      ),
    );
  }
}

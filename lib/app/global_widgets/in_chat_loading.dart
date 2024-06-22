import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../core/theme/app_color.dart';

class InChatLoading extends StatelessWidget {
  const InChatLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.PRIMARY_100),
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4),
      child: LoadingAnimationWidget.waveDots(
          color: AppColor.PRIMARY_500, size: 24),
    );
  }
}

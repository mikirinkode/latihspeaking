import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_color.dart';
import '../controllers/embedded_web_controller.dart';

class EmbeddedWebView extends GetView<EmbeddedWebController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
        titleSpacing: 0.0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController.value),
          Center(
              child: Obx(() => (controller.loadingPercentage.value < 1)
                  ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                padding: const EdgeInsets.all(16),
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: AppColor.PRIMARY_500, size: 24),
              )
                  : Container()))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbeddedWebController extends GetxController {
  final loadingPercentage = (0.0).obs;
  final feedbackFormUrl = "https://forms.gle/bxRNgavRcVwxCdo67";
  var webViewController = WebViewController().obs;
  final formResponseCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupWebView();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _setupWebView() {
    webViewController.value
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loadingPercentage.value = progress.toDouble() / 100.0;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            final host = Uri.parse(request.url).toString();
            Get.log("WebView: host: ${host}");
            Get.log(
                "WebView: is contain /formResponse: ${host.contains("/formResponse")}");
            // if (host.contains("/formResponse")) {
            //   Get.back();
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            if ((change.url?.contains("/formResponse") ?? false) &&
                formResponseCount.value < 1) {
              formResponseCount.value++; // prevent double back

              // make back after 3 seconds
              Future.delayed(const Duration(seconds: 3), () {
                Get.back();
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(feedbackFormUrl));
  }
}

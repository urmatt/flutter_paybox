import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWidget extends StatefulWidget {
  /// Called on any result from payment
  /// with isSuccess
  final Function(bool isSuccess)? onPaymentDone;

  final String? paymentPageUrl;

  PaymentWidget({this.paymentPageUrl, this.onPaymentDone});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  String blankPage = 'about:blank';

  bool isPaymentDone = false;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: getUrl(),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: onNavigationDelegate,
    );
  }

  NavigationDecision onNavigationDelegate(NavigationRequest request) {
    if (request.url.contains('success')) {
      paymentDone(true);
    } else if (request.url.contains('failure')) {
      paymentDone(false);
    }
    return NavigationDecision.navigate;
  }

  String getUrl() {
    if (widget.paymentPageUrl != null && !isPaymentDone)
      return widget.paymentPageUrl!;
    return blankPage;
  }

  void paymentDone(bool result) {
    widget.onPaymentDone?.call(result);
    setState(() {
      isPaymentDone = true;
    });
  }
}

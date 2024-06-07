import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_paybox/src/flutter_paybox.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWidget extends StatefulWidget {
  static _PaymentWidgetState? of(BuildContext context, {bool root = false}) =>
      root
          ? context.findRootAncestorStateOfType<_PaymentWidgetState>()
          : context.findAncestorStateOfType<_PaymentWidgetState>();

  /// Called on any result from payment
  /// with isSuccess
  final Function(bool isSuccess)? onPaymentDone;
  final PaymentWidgetController? controller;

  PaymentWidget({this.controller, this.onPaymentDone});

  @override
  State<PaymentWidget> createState() {
    var state = _PaymentWidgetState();
    controller?.targetState = state;
    return state;
  }
}

class _PaymentWidgetState extends State<PaymentWidget> {
  String blankPage = 'about:blank';

  late WebViewController _webViewController;

  bool isPaymentDone = false;
  String? _pageUrl;

  Uri get _initialUri => Uri.parse(getUrl());

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _webViewController = WebViewController.fromPlatformCreationParams(params);

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..loadRequest(_initialUri)
      ..setNavigationDelegate(_navigationDelegate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller?.targetContext = context;
    return WebViewWidget(
      controller: _webViewController,
    );
  }

  NavigationDelegate get _navigationDelegate => NavigationDelegate(
        onNavigationRequest: _onNavigationRequest,
      );

  FutureOr<NavigationDecision> _onNavigationRequest(NavigationRequest request) {
    if (request.url.contains('success')) {
      paymentDone(true);
    } else if (request.url.contains('failure')) {
      paymentDone(false);
    }
    return NavigationDecision.navigate;
  }

  void setUrl(String url) {
    assert(url.isNotEmpty);

    setState(() {
      _pageUrl = url;
      _webViewController.loadRequest(Uri.parse(url));
    });
  }

  String getUrl() {
    if (_pageUrl?.isEmpty == true) return blankPage;
    if (_pageUrl != null && !isPaymentDone) return _pageUrl!;
    return blankPage;
  }

  void paymentDone(bool result) {
    widget.onPaymentDone?.call(result);
    setState(() {
      isPaymentDone = true;
    });
  }
}

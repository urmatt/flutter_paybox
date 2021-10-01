import 'package:flutter_paybox/src/api/constants.dart';

import '../extensions/string.dart';

class PayboxError extends Error {
  String? description;

  PayboxError({this.description = 'Paybox Error'});

  factory PayboxError.fromXml(String? xml) {
    var error = PayboxError();
    if (xml != null && xml.contains(STATUS)) {
      error.description = xml.betweenXml(ERROR_DESCRIPTION);
    }
    return error;
  }
}

import 'package:flutter_paybox/src/api/constants.dart';
import 'package:flutter_paybox/src/extensions/string.dart';

class Capture{
  String? status;
  double? amount;
  double? clearingAmount;

  Capture({
    this.status,
    this.amount,
    this.clearingAmount,
  });

  factory Capture.fromXml(String xml) {
    return Capture(
      status: xml.betweenXml(STATUS),
      amount: xml.betweenXmlDouble(AMOUNT),
      clearingAmount: xml.betweenXmlDouble(CLEARING_AMOUNT),
    );
  }
}

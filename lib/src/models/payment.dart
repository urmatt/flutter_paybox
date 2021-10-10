import 'package:flutter_paybox/src/api/constants.dart';

import '../extensions/string.dart';

class Payment {
  String? status;
  int? paymentId;
  String? redirectUrl;

  Payment({
    this.status,
    this.paymentId,
    this.redirectUrl,
  });

  factory Payment.fromXml(String xml) {
    var payment = Payment();
    payment.paymentId = xml.betweenXmlInt(PAYMENT_ID);
    payment.status = xml.betweenXml(STATUS);
    payment.redirectUrl = xml.betweenXml(REDIRECT_URL);
    return payment;
  }
}

class RecurringPayment {
  String? status;
  int? paymentId;
  String? currency;
  double? amount;
  String? recurringProfile;
  String? recurringExpireDate;

  RecurringPayment({
    this.status,
    this.paymentId,
    this.currency,
    this.amount,
    this.recurringProfile,
    this.recurringExpireDate,
  });

  factory RecurringPayment.fromXml(String xml) {
    return RecurringPayment(
      status: xml.betweenXml(STATUS),
      paymentId: xml.betweenXmlInt(PAYMENT_ID),
      currency: xml.betweenXml(CURRENCY),
      amount: xml.betweenXmlDouble(AMOUNT),
      recurringProfile: xml.betweenXml(RECURRING_PROFILE),
      recurringExpireDate: xml.betweenXml(RECURRING_PROFILE_EXPIRY),
    );
  }
}

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
    payment.paymentId = xml.betweenXmlInt('pg_payment_id');
    payment.status = xml.betweenXml('pg_status');
    payment.redirectUrl = xml.betweenXml('pg_redirect_url');
    return payment;
  }
}

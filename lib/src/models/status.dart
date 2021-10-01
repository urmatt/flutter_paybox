import 'package:flutter_paybox/src/api/constants.dart';
import '../extensions/string.dart';

class Status {
  String? status;
  int? paymentId;
  String? transactionStatus;
  String? canReject;
  String? isCaptured;
  String? cardPan;
  String? createDate;

  Status({
    this.status,
    this.paymentId,
    this.transactionStatus,
    this.canReject,
    this.isCaptured,
    this.cardPan,
    this.createDate,
  });

  factory Status.fromXml(String xml) {
    var status = Status();
    status.status = xml.betweenXml(STATUS);
    status.paymentId = xml.betweenXmlInt(PAYMENT_ID);
    status.transactionStatus = xml.betweenXml(TRANSACTION_STATUS);
    status.canReject = xml.betweenXml(CAN_REJECT);
    status.isCaptured = xml.betweenXml(CAPTURED);
    status.cardPan = xml.betweenXml(CARD_PAN);
    status.createDate = xml.betweenXml(CREATED_AT);
    return status;
  }
}

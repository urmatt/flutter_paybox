import 'package:flutter_paybox/src/api/constants.dart';
import 'package:flutter_paybox/src/extensions/string.dart';

class Card {
  String? status;
  String? merchantId;
  String? cardId;
  String? recurringProfile;
  String? cardHash;
  String? date;

  Card({
    this.status,
    this.merchantId,
    this.cardId,
    this.recurringProfile,
    this.cardHash,
    this.date,
  });

  factory Card.fromXml(String xml) {
    return Card(
        status: xml.betweenXml(STATUS),
        merchantId: xml.betweenXml(MERCHANT_ID),
        cardId: xml.betweenXml(CARD_ID),
        recurringProfile: xml.betweenXml(RECURRING_PROFILE),
        cardHash: xml.betweenXml(CARD_HASH),
        date: xml.betweenXml(CREATED_AT));
  }

  static List<Card> listFromXml(String xml) {
    var list = <Card>[];
    xml.split('<card>').forEach((e) {
      if (e.isNotEmpty) {
        var cardXml = e.replaceAll('</card>', '');
        list.add(Card.fromXml(cardXml));
      }
    });
    return list;
  }
}

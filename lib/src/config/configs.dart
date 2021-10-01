enum PaymentSystem {
  KAZPOSTKZT,
  CYBERPLATKZT,
  CONTACTKZT,
  SBERONLINEKZT,
  ONLINEBANK,
  CASHBYCODE,
  KASPIKZT,
  KAZPOSTYANDEX,
  SMARTBANKKZT,
  NURBANKKZT,
  BANKRBK24KZT,
  ALFACLICKKZT,
  FORTEBANKKZT,
  EPAYWEBKGS,
  EPAYKGS,
  HOMEBANKKZT,
  EPAYKZT,
  KASSA24,
  P2PKKB,
  EPAYWEBKZT
}

enum RequestMethod { GET, POST }
enum Language { ru, en, kz, de }

extension RequestMethodToString on RequestMethod {
  String toSortString() {
    return this.toString().split('.').last;
  }
}

extension PaymentSystemToString on PaymentSystem {
  String toSortString() {
    return this.toString().split('.').last;
  }
}

extension LanguageToString on Language {
  String toSortString() {
    return this.toString().split('.').last;
  }
}

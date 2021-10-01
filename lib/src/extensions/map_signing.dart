import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_paybox/src/api/constants.dart';
import 'random.dart';

extension SignedParams on Map<String, dynamic> {
  Map<String, dynamic> signedParams(String url, {String? secretKey = ''}) {
    var sorted = Map<String, dynamic>();
    var paths = url.split('/');
    var sig = paths.last;
    this[SALT] = Random().randomString();
    var keysList = this.keys.toList();
    keysList.sort();
    keysList.forEach((key) {
      if (this.containsKey(key) && this[key] != null) {
        sig += ';';
        sig += "${this[key]}";
        sorted[key] = this[key];
      }
    });
    sig += ";$secretKey";
    sorted[SIG] = md5.convert(utf8.encode(sig)).toString();
    return sorted;
  }
}

import 'dart:math';

extension RandomString on Random {
  static String chars = '0123456789abcdefghijklmnopqrstywxqz';

  String randomString({int length = 16}) {
    var res = '';
    var random = Random();
    while (res.length < length) {
      res += chars[random.nextInt(chars.length)];
    }
    return res;
  }
}

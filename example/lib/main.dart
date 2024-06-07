import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paybox/paybox.dart';

import 'package:flutter_paybox/environments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter paybox demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var paybox = Paybox(
    merchantId: MERCHANTID,
    secretKey: SECRET_KEY,
  );

  int? paymentId;

  @override
  void initState() {
    paybox.configuration.testMode = true;
    paybox.configuration.paymentSystem = PaymentSystem.EPAYWEBKGS;
    paybox.configuration.currencyCode = 'KGS';
    // paybox.configuration.autoClearing = false;
    // paybox.configuration.encoding = 'UTF-8';
    // paybox.configuration.recurringLifetime = 12;
    // paybox.configuration.paymentLifetime = 12;
    // paybox.configuration.recurringMode = true;
    // paybox.configuration.userPhone = '987654321';
    // paybox.configuration.userEmail = 'user@email.mail';
    // paybox.configuration.language = Language.ru;
    //
    // paybox.configuration.checkUrl = String;
    // paybox.configuration.resultUrl = String;
    // paybox.configuration.refundUrl = String;
    // paybox.configuration.autoClearing = bool;
    // paybox.configuration.requestMethod = RequestMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.menu,
            ),
            onSelected: (value) {
              switch (value) {
                case 0:
                  onCreatePayment();
                  break;
                case 1:
                  onAddCard();
                  break;
                case 2:
                  onPayFromCard();
                  break;
              }
            },
            itemBuilder: (context) => [
              buildPopupMenuItem(0, Icons.add, "Create"),
              buildPopupMenuItem(1, Icons.credit_card, "Add card"),
              buildPopupMenuItem(2, Icons.payment, "Pay from card"),
            ],
          )
        ],
      ),
      body: PaymentWidget(
        controller: paybox.controller,
        onPaymentDone: (success) {
          if (kDebugMode) {
            print("Payment success: $success");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onCreatePayment() {
    paybox
        .createPayment(
      amount: 1,
      userId: "001",
      orderId: "1",
      description: "Just test payment",
    )
        .then((payment) {
      if (payment != null) {
        paymentId = payment.paymentId;
      }
    }).onError((error, stackTrace) {
      // Handle PayboxError
    });
  }

  void onAddCard() {
    paybox.addNewCard(userId: "1");
  }

  void onPayFromCard() {
    if (paymentId != null) paybox.payFromCard(paymentId!);
  }

  PopupMenuItem<int> buildPopupMenuItem(
      int value, IconData icon, String title) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black38),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}

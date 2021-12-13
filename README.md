# flutter_paybox


**Paybox (FLutter)**

PayBox Flutter - это библиотека позволяющая упростить взаимодействие с API Paybox.

**Описание возможностей:**

- Инициализация платежа
- Отмена платежа
- Возврат платежа
- Проведение клиринга
- Проведение рекуррентного платежа с сохраненными картами
- Получение информации/статуса платежа
- Добавление карт/Удаление карт
- Оплата добавленными картами

**Установка:**

Добавьте в ваш pubspec.yaml:
```
    dependencies:
      flutter_paybox: ^1.0.0
```


**Работа с библиотекой**

*Импортируйте:*
```
    import 'package:flutter_paybox/paybox.dart';
```

*Инициализация библиотеки:*

```
    var paybox = Paybox(
        merchantId: MERCHANTID,
        secretKey: SECRET_KEY,
    );
```

Добавьте PaymentWidget в ваш дерево виджетов и передайте paybox.controller:

 ```
    PaymentWidget(
        controller: paybox.controller,
        onPaymentDone: (success){}
    )
 ```

*Создание платежа:*

```
    try {
        Payment? payment = await paybox.createPayment(
            amount: 1,
            description: 'Payment description',
            orderId: 'ORDER_ID',
            userId: 'USER_ID'
        );
    } on PayboxError catch (e) {
        // Catch payment creation error
    }
```

После вызова в PaymentWidget откроется платежная страница

*Рекурентный платеж:*

```
    try{
        RecurringPayment? recurringPayment = paybox.createRecurringPayment(
            amount: 1,
            description: 'Recurring payment description',
            recurringProfile: 'RECURRING PROFILE',
            orderId: 'ORDER_ID',
            extraParams: {},
        );
    } on PayboxError catch (e){
        // Catch error
    }
```

*Получение статуса платежа:*

```
    try {
        Status? status = await paybox.getPaymentStatus(123); // payment id
    } on PayboxError catch (e) {
        // Catch error
    }
```

*Клиринг платежа:*

Если не указывать сумму клиринга (amount), то клиринг пройдет на всю сумму платежа

```
    try {
        Capture? capture = await paybox.makeClearingPayment(
            paymentId: 123,
            amount: 10,
        );
    } on PayboxError catch (e) {
        // Catch error
    }
```

*Отмена платежа:*

```
    try {
        Payment? payment = await paybox.cancelPayment(123); //payment id
    } on PayboxError catch (e) {
        // Catch error
    }
```

*Возврат платежа:*

```
    try {
        Payment? payment = await paybox.revokePayment(123); //payment id
    } on PayboxError catch (e) {
        // Catch error
    }
```

*Сохранение карты:*

```
    try {
        Payment? payment = await paybox.addNewCard(
            userId: '123',
            postLink: 'POST_LINK',
        );
    } on PayboxError catch (e) {
        // Catch error
    }
```
После вызова в PaymentWidget откроется платежная страница


*Получить список сохраненых карт:*
```
    try {
        List<Card> cardsList = await paybox.getCards('123'); //user id
    } on PayboxError catch (e) {
        // Catch error
    }
```


*Удаление сохраненой карты:*
```
    try {
        Card? card = await paybox.removeCard(
            cardId: 123,
            userId: 'USER_ID',
        );
    } on PayboxError catch (e) {
        // Catch error
    }
```
*Создание платежа сохраненой картой:*
```
    try {
        Payment? payment = await paybox.createCardPayment(
            amount: 123,
            userId: 'USER_ID',
            cardId: 123,
            description: 'Card payment creation',
            orderId: 'ORDER_ID',
            extraParams: {},
        );
    } on PayboxError catch (e) {
        // Catch error
    }

```

Для оплаты созданного платежа:
```
    try {
        Payment? payment = await paybox.payFromCard(123); //payment id
    } on PayboxError catch (e) {
        // Catch error
    }
```

После вызова в PaymentWidget откроется платежная страница для 3ds аутентификации

**Настройки**

*Тестовый режим:*
```
    paybox.configuration.testMode = true;  //По умолчанию тестовый режим включен
```

*Выбор платежной системы:*
```
    paybox.configuration.paymentSystem = PaymentSystem.*;
```

*Выбор валюты платежа:*
```
    paybox.configuration.currencyCode = 'KGS';
```

*Активация автоклиринга:*
```
    paybox.configuration.autoClearing = true;
```

*Установка кодировки:*
```
    paybox.configuration.encoding = 'UTF-8'; //по умолчанию UTF-8
```

*Время жизни рекурентного профиля:*
```
    paybox.configuration.recurringLifetime = 12; //по умолчанию 36 месяцев
```

*Время жизни платежной страницы, в течение которого платеж должен быть завершен:*
```
    paybox.configuration.paymentLifetime = 120;  //по умолчанию 300 секунд
```

*Включение режима рекурентного платежа:*
```
    paybox.configuration.recurringMode = true;  //по умолчанию отключен
```

*Номер телефона клиента, будет отображаться на платежной странице. Если не указать, то будет предложено ввести на платежной странице:*
```
    paybox.configuration.userPhone = '987654321';
```

*Email клиента, будет отображаться на платежной странице. Если не указать email, то будет предложено ввести на платежной странице:*
```
    paybox.configuration.userEmail = 'user@email.mail';
```

*Язык платежной страницы:*
```
    paybox.configuration.language = Language.ru;
```

*Для передачи информации от платежного гейта:*
```
    paybox.configuration.checkUrl = String;
    paybox.configuration.resultUrl = String;
    paybox.configuration.refundUrl = String;
    paybox.configuration.autoClearing = bool;
    paybox.configuration.requestMethod = RequestMethod;
```
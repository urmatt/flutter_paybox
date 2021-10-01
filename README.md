# flutter_paybox


**Paybox SDK (FLutter)**

PayBox SDK Flutter - это библиотека позволяющая упростить взаимодействие с API PayBox. Система SDK работает на Android 4.4 и выше

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
      `flutter_paybox: ^latest`
```


**Работа с SDK**

*Инициализация SDK:*

```
    var sdk = PayboxSdk(merchantId: MERCHANT_ID, secretKey: 'YOUR_SECRET_KEY');
```

Добавьте PaymentWidget в ваш Widget:

 ```
    PaymentWidget(
        onPaymentDone: (success){}
    )
 ```

*Создание платежа:*

```
    try {
        await sdk.createPayment(
            amount: 0,
            description: 'Payment description',
            orderId: '001',
        );
    } on PayboxError catch (e) {
        // Catch payment creation error
    }
```
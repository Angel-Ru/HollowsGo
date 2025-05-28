import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaypalPaymentScreen extends StatelessWidget {
  final String totalAmount;
  final String itemName;

  const PaypalPaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.itemName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UsePaypal(
      sandboxMode: true,
      clientId:
          "AWEoNYNpALWpa9VGtmsQxSbvldFZogFYsQ8IN0t0UP5_E1aqinG40DVcE7DB1RPwx4vs_z1t7ATiGq1v",
      secretKey:
          "EC0MZOw_RJdK8L9zK5FSlsNY2vCc_DPdgUhuu_XklMyBRn9ibR3QoJo0SEBymnx2QIJNdVhWSMz_DpBk",
      returnURL: "https://samplesite.com/return",
      cancelURL: "https://samplesite.com/cancel",
      transactions: [
        {
          "amount": {
            "total": totalAmount,
            "currency": "EUR",
            "details": {
              "subtotal": totalAmount,
              "shipping": '0',
              "shipping_discount": 0,
            }
          },
          "description": "Compra de monedes ($itemName)",
          "item_list": {
            "items": [
              {
                "name": itemName,
                "quantity": 1,
                "price": totalAmount,
                "currency": "EUR",
              }
            ],
          }
        }
      ],
      note: "Contacta amb nosaltres per qualsevol dubte.",
      onSuccess: (params) {
        print("✅ Compra completada: $params");
        Navigator.of(context).pop(); // tornar a la pantalla anterior
      },
      onError: (error) {
        print("❌ Error a la compra: $error");
        Navigator.of(context).pop();
      },
      onCancel: (params) {
        print("⚠️ Compra cancel·lada: $params");
        Navigator.of(context).pop();
      },
    );
  }
}

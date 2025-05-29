import '../../imports.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaypalPaymentScreen extends StatefulWidget {
  final String totalAmount;
  final String itemName;

  const PaypalPaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.itemName,
  }) : super(key: key);

  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
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
            "total": widget.totalAmount,
            "currency": "EUR",
            "details": {
              "subtotal": widget.totalAmount,
              "shipping": '0',
              "shipping_discount": 0,
            }
          },
          "description": "Compra de monedes (${widget.itemName})",
          "item_list": {
            "items": [
              {
                "name": widget.itemName,
                "quantity": 1,
                "price": widget.totalAmount,
                "currency": "EUR",
              }
            ],
          }
        }
      ],
      note: "Contacta amb nosaltres per qualsevol dubte.",
      onSuccess: (params) async {
        print("✅ Compra completada: $params");
        final monedes = int.tryParse(widget.itemName.split(" ").first);
        print(monedes);

        if (!mounted) return;

        if (monedes != null) {
          await Provider.of<UserProvider>(context, listen: false)
              .sumarPuntsUsuari(monedes);
        }
        if (mounted) {
          Navigator.of(context)
              .pop(TendaScreen()); // tornar a la pantalla anterior
        }
      },
      onError: (error) {
        print("❌ Error a la compra: $error");
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      onCancel: (params) {
        print("⚠️ Compra cancel·lada: $params");
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

import '../../imports.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaypalPaymentScreen extends StatefulWidget {
  final String totalAmount;
  final String itemName;
  final int puntsComprats;

  const PaypalPaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.itemName,
    required this.puntsComprats,
  }) : super(key: key);

  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  Future<void> sumarPuntsUsuari(int puntsASumar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      int? userId = prefs.getInt('userId');

      if (userId == null || token == null) {
        print("Usuari o token no disponibles");
        return;
      }

      final url = Uri.parse(
          'https://${Config.ip}/usuaris/punts/comprats/$userId/$puntsASumar');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        print("Punts afegits correctament");
        // Si tens un mètode per refrescar punts, el pots cridar aquí.
        // refreshPoints();
      } else {
        print(
            "Error al sumar punts: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error a sumarPuntsUsuari: $e");
    }
  }

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

        await sumarPuntsUsuari(widget.puntsComprats);

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => TendaScreen()),
          );
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

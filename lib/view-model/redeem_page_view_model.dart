import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';

class RedeemPageViewModel extends ChangeNotifier {
  double _money = 0.0;
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();

  String _errorMsg = "";

  GlobalKey<FormState> get formKey => _formKey;
  String get errorMsg => _errorMsg;
  TextEditingController get pointsController => _pointsController;
  double get money => _money;
  set money(double m) {
    _money = m;
  }

  Future<void> redeemPoints(BuildContext context, FrontPageViewModel vm) async {
    if (formKey.currentState!.validate()) {
      final outPoints = int.parse(pointsController.text);

      final response = await http.patch(
        Uri.parse(
          "${constants.backend}/api/users/redeemPoints/${constants.session['id']}?outPoints=$outPoints",
        ),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await vm.fetchUserPoints(constants.session['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Redeemed \$${(outPoints * 0.5).toStringAsFixed(2)}! Go to vouchers page to buy vouchers.",
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Go to merchant catalog and grab more points."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

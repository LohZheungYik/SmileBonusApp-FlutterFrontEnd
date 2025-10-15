import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';

class ProfilePageViewModel extends ChangeNotifier {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get phoneNumberCtrl => _phoneNumberCtrl;
  TextEditingController get passwordCtrl => _passwordCtrl;
  TextEditingController get confirmPasswordCtrl => _confirmPasswordCtrl;
  String get phoneNumber => _phoneNumber;
  set password(String p) {_password = p;}
  set confirmPassword(String cp) {_confirmPassword = cp;}
  

  Future<void> loadProfile() async {
    _phoneNumberCtrl.text = constants.session['phoneNumber'] ?? '';
  }
  
  Future<void> saveProfileChanges(BuildContext context, FrontPageViewModel vm) async {
    if (_formKey.currentState!.validate()) {
      final response = await http.patch(
        Uri.parse("${constants.backend}/api/users/${constants.session['id']}"),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "hp": _phoneNumberCtrl.text,
          "password": _passwordCtrl.text,
        }),
      );
      if (response.statusCode == 200) {
        await vm.fetchUserPoints(constants.session['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated"),
            backgroundColor: Colors.green,
          ),
        );

        constants.session['phoneNumber'] = _phoneNumberCtrl.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please try again later"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

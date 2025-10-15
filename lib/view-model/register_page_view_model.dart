import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/user.dart';

class RegisterPageViewModel extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _password = '';
  String _confirmPassword = '';

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;

  set name(String n) {
    _name = n;
  }

  set email(String e) {
    _email = e;
  }

  set phoneNumber(String p) {
    _phoneNumber = p;
  }

  TextEditingController get passwordCtrl => _passwordCtrl;
  set password(String p) {
    _password = p;
  }

  TextEditingController get confirmPasswordCtrl => _confirmPasswordCtrl;
  set confirmPassword(String cp) {
    _confirmPassword = cp;
  }

  Future<void> prepareSubmitRegistration(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User u = new User();
      u.name = _name;
      u.email = _email;
      u.phoneNumber = _phoneNumber;
      u.password = _password;
      u.type = "normal";

      registerUser(context, u);
    }
  }

  Future<void> registerUser(BuildContext context, User u) async {
    String uri = "${constants.backend}/api/users/register";

    var json = u.toJson();
    var encoded = jsonEncode(json);

    print(encoded);

    final response = await http.post(
      Uri.parse(uri),
      headers: {'Content-Type': 'application/json'},
      body: encoded,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email already existed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

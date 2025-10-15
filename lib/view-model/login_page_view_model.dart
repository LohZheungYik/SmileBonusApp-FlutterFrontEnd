import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/user.dart';
import 'package:winkclone/view/home.dart';

class LoginPageViewModel extends ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _errorMsg = '';

  String _googleLoginUrl =
      "${constants.backend}/oauth2/authorization/google?state=android";

  GlobalKey<FormState> get formKey => _formKey;
  set email(String e) {
    _email = e;
  }

  String get email => _email;
  set password(String p) {
    _password = p;
  }

  String get password => _password;
  String get errorMsg => _errorMsg;
  String get googleLoginUrl => _googleLoginUrl;

  Future<void> launchWebsite(String website) async {
    final Uri uri = Uri.parse(website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $website';
    }
  }

  Future<void> prepareSubmitLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // print("email: $_email, password: $_password");

      User u = new User();
      u.email = email;
      u.password = password;
      Map<String, dynamic> userJson = u.toJson();
      bool isValid = await submitLogin(userJson);
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home()),
        );
      }
    }
  }

  Future<bool> submitLogin(Map<String, dynamic> json) async {
    var credentials = jsonEncode(json);
    final response = await http.post(
      Uri.parse('${constants.backend}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: credentials,
    );
    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);

      constants.session = user;

      return true;
    } else {
      _errorMsg = "Please enter the correct email and password";
      notifyListeners();

      return false;
    }
  }
}

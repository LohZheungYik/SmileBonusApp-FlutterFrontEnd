
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';

class VoucherDetailPageViewModel extends ChangeNotifier {
  Map<String, dynamic>? _voucher; // nullable until loaded
  bool _isLoading = true;

  Map<String, dynamic>? get voucher => _voucher;
  bool get isLoading => _isLoading;

  Future<void> fetchVoucherDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse("${constants.backend}/api/vouchers/$id"),

        

        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _voucher = data;
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception("Failed to load voucher");
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });

      _isLoading = false;
      notifyListeners();
      debugPrint("Error: $e");
    }
  }
}

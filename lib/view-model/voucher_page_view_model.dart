import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/voucher.dart';

class VoucherPageViewModel extends ChangeNotifier {
  List<Voucher> _vouchers = [];
  bool _isLoading = false;
  bool _isProcessing = false;

  List<Voucher> get vouchers => _vouchers;
  bool get isLoading => _isLoading;

  //No setState needed, because Provider already manages rebuilds.
  set isProcessing(bool i) {
    _isProcessing = i;
    notifyListeners();
  }

  bool get isProcessing => _isProcessing;

  Future<void> fetchVouchers() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${constants.backend}/api/vouchers/getAll/${constants.session['id']}",
        ),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List jsonList = jsonDecode(response.body);
        _vouchers = jsonList.map((json) => Voucher.fromJson(json)).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = true;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = true;
      notifyListeners();
      print('Error: $e');
    }
  }

  Future<void> grabVoucher(BuildContext context, Voucher voucher) async {
    // prevent double taps
    if (isProcessing) return;

    isProcessing = true;

    try {
      final response = await http.post(
        Uri.parse("${constants.backend}/api/redemptions"),
        headers: {
          'Authorization': 'Bearer ${constants.session['token']}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userId": constants.session['id'],
          "voucherId": voucher.id,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Voucher grabbed. Tap to view voucher."),
            backgroundColor: Colors.green,
          ),
        );

        // call viewModel fetch voucher to trigger notifyListeners() to update state
        await fetchVouchers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not enough money. Convert more points to money"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isProcessing = false;
    }
  }
}

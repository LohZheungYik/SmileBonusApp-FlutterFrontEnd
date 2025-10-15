import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';
import 'package:winkclone/view-model/redeem_page_view_model.dart';

class RedeemPage extends StatefulWidget {
  const RedeemPage({super.key});

  @override
  State<RedeemPage> createState() => _RedeemState();
}

class _RedeemState extends State<RedeemPage> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FrontPageViewModel>(
        context,
        listen: false,
      ).fetchUserPoints(constants.session['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FrontPageViewModel>(context);
    final redeemPageVm = Provider.of<RedeemPageViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Text("You Have", style: WinkTheme.pinkText),
                    Text(
                      vm.points.toString(),
                      style: WinkTheme.blackHeaderText,
                    ),
                    Text("Points", style: WinkTheme.pinkText),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text("1 Point = 0.50 SGD", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Form(
                key: redeemPageVm.formKey,
                child: Column(
                  children: [
                    Text(redeemPageVm.errorMsg, style: TextStyle(color: Colors.red)),
                    Text(
                      "Enter number of points to convert",
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid integer';
                          }
                          return null;
                        },
                        controller: redeemPageVm.pointsController,
                        decoration: InputDecoration(
                          hintText: "0",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (int.tryParse(value) != null) {
                            redeemPageVm.money = double.parse(value) * 0.5;
                          } else if (value == "") {
                            redeemPageVm.money = 0;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Text("eVoucher Value", style: WinkTheme.pinkText),
                    Text(
                      "\$${redeemPageVm.money.toStringAsFixed(2)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: WinkTheme.blackHeaderText,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        minimumSize: const Size(200, 60),
                      ),
                      onPressed: () async {
                        redeemPageVm.redeemPoints(context, vm);
                      },
                      child: const Text("Redeem"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

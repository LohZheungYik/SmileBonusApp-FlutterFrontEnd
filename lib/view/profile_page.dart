import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';
import 'package:winkclone/view-model/profile_page_view_model.dart';
import 'package:winkclone/view/front_page.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onJumpToSecond;
  const ProfilePage({super.key, required this.onJumpToSecond});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FrontPageViewModel>(
        context,
        listen: false,
      ).fetchUserPoints(constants.session['id']);
    
      Provider.of<ProfilePageViewModel>(
        context,
        listen: false,
      ).loadProfile();

    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FrontPageViewModel>(context);
    final profileVm = Provider.of<ProfilePageViewModel>(context);

    return Scaffold(
      body: Form(
        key: profileVm.formKey,
        child: Column(
          children: [
            PointStat(onJumpToSecond: widget.onJumpToSecond, vm: vm),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: TextFormField(
                        controller: profileVm.phoneNumberCtrl,
                        decoration:
                            WinkTheme.hpInputStyle(
                              "8 digit handphone Number",
                            ).copyWith(
                              errorStyle: const TextStyle(
                                color: Colors.red, // force red
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "  Please enter your phone number";
                          }

                          if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                            return "  Enter a valid SG handphone number";
                          }
                          return null; // Valid
                        },
                        // onSaved: (value) => _phoneNumber = value ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: profileVm.passwordCtrl,
                  decoration: WinkTheme.inputStyle("Password", Icons.password)
                      .copyWith(
                        errorStyle: const TextStyle(
                          color: Colors.red, // force red
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "  Please enter your password";
                    }
                    if (value.length < 8) {
                      return "  Password must be at least 8 characters";
                    }
                    return null;
                  },
                  onSaved: (value) => profileVm.password = value ?? '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: profileVm.confirmPasswordCtrl,
                  decoration:
                      WinkTheme.inputStyle(
                        "Confirm Password",
                        Icons.password,
                      ).copyWith(
                        errorStyle: const TextStyle(
                          color: Colors.red, // force red
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "  Please confirm your password";
                    }
                    if (value.length < 8) {
                      return "  Password must be at least 8 characters";
                    }
                    if (value != profileVm.passwordCtrl.text) {
                      return "  Password not match. Please confirm again";
                    }
                    return null;
                  },
                  onSaved: (value) => profileVm.confirmPassword = value ?? '',
                ),
              ),
            ),
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
                profileVm.saveProfileChanges(context, vm);
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

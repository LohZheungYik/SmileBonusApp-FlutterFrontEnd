import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/register_page_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  @override
  Widget build(BuildContext context) {
    final registerPageVm = Provider.of<RegisterPageViewModel>(context);

    return Scaffold(
      backgroundColor: WinkTheme.color,
      appBar: AppBar(
        backgroundColor: WinkTheme.color,
        foregroundColor: Colors.white,
        title: Text("Welcome to 😉"),
      ),
      body: Center(
        child: Form(
          key: registerPageVm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Create an Account",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: TextFormField(
                  decoration: WinkTheme.inputStyle("User Name", Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null; // Valid
                  },
                  onSaved: (value) => registerPageVm.name = value ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: TextFormField(
                  decoration: WinkTheme.inputStyle("Email", Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }

                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null; // Valid
                  },
                  onSaved: (value) => registerPageVm.email = value ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: Row(
                  children: [
                    // Text("+65 ", style: TextStyle(
                    //   color: Colors.white,
                    //   fontSize: 16
                    // )),
                    Expanded(
                      child: TextFormField(
                        decoration: WinkTheme.hpInputStyle(
                          "8 digit handphone Number",
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          }

                          if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                            return "Enter a valid SG handphone number";
                          }
                          return null; // Valid
                        },
                        onSaved: (value) => registerPageVm.phoneNumber = value ?? '',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: TextFormField(
                  controller: registerPageVm.passwordCtrl,
                  decoration: WinkTheme.inputStyle("Password", Icons.password),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                  onSaved: (value) => registerPageVm.password = value ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: TextFormField(
                  controller: registerPageVm.confirmPasswordCtrl,
                  decoration: WinkTheme.inputStyle(
                    "Confirm Password",
                    Icons.password,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    if (value != registerPageVm.passwordCtrl.text) {
                      return "Password not match. Please confirm again";
                    }
                    return null;
                  },
                  onSaved: (value) => registerPageVm.confirmPassword = value ?? '',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 5,
                  right: 5,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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
                    onPressed: () {
                      registerPageVm.prepareSubmitRegistration(context);
                    },
                    child: const Text("Register"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

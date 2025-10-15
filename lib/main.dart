import 'dart:ui';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/view-model/catalog_page_view_model.dart';
import 'package:winkclone/view-model/earn_point_view_model.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';
import 'package:winkclone/view-model/home_view_model.dart';
import 'package:winkclone/view-model/location_detail_view_model.dart';
import 'package:winkclone/view-model/login_page_view_model.dart';
import 'package:winkclone/view-model/profile_page_view_model.dart';
import 'package:winkclone/view-model/redeem_page_view_model.dart';
import 'package:winkclone/view-model/register_page_view_model.dart';
import 'package:winkclone/view-model/search_page_view_model.dart';
import 'package:winkclone/view-model/voucher_detail_page_view_model.dart';
import 'package:winkclone/view-model/voucher_page_view_model.dart';
import 'package:winkclone/view/home.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  String? _latestLink;
  bool _isLoggedIn = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLink();

    _appLinks.uriLinkStream.listen((uri) {
      print("urz : " + uri.toString());
      if (uri != null) {
        setState(() {
          _latestLink = uri.toString();
        });
        _handleDeepLink(uri);
      }
    });
  }

  Future<void> _initDeepLink() async {
    Uri? initialUri;
    try {
      initialUri = await _appLinks
          .getInitialLink(); // use getInitialLink() or getInitialUri()
    } catch (e) {
      print('Failed to get initial deep link: $e');
    }

    if (initialUri != null) {
      setState(() {
        _latestLink = initialUri.toString();
      });
      _handleDeepLink(initialUri);
    }
  }
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _handleDeepLink(Uri uri) {
    if (uri.host == "login-success") {
      //successful google login
      // parse token, userId, etc. from uri.queryParameters
      final id = uri.queryParameters['userId'];
      final email = uri.queryParameters['email'];
      final name = uri.queryParameters['name'];
      final token = uri.queryParameters['token'];
      print(
        'Deep link received: id=$id, name=$name, email=$email, token=$token',
      );

      constants.session['id'] = id;
      constants.session['email'] = email;
      constants.session['name'] = name;
      constants.session['token'] = token;

      // setState(() {
      //   _isLoggedIn = true;
      //   print("t4v");
      //   print(constants.session['token']);
      // });

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => Home()),
      );

    } else if (uri.host == "logout-success") {
      print("logout ok");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SearchPageViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterPageViewModel()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        ChangeNotifierProvider(create: (_) => ProfilePageViewModel()),
        ChangeNotifierProvider(create: (_) => VoucherPageViewModel()),
        ChangeNotifierProvider(create: (_) => VoucherDetailPageViewModel()),
        ChangeNotifierProvider(create: (_) => RedeemPageViewModel()),
        ChangeNotifierProvider(create: (_) => EarnPointViewModel()),
        ChangeNotifierProvider(
          create: (_) => FrontPageViewModel()..fetchPlaces(),
        ),
        ChangeNotifierProvider(create: (_) => LocationDetailViewModel()),
        ChangeNotifierProvider(
          create: (_) => CatalogPageViewModel()..fetchPlaces(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scrollBehavior: AppScrollBehavior(),
        title: 'Flutter Demo',
        theme: WinkTheme.themeData,
        home: _isLoggedIn ? Home() : LoginPage(),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

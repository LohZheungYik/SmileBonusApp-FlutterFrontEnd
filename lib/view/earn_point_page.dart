import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/view-model/earn_point_view_model.dart';
import 'package:winkclone/view/catalog_page.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view/home.dart';
import 'package:winkclone/view/voucher_page.dart';

class EarnPoint extends StatefulWidget {
  final VoidCallback onJumpToThird;
  const EarnPoint({super.key, required this.onJumpToThird});

  @override
  State<EarnPoint> createState() => _EarnPointState();
}

class _EarnPointState extends State<EarnPoint> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EarnPointViewModel>(
        context,
        listen: false,
      ).initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<EarnPointViewModel>(context);

    return Column(
      children: [
        vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 400,
                child: GoogleMap(
                  onMapCreated: vm.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: vm.initialPosition,
                    zoom: vm.initialZoom,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: vm.markers ?? {},
                ),
              ),
        MapNavigator(viewModel: vm),
        QuickLinks(widget: widget),
      ],
    );
  }
}

class MapNavigator extends StatelessWidget {
  const MapNavigator({super.key, required this.viewModel});

  final EarnPointViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MapNavigatorButton(
              viewModel: viewModel,
              title: "NEARBY",
              func: viewModel.jumpToCurrentLocation,
              index: 0,
            ),
            MapNavigatorButton(
              viewModel: viewModel,
              title: "ALL",
              func: viewModel.jumpToAllLocations,
              index: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class MapNavigatorButton extends StatelessWidget {
  const MapNavigatorButton({
    super.key,
    required this.viewModel,
    required this.title,
    required this.func,
    required this.index,
  });

  final EarnPointViewModel viewModel;
  final String title;
  final Function func;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        func();
      },
      label: Text(title, style: TextStyle(color: Colors.white)),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return viewModel.selectedIndex == index
              ? WinkTheme.color
              : Colors.blueGrey;
        }),
      ),
    );
  }
}

class QuickLinks extends StatelessWidget {
  const QuickLinks({super.key, required this.widget});

  final EarnPoint widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Row(
        children: [
          QuickButton(
            title: "Places",
            icon: Icon(Icons.home_outlined, color: Colors.white),
            destination: CatalogPage(),
            isJumpTab: false,
          ),
          QuickButton(
            title: "Redeem",
            icon: Icon(Icons.money_outlined, color: Colors.white),
            destination: null,
            isJumpTab: true,
            widget: widget,
          ),
          QuickButton(
            title: "Vouchers",
            icon: Icon(Icons.attach_money, color: Colors.white),
            destination: VoucherPage(),
            isJumpTab: false,
          ),
        ],
      ),
    );
  }
}

class QuickButton extends StatelessWidget {
  const QuickButton({
    super.key,
    required this.title,
    required this.icon,
    required this.destination,
    required this.isJumpTab,
    this.widget,
  });

  final String title;
  final Icon icon;
  final Widget? destination;
  final EarnPoint? widget;
  final bool isJumpTab;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          isJumpTab
              ? widget?.onJumpToThird()
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => destination ?? Home(),
                  ),
                );
        },
        child: Column(
          
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: WinkTheme.color,
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            SizedBox(height: 4),
            Center(
              child: Text(title, style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/place.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';
import 'package:winkclone/view/location_detail_page.dart';

class FrontPage extends StatefulWidget {
  final VoidCallback onJumpToSecond;

  const FrontPage({super.key, required this.onJumpToSecond});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<FrontPageViewModel>(context, listen: false).fetchPlaces();
      Provider.of<FrontPageViewModel>(
        context,
        listen: false,
      ).fetchUserPoints(constants.session['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FrontPageViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            vm.isPointsLoading
                ? const Center(child: CircularProgressIndicator())
                : PointStat(onJumpToSecond: widget.onJumpToSecond, vm: vm),
            vm.isGridLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      subheader(context, "Explore"),
                      RowScroll(
                        items: vm.places
                            .where((p) => p.type == 'place')
                            .toList(),
                      ),
                      subheader(context, "F&B"),
                      RowScroll(
                        items: vm.places
                            .where((p) => p.type == 'restaurant')
                            .toList(),
                      ),
                      subheader(context, "Merchants"),
                      RowScroll(
                        items: vm.places
                            .where((p) => p.type == 'merchant')
                            .toList(),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Row subheader(BuildContext context, var titleText) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Text(
            titleText,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class PointStat extends StatelessWidget {
  const PointStat({super.key, required this.onJumpToSecond, required this.vm});

  final VoidCallback onJumpToSecond;
  final FrontPageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 160,
          width: double.infinity,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: WinkTheme.color,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          right: 16,
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              height: 130,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: WinkTheme.color,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      
                                      child: Column(
                                        children: [
                                          Text(
                                            vm.points.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Points",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: WinkTheme.color,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.attach_money,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            vm.redeemed
                                                .toDouble()
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Redeemed",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: onJumpToSecond,
                            child: const Text("Earn Points"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RowScroll extends StatelessWidget {
  final List<Place> items;
  const RowScroll({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(items.length, (index) {
            String imgId = items[index].photoUrls?[0] ?? '';

            return Padding(
              padding: const EdgeInsets.only(right: 12), // consistent spacing
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LocationDetailPage(index: items[index].id),
                    ),
                  );
                },
                child: SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Container(
                              width: 160,
                              height: 240,
                              color: Colors.white,
                              child: Image.network(
                                constants.photoUrlHeader + imgId,
                                //url,
                                fit: BoxFit.cover,
                                headers: {
                                  'Authorization':
                                      'Bearer ${constants.session['token']}',
                                },
                              ),
                            ),
                            constants.bonus[items[index].id]![0]
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: ClipPath(
                                      clipper: TriangleClipper(),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.redAccent.shade200,
                                              Colors.red.shade700,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Transform.rotate(
                                                angle: 0.785398,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: const Text(
                                                    "Grab Points \n",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          items[index].name,
                          // +
                          //     "||" +
                          //     constants.bonus[items[index].id]![0].toString() +
                          //     "||" +
                          //     constants.bonus[items[index].id]![1].toString()
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: WinkTheme.blackText,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

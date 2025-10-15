import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/model/place.dart';
import 'package:winkclone/view-model/catalog_page_view_model.dart';
import 'package:winkclone/view/location_detail_page.dart';
import 'package:winkclone/theme/winktheme.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CatalogPageViewModel>(context, listen: false).fetchPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CatalogPageViewModel>(context);

    return CatalogTabs(vm: vm);
  }
}

class CatalogTabs extends StatelessWidget {
  const CatalogTabs({super.key, required this.vm});

  final CatalogPageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text("Wink 😉")),
        body: vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: WinkTheme.color,
                      unselectedLabelColor: Colors.black,
                      indicatorColor: WinkTheme.color,
                      tabs: [
                        Tab(text: 'Explore'),
                        Tab(text: 'F&B'),
                        Tab(text: 'Merchants'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CatalogGrid(
                          places: vm.places
                              .where((p) => p.type == 'place')
                              .toList(),
                        ),
                        CatalogGrid(
                          places: vm.places
                              .where((p) => p.type == 'restaurant')
                              .toList(),
                        ),
                        CatalogGrid(
                          places: vm.places
                              .where((p) => p.type == 'merchant')
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CatalogGrid extends StatelessWidget {
  final List<Place> places;

  const CatalogGrid({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7, // width / height
      ),
      itemCount: places.length, // Number of items
      itemBuilder: (context, index) {
        String imgId = places[index].photoUrls?[0] ?? '';

        return SizedBox(
          height: 300,
          child: Card(
            elevation: 5,
            color: Colors.pink[50],
            child: LayoutBuilder(
              builder: (context, constraint) {
                return CatalogItem(
                  context: context,
                  constraint: constraint,
                  place: places[index],
                  imgId: imgId,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CatalogItem extends StatelessWidget {
  const CatalogItem({
    super.key,
    required this.context,
    required this.constraint,
    required this.place,
    required this.imgId,
  });

  final BuildContext context;
  final BoxConstraints constraint;
  final Place place;
  final String imgId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LocationDetailPage(index: place.id),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Container(
                  height: constraint.maxHeight * 0.7,
                  width: double.infinity,
                  child: Image.network(
                    constants.photoUrlHeader + imgId,
                    //url,
                    fit: BoxFit.cover,
                    headers: {
                      'Authorization': 'Bearer ${constants.session['token']}',
                      'Content-Type': 'application/json',
                    },
                  ),
                ),
                //if have bonues, position one triangle to top right
                constants.bonus[place.id]![0]
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: Colors.redAccent,
                            width: 60,
                            height: 60,
                            child: Center(
                              child: Transform.rotate(
                                angle: 0.785398,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Grab Points \n",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0),

            child: SizedBox(
              height: constraint.maxHeight * 0.3,
              child: Center(
                child: Text(
                  place.name,
                  style: WinkTheme.blackText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
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

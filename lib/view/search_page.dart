import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/search_page_view_model.dart';
import 'package:winkclone/view/location_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final searchVm = Provider.of<SearchPageViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: SearchBar(searchVm: searchVm)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: List.generate(searchVm.places.length, (index) {
              final place = searchVm.places[index];
              return SearchResultItem(place: place);
            }),
          ),
        ),
      ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  const SearchResultItem({super.key, required this.place});

  final dynamic place;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // space between items
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 5,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LocationDetailPage(index: place['id']),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    ImagesRowScroll(place: place),
                    const SizedBox(height: 10),

                    // Title text below the whole row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        place['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star),
                          Text(" ${place['rating']}"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
                constants.bonus[place['id']]![0]
                    ? GrabPointsRibbon()
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GrabPointsRibbon extends StatelessWidget {
  const GrabPointsRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: ClipPath(
        clipper: TriangleClipper(),
        child: Container(
          color: Colors.redAccent,
          width: 60,
          height: 60,
          child: Transform.rotate(
            angle: 0.785398,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text(
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
    );
  }
}

class ImagesRowScroll extends StatelessWidget {
  const ImagesRowScroll({super.key, required this.place});

  final dynamic place;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(place['photoUrls'].length, (index) {
          String imgId = place['photoUrls']![index] ?? '';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              constants.photoUrlHeader + imgId,
              //url,
              fit: BoxFit.cover,
              headers: {
                'Authorization': 'Bearer ${constants.session['token']}',
                'Content-Type': 'application/json',
              },
            ),
          );
        }),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.searchVm});

  final SearchPageViewModel searchVm;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        controller: searchVm.controller,
        onChanged: searchVm.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Try 'Jurong Point'",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: WinkTheme.color,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
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

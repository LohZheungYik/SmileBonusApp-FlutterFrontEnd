import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/front_page_view_model.dart';
import 'package:winkclone/view-model/location_detail_view_model.dart';

class LocationDetailPage extends StatefulWidget {
  final int index;

  const LocationDetailPage({super.key, required this.index});

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = Provider.of<LocationDetailViewModel>(
        context,
        listen: false,
      ).fetchPlaceDetails(widget.index);

      Provider.of<FrontPageViewModel>(
        context,
        listen: false,
      ).fetchUserPoints(constants.session['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationDetailViewModel>(context);
    final pointVm = Provider.of<FrontPageViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Details"), backgroundColor: WinkTheme.color),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              vm.place?.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: WinkTheme.blackHeaderText,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PhotoRowScroll(vm: vm),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.star),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    vm.place?.rating.toString() ?? '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_pin),
                                const SizedBox(width: 8),
                                Expanded(
                                  // or Flexible
                                  child: Text(
                                    vm.place?.address ?? '',
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          vm.place?.website != null &&
                                  vm.place!.website!.isNotEmpty &&
                                  vm.place?.website != ''
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.public),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          vm.place?.website != null &&
                                                  vm.place!.website!.isNotEmpty
                                              ? Uri.parse(
                                                  vm.place!.website!,
                                                ).host
                                              : '',
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
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
                                onPressed: () {
                                  vm.launchMap(
                                    vm.place?.latitude,
                                    vm.place?.longitude,
                                  );
                                },
                                child: const Text("View in Google Maps"),
                              ),
                            ),
                          ),
                          vm.place?.website != null &&
                                  vm.place!.website!.isNotEmpty &&
                                  vm.place?.website != ''
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
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
                                      onPressed: () {
                                        vm.launchExternalWebsite(
                                          vm.place?.website ?? '',
                                        );
                                      },
                                      child: const Text("Visit Website"),
                                    ),
                                  ),
                                )
                              : Center(),
                          //grab points
                          constants.bonus[widget.index]![0]
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
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
                                      onPressed: () {
                                        vm.grabPoints(
                                          widget.index,
                                          pointVm,
                                          context,
                                        );
                                      },
                                      child: Text(
                                        "Grab ${constants.pointType[constants.bonus[widget.index]![1]]} points",
                                      ),
                                    ),
                                  ),
                                )
                              : Center(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class PhotoRowScroll extends StatelessWidget {
  const PhotoRowScroll({
    super.key,
    required this.vm,
  });

  final LocationDetailViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          vm.place?.photoUrls?.length ?? 0,
          (index) {
            String imgId = vm.place?.photoUrls?[index] ?? '';
    
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                constants.photoUrlHeader + imgId,
                fit: BoxFit.cover,
                headers: {
                  'Authorization':
                      'Bearer ${constants.session['token']}',
                  'Content-Type': 'application/json',
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

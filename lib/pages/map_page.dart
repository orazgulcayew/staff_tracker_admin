import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:staff_tracker_admin/main.dart';
import 'package:staff_tracker_admin/model/position.dart';
import 'package:staff_tracker_admin/widgets/dialogs.dart';

class MapPage extends StatefulWidget {
  final String userId;
  const MapPage({super.key, required this.userId});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Position> positions = [];
  late Position lastPosition;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    firestore.collection('locations').doc(widget.userId).get().then((value) {
      setState(() {
        for (var element in value.get('location')) {
          positions.add(Position.fromMap(element));
        }

        lastPosition = positions.last;
        isLoaded = true;
      });
    }).catchError((e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ulanyjyda marşrut ýok!")));
      setState(() {
        isLoaded = true;
        lastPosition = Position(
            longitude: 12,
            latitude: 12,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 1,
            heading: 1,
            speed: 1,
            speedAccuracy: 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showYesNoDialog(context,
                      title: 'Marşrutlary pozuň',
                      message:
                          "Ulanyjynyň marşrutlaryny pozmak isleýärsiňizmi?")
                  .then((value) async {
                if (value == true) {
                  try {
                    await firestore
                        .collection('locations')
                        .doc(widget.userId)
                        .delete();

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Marşrutlar pozuldy!")));
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Näsazlyk ýüze çykdy!")));
                  }
                }
              });
            },
            icon: const Icon(Icons.delete),
            label: const Text("Marşrutlary poz")),
        body: Visibility(
          visible: isLoaded,
          replacement: const Center(child: CircularProgressIndicator()),
          child: FutureBuilder(builder: (context, snapshot) {
            return FlutterMap(
              options: MapOptions(
                zoom: 15.0,
                maxZoom: 18.0,
                // minZoom: 8.0,
                center: LatLng(lastPosition.latitude, lastPosition.longitude),
                // interactiveFlags:
                //     InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              nonRotatedChildren: const [],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (positions.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(

                          // strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                          strokeJoin: StrokeJoin.round,
                          strokeWidth: 4,
                          color: Colors.lightBlue,
                          points: List.generate(
                              positions.length,
                              (index) => LatLng(positions[index].latitude,
                                  positions[index].longitude)))
                    ],
                  ),
                if (positions.isNotEmpty)
                  MarkerLayer(
                    markers: [
                      Marker(
                          width: 24,
                          height: 24,
                          point: LatLng(positions.first.latitude,
                              positions.first.longitude),
                          builder: (context) => Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    color:
                                        const Color.fromARGB(255, 8, 188, 107)),
                              )),
                      if (positions.isNotEmpty)
                        Marker(
                          width: 24,
                          height: 24,
                          point: LatLng(
                              lastPosition.latitude, lastPosition.longitude),
                          builder: (context) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 2.5, color: Colors.white),
                                color: Colors.blue),
                          ),
                        )
                    ],
                  )
              ],
            );
          }),
        ));
  }
}

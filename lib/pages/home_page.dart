import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staff_tracker_admin/main.dart';
import 'package:staff_tracker_admin/pages/map_page.dart';
import 'package:staff_tracker_admin/widgets/search_input.dart';

import '../widgets/dialogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  QuerySnapshot? users;

  String searchValue = '';
  @override
  void initState() {
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: FutureBuilder(builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SearchInput(
                    onChanged: (value) {
                      setState(() {
                        searchValue = value;
                      });
                    },
                    hintText: "Gözle..."),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users?.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = users!.docs[index];
                    if (documentSnapshot
                            .get('name')
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase()) ||
                        documentSnapshot
                            .get('email')
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase())) {
                      return ListTile(
                        tileColor: index % 2 == 1 ? null : Colors.green[50],
                        title: Text(documentSnapshot.get('name')),
                        subtitle: Text(
                          "${documentSnapshot.get('email')}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.black,
                        ),
                        trailing: IconButton(
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
                                      .doc(documentSnapshot.id)
                                      .delete();

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Marşrutlar pozuldy!")));
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Näsazlyk ýüze çykdy!")));
                                }
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapPage(userId: documentSnapshot.id),
                              ));
                        },
                      );
                    }
                    return null;
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void getUsers() async {
    try {
      users = await firestore.collection('users').get();
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoaded = true;
      });
    }
  }
}

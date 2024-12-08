import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_notes/boxes/boxes.dart';
import 'package:hive_notes/models/notesmodel.dart';
import 'package:hive_notes/view/addview/addview.dart';
import 'package:hive_notes/view/editview/editview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                thickness: 1.5,
              ),
              const SizedBox(
                height: 15,
              ),
              ValueListenableBuilder<Box<NotesModel>>(
                valueListenable: Boxes.getData().listenable(),
                builder: (context, box, _) {
                  var data = box.values.toList().cast<NotesModel>();
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => EditView(
                                    description: data[index].description,
                                    title: data[index].title,
                                    dateandtime: data[index].dateandtime,
                                    notesmodel: data[index],
                                    color: data[index].color,
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(data[index].color),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      width: 2.2, color: Colors.black)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0),

                                            // padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              data[index].title.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.0),
                                      // padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              data[index]
                                                  .description
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                                data[index]
                                                    .dateandtime
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                )),
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          BottomAppBar(
            color: Colors.white,
            child: Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  Get.to(() => const AddView());
                },
                child: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 25,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text("New Note")
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

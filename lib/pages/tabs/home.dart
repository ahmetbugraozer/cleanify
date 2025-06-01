import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/firebase_methods/firestore_methods.dart';
import 'package:cleanify/pages/post.dart';
import 'package:cleanify/pages/postmapview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../elements/project_elements.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Scaffold(
            backgroundColor: ProjectColors.projectBackgroundColor,
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("There are no posts yet"),
                      );
                    } else {
                      return ListView(
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((posts) {
                            String id = posts.id;
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2.5),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            width: 2,
                                            color: ProjectColors
                                                .imageBorderColor)),
                                    height: 450,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: [
                                                CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(posts[
                                                                'profilePhoto']
                                                            .toString())),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              posts["fullName"]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16)),
                                                          Text(
                                                              posts["username"]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey))
                                                        ])),
                                                const Spacer(),
                                                Text(
                                                    DateFormat('dd.MM.yyyy')
                                                        .format((DateTime.parse(
                                                            posts["date"]))),
                                                    style: const TextStyle(
                                                        color: Colors.grey))
                                              ])),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Text(
                                                    posts["description"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16))),
                                          ),
                                          Expanded(
                                              flex: 5,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 8),
                                                  child: Container(
                                                      height: 300,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      5)),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              width: 2,
                                                              color: ProjectColors
                                                                  .imageBorderColor)),
                                                      child: Image.network(
                                                          posts["pollutionPhoto"],
                                                          fit: BoxFit.fill)))),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 120,
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return PostMapView(
                                                            latitude: posts[
                                                                "altitude"],
                                                            longtitude: posts[
                                                                "longtitude"],
                                                          );
                                                        }));
                                                      },
                                                      child:
                                                          const Row(children: [
                                                        Icon(Icons.location_on,
                                                            color: Colors.blue),
                                                        SizedBox(width: 10),
                                                        Text('Location',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue))
                                                      ]))),
                                              const Spacer(),
                                              posts['uid'] ==
                                                      Auth().currentUser!.uid
                                                  ? IconButton(
                                                      onPressed: () {
                                                        FirestoreMethods()
                                                            .deletePost(id);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete))
                                                  : const Text("")
                                            ],
                                          )
                                        ])));
                          }).toList());
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const PostPage();
                }));
              },
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              child: const Icon(Icons.add),
            )));
  }
}

//advanced widget models:

//class PollutionView extends StatelessWidget {
//  final String authorName;
//  final String pollutionLocation;
//  const PollutionView(
//      {Key? key, required this.authorName, required this.pollutionLocation})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(children: [
//      Padding(
//          padding: const EdgeInsets.only(
//                top: 18.0,
//              ) +
//              const EdgeInsets.symmetric(horizontal: 10),
//          child: Container(
//              decoration: const BoxDecoration(
//                  color: ProjectColors.projectDefaultColor,
//                  borderRadius: BorderRadius.all(Radius.circular(20))),
//              height: 150,
//              width: 150,
//              child:
//                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//                const Spacer(flex: 4),
//                Expanded(
//                    flex: 5,
//                    child: TextButton(
//                        onPressed: () {},
//                        child: Text(authorName,
//                            style: ProjectTextStyles.styleListViewGeneral))),
//                Expanded(
//                    flex: 4,
//                    child: Text(pollutionLocation, textAlign: TextAlign.center))
//              ]))),
//      Padding(
//          padding: const EdgeInsets.only(bottom: 20, left: 47.5),
//          child: ClipRRect(borderRadius: BorderRadius.circular(500.0)))
//    ]);
//  }
//}

// class ListView2 extends StatefulWidget {
//   const ListView2({super.key});
// 
//   @override
//   State<ListView2> createState() => _ListView2State();
// }
// 
// class _ListView2State extends State<ListView2> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: 10,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Row(children: [
//             SizedBox(
//                 height: 300,
//                 child: ListView(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     children: const [
//                       PollutionView(
//                           authorName: "author", pollutionLocation: "location")
//                     ]))
//           ]);
//         });
//   }
// }
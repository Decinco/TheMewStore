import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../uicon.dart';
import '../../../data/models/userData.dart';
import '../controllers/foreignprofile_controller.dart';

class ForeignprofileView extends GetView<ForeignprofileController> {
  const ForeignprofileView({super.key});
  final String uuid = "107d8c84-c74d-4988-9d01-6226057c26b9";

  Widget profileInfo(Future<UserData> userData) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              profilePicture(userData),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: Container(
                    width: 1, // Thickness
                    height: 110,
                    color: Color.fromRGBO(202, 196, 208, 1),
                  )),
              profileStats(userData)
            ],
          ),
          SizedBox(height: 10),
          profileDescription(userData)
        ]));
  }

  Widget profilePicture(Future<UserData> userData) {
    return Column(
      children: [
        Stack(
          children: [
            FutureBuilder(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 217, 217, 217),
                            highlightColor: Color.fromARGB(255, 255, 255, 255),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                              radius: 50,
                            )));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data found'));
                  } else {
                    UserData userData = snapshot.data!;
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userData
                              .profilePicture ??
                              'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                          radius: 50,
                        ));
                  }
                }),
          ],
        ),
        FutureBuilder(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 217, 217, 217),
                    highlightColor: Color.fromARGB(255, 255, 255, 255),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 100,
                        height: 10,
                        color: Color.fromARGB(255, 217, 217, 217),
                      ),
                    ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data found');
              } else {
                UserData userData = snapshot.data!;
                return Text(
                  userData.userCode,
                  style: TextStyle(
                      color: Color.fromRGBO(152, 151, 151, 1),
                      fontSize: 12,
                      height: 0.8),
                );
              }
            }),
      ],
    );
  }

  Widget profileStats(Future<UserData> userData) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 5),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Color.fromARGB(255, 217, 217, 217),
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return Text(
                        userData.userName ?? 'No Name',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2), // Ajustado el height para separación
                      );
                    }
                  }),
              SizedBox(height: 8), // Separación añadida aquí
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: FutureBuilder(
                      future: userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                              baseColor: Color.fromARGB(255, 217, 217, 217),
                              highlightColor: Color.fromARGB(255, 255, 255, 255),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  width: 100,
                                  height: 12,
                                  color: Color.fromARGB(255, 217, 217, 217),
                                ),
                              ));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('No data found');
                        } else {
                          UserData userData = snapshot.data!;
                          // Función para censurar el email
                          String censorEmail(String email) {
                            if (email.isEmpty) return '';
                            var parts = email.split('@');
                            if (parts.length != 2) return email;

                            String name = parts[0];
                            String domain = parts[1];

                            if (name.length <= 2) {
                              return '${name[0]}***@$domain';
                            } else {
                              return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
                            }
                          }

                          return Text(
                            censorEmail(userData.email),
                            style: TextStyle(
                                fontSize: 12,
                                height: 1,
                                color: Color.fromRGBO(152, 151, 151, 1)),
                          );
                        }
                      })),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                UIcons.fibsglobe,
                size: 30,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              SizedBox(width: 5),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 100,
                              height: 16,
                              color: Color.fromARGB(255, 217, 217, 217),
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return Text(
                        userData.region,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(78, 78, 78, 1),
                        ),
                      );
                    }
                  }),
            ],
          ),
          Row(
            children: [
              Icon(
                UIcons.fibsmessagestar,
                size: 30,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              SizedBox(width: 2),
              FutureBuilder(
                  future: userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Color.fromARGB(255, 217, 217, 217),
                          highlightColor: Color.fromARGB(255, 255, 255, 255),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: StarRating(
                              size: 24,
                              color: Color.fromRGBO(78, 78, 78, 1),
                              borderColor: Color.fromRGBO(78, 78, 78, 1),
                              starCount: 5,
                              allowHalfRating: true,
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('No data found');
                    } else {
                      UserData userData = snapshot.data!;
                      return StarRating(
                        size: 24,
                        rating: userData.rating.toDouble(),
                        color: Color.fromRGBO(78, 78, 78, 1),
                        borderColor: Color.fromRGBO(78, 78, 78, 1),
                        starCount: 5,
                        allowHalfRating: true,
                      );
                    }
                  })
            ],
          )
        ]);
  }

  Widget profileDescription(Future<UserData> userData) {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10,10,35,10),
                child: FutureBuilder(
                    future: userData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 217, 217, 217),
                            highlightColor: Color.fromARGB(255, 255, 255, 255),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                color: Color.fromARGB(255, 217, 217, 217),
                              ),
                            ));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('No data found');
                      } else {
                        UserData userData = snapshot.data!;
                        return Text(
                          '${userData.description != null ? '"${userData.description}"' : 'Make your own description!'}\n\n\n',
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color.fromRGBO(78, 78, 78, 1)),
                        );
                      }
                    })),
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    controller.userData = controller.getProfileData().obs;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              )),
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(UIcons.fibsmenuburger),
            onPressed: () {
              // Acción para el icono de hamburguesa
            },
          ),
          actions: [
            IconButton(
              icon: Icon(UIcons.fibscross),
              onPressed: () {
                // Acción para el icono de cruz
                Get.back();
              },
            ),
          ],

        ),
        body: Container(
            color: Color.fromARGB(255, 237, 213, 229),
            width: double.infinity,
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    tabs: [
                      Tab(
                        text: "Profile",
                        icon: Icon(UIcons.fibsuser),
                      ),
                    ],
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Inter"),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                        Obx(() => Column(
                          children: [
                            profileInfo(controller.userData.value),
                            // Add more widgets here as needed
                          ],
                        )),
                        Container()
                      ]))
                ]))));
  }
}
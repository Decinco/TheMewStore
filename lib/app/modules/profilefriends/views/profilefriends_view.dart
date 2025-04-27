import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating/flutter_rating.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themewstore/app/data/models/expansion.dart';
import 'package:themewstore/app/data/models/friendLink.dart';
import 'package:themewstore/app/data/models/userData.dart';
import 'package:themewstore/app/data/models/card.dart' as card;
import 'package:themewstore/uicon.dart';

import '../../generic/sidebar/hamburguesa.dart';
import '../controllers/profilefriends_controller.dart';

class ProfilefriendsView extends GetView<ProfilefriendsController> {
  const ProfilefriendsView({super.key});

  Widget profileInfo(Future<UserData> userData) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
            Positioned(
                right: 3,
                top: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    color: Color.fromRGBO(217, 217, 217, 1),
                    width: 30,
                    height: 30,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.changeImage();
                        },
                        icon: Icon(UIcons.fibspencil)),
                  ),
                ))
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
          Row(children: [
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
                          height: 0.1),
                    );
                  }
                }),
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Enter your username below:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextField(
                                  maxLength: 14,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  controller: controller.usernameC,
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    label: Text(
                                      "Username",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(152, 151, 151, 1)),
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                )),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                controller.changeUsername();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(135, 45),
                                elevation: 0,
                                backgroundColor:
                                    Color.fromARGB(255, 118, 171, 218),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Inter"),
                              ),
                              child: const Text("Submit"),
                            ),
                          ],
                        )),
                    isScrollControlled: true,
                    backgroundColor: Color.fromARGB(255, 237, 213, 229),
                    enterBottomSheetDuration: Duration(milliseconds: 150),
                  );
                },
                padding: EdgeInsets.only(left: 5),
                constraints: BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                icon: Icon(UIcons.fibspencil))
          ]),
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
                      return Text(
                        userData.email,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1,
                            color: Color.fromRGBO(152, 151, 151, 1)),
                      );
                    }
                  })),
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
                        rating: userData.rating,
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
                padding: EdgeInsets.fromLTRB(10, 10, 35, 10),
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
                                height: 84,
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
                              fontSize: 14,
                              height: 1.5,
                              color: Color.fromRGBO(78, 78, 78, 1)),
                        );
                      }
                    })),
          )),
      Positioned(
          right: 3,
          top: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            child: Container(
              color: Color.fromRGBO(217, 217, 217, 1),
              width: 30,
              height: 30,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.bottomSheet(
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Enter your description below:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextField(
                                    maxLength: 80,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    maxLines: 4,
                                    controller: controller.descriptionC,
                                    decoration: const InputDecoration(
                                      label: Text(
                                        "Description",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                152, 151, 151, 1)),
                                      ),
                                      border: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  )),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  controller.changeDescription();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(135, 45),
                                  elevation: 0,
                                  backgroundColor:
                                      Color.fromARGB(255, 118, 171, 218),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: "Inter"),
                                ),
                                child: const Text("Submit"),
                              ),
                            ],
                          )),
                      isScrollControlled: true,
                      backgroundColor: Color.fromARGB(255, 237, 213, 229),
                      enterBottomSheetDuration: Duration(milliseconds: 150),
                    );
                  },
                  icon: Icon(UIcons.fibspencil)),
            ),
          ))
    ]);
  }

  Widget albumInfo(Future<List<card.Card>> albumData) {
    return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, // Thickness
            height: 1,
            color: Color.fromRGBO(202, 196, 208, 1),
          ),
          SizedBox.fromSize(
            size: Size(5, 5),
          ),
          Text("Album",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              )),
          SizedBox.fromSize(
            size: Size(5, 5),
          ),
          albumCardCollection(albumData)
        ]));
  }

  Widget albumCardCollection(Future<List<card.Card>> albumData) {
    return FutureBuilder(
        future: albumData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                width: double.infinity,
                height: 340,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 0.606,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 150.9),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return loadingAlbumCard();
                  },
                ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            List<card.Card> albumData = snapshot.data!;
            return Container(
                width: double.infinity,
                height: 340,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 0.606,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 150.9),
                  itemCount: albumData.length < 20
                      ? albumData.length + 1
                      : albumData.length,
                  itemBuilder: (context, index) {
                    if (index < albumData.length) {
                      return albumCard(albumData[index]);
                    } else {
                      return newAlbumCard();
                    }
                  },
                ));
          }
        });
  }

  Widget albumCard(card.Card cardData) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.46),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 2),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image(
                      image: NetworkImage(cardData.image),
                    )),
              ),
              Text(
                cardData.cardName,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(78, 78, 78, 1)),
              ),
              cardExpansionData(cardData, controller.getExpansionData(cardData))
            ],
          ),
        ));
  }

  Widget loadingAlbumCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 0.46),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 2),
              child: Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 217, 217, 217),
                highlightColor: Color.fromARGB(255, 255, 255, 255),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: double.infinity,
                    height: 135,
                    color: Color.fromARGB(255, 217, 217, 217),
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Color.fromARGB(255, 217, 217, 217),
              highlightColor: Color.fromARGB(255, 255, 255, 255),
              child: Container(
                width: 100,
                height: 16,
                color: Color.fromARGB(255, 217, 217, 217),
              ),
            ),
            SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Color.fromARGB(255, 217, 217, 217),
              highlightColor: Color.fromARGB(255, 255, 255, 255),
              child: Container(
                width: 80,
                height: 12,
                color: Color.fromARGB(255, 217, 217, 217),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newAlbumCard() {
    return InkWell(
        onTap: () {
          Get.bottomSheet(
            Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select an expansion",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FutureBuilder(
                            future: controller.expansionData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Shimmer.fromColors(
                                  baseColor: Color.fromARGB(255, 217, 217, 217),
                                  highlightColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: DropdownMenu(
                                          dropdownMenuEntries: [])),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('No data found');
                              } else {
                                List<Expansion> expansionData = snapshot.data!;
                                return ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: DropdownMenu(
                                      width: double.infinity,
                                      menuHeight: 200,
                                      dropdownMenuEntries: expansionData
                                          .map((expansion) =>
                                              DropdownMenuEntry<String>(
                                                value: expansion.expansionCode,
                                                label: expansion.expansionName,
                                              ))
                                          .toList(),
                                    ));
                              }
                            })),
                    SizedBox(height: 20),
                    Text(
                      "You can add a new card to your album by clicking on the plus icon.",
                      style: TextStyle(
                          fontSize: 14, color: Color.fromRGBO(78, 78, 78, 1)),
                    ),
                  ],
                )),
            isScrollControlled: true,
            backgroundColor: Color.fromARGB(255, 237, 213, 229),
            enterBottomSheetDuration: Duration(milliseconds: 150),
          );
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Color.fromRGBO(255, 255, 255, 0.46),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: DottedBorder(
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        color: Color.fromRGBO(78, 78, 78, 1),
                        strokeWidth: 2,
                        dashPattern: [
                          4,
                          4,
                        ],
                        radius: Radius.circular(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: double.infinity,
                            height: 135,
                            child: Icon(
                              UIcons.fibsplus,
                              size: 40,
                              color: Color.fromRGBO(78, 78, 78, 1),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 4),
                  Container(
                    child: Text(
                      "Add New Card",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(78, 78, 78, 1)),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget cardExpansionData(
      card.Card cardData, Future<Expansion> expansionData) {
    return FutureBuilder(
        future: expansionData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 217, 217, 217),
                highlightColor: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: 8,
                        color: Color.fromARGB(255, 217, 217, 217),
                      ),
                    )));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            Expansion expansion = snapshot.data!;
            return Text(
              "${expansion.expansionCode} ${cardData.numberInExpansion}/${expansion.printedTotal}",
              style: TextStyle(
                  fontSize: 10,
                  color: Color.fromRGBO(123, 123, 123, 1),
                  fontWeight: FontWeight.bold,
                  height: 0.8),
            );
          }
        });
  }

  Widget friendsList(Future<List<FriendLink>> friendList) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  decoration: const InputDecoration(
                    label: Text(
                      "Search for friends",
                      style: TextStyle(color: Color.fromRGBO(152, 151, 151, 1)),
                    ),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ))),
        Container(
          width: double.infinity,
          height: 1,
          color: Color.fromRGBO(202, 196, 208, 1),
        ),
        FutureBuilder(
            future: friendList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                    height: 580,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return friendCardLoading();
                      },
                    ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data found');
              } else {
                List<FriendLink> friendList = snapshot.data!;
                return SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: friendList.length,
                      itemBuilder: (context, index) {
                        return friendCard(friendList[index]);
                      },
                    ));
              }
            })
      ],
    );
  }

  Widget friendCard(FriendLink friendLink) {
    String foreignId = friendLink.userId == controller.user.id
        ? friendLink.friendId
        : friendLink.userId;

    return FutureBuilder(
        future: controller.getFriendData(foreignId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return friendCardLoading();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            UserData friendData = snapshot.data!;
            if (friendLink.status == Status.Linked) {
              return friendCardDetailsAccepted(friendLink, friendData);
            } else {
              if (friendLink.userId == controller.user.id) {
                return friendCardDetailsOutgoing(friendData);
              } else {
                return friendCardDetailsIncoming(friendData);
              }
            }
          }
        });
  }

  Widget friendCardLoading() {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
              child: Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 217, 217, 217),
                highlightColor: Color.fromARGB(255, 255, 255, 255),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromARGB(255, 217, 217, 217),
                ),
              )),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 11,
              ),
              Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 217, 217, 217),
                highlightColor: Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  width: 100,
                  height: 16,
                  color: Color.fromARGB(255, 217, 217, 217),
                ),
              ),
              SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Color.fromARGB(255, 217, 217, 217),
                highlightColor: Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  width: 150,
                  height: 12,
                  color: Color.fromARGB(255, 217, 217, 217),
                ),
              ),
            ],
          )
        ]),
        Container(
          width: double.infinity,
          height: 1,
          color: Color.fromRGBO(202, 196, 208, 1),
        )
      ]),
    );
  }

  Widget friendCardDetailsAccepted(FriendLink linkInfo, UserData friendData) {
    return InkWell(
        onTap: () {
          Get.toNamed("/foreignprofile", arguments: friendData.userId);
        },
        child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Stack(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(friendData
                                .profilePicture ??
                            'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                      )),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 11,
                      ),
                      Text(
                        friendData.userName ?? 'No Name',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(78, 78, 78, 1)),
                      ),
                      Text(
                        friendData.description != null
                            ? '"${friendData.description}"'
                            : 'No description',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color.fromRGBO(120, 120, 120, 1),
                            height: 0.8),
                      ),
                    ],
                  )
                ]),
                Positioned(
                    right: 0,
                    top: 23,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                //controller.acceptFriendRequest(friendData.userId);
                                Get.bottomSheet(
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Are you sure you want to remove ${friendData.userName} from your friends list?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  controller.deleteFriend(
                                                      linkInfo.userId,
                                                      linkInfo.friendId);
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(135, 45),
                                                  elevation: 0,
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      fontFamily: "Inter"),
                                                ),
                                                child: const Text("Remove"),
                                              ),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(135, 45),
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 118, 171, 218),
                                                  foregroundColor: Colors.white,
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      fontFamily: "Inter"),
                                                ),
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                  backgroundColor: Color.fromARGB(
                                      255, 237, 213, 229),
                                );
                              },
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(5),
                              icon: Icon(UIcons.fibstrash),
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        )))
              ]),
              Container(
                width: double.infinity,
                height: 1,
                color: Color.fromRGBO(202, 196, 208, 1),
              )
            ])));
  }

  Widget friendCardDetailsIncoming(UserData friendData) {
    return Container(
        color: Color.fromARGB(235, 235, 235, 235),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(friendData.profilePicture ??
                        'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                  )),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    friendData.userName ?? 'No Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(78, 78, 78, 1)),
                  ),
                  Text(
                    "Has sent you a friend request",
                    style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(120, 120, 120, 1),
                        height: 0.8),
                  ),
                ],
              )
            ]),
            Positioned(
                right: 0,
                top: 23,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.acceptFriend(friendData.userId);
                          },
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(5),
                          icon: Icon(UIcons.fibscheck),
                          color: Colors.green,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.cancelFriend(friendData.userId);
                          },
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(5),
                          icon: Icon(UIcons.fibscross),
                          color: Colors.red,
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    )))
          ]),
          Container(
            width: double.infinity,
            height: 1,
            color: Color.fromRGBO(202, 196, 208, 1),
          )
        ]));
  }

  Widget friendCardDetailsOutgoing(UserData friendData) {
    return Container(
        color: Color.fromARGB(235, 235, 235, 235),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(friendData.profilePicture ??
                        'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg'),
                  )),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 11,
                  ),
                  Text(
                    friendData.userName ?? 'No Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(78, 78, 78, 1)),
                  ),
                  Text(
                    "Has not accepted your friend request yet",
                    style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(120, 120, 120, 1),
                        height: 0.8),
                  ),
                ],
              )
            ]),
          ]),
          Container(
            width: double.infinity,
            height: 1,
            color: Color.fromRGBO(202, 196, 208, 1),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    controller.userData = controller.getProfileData().obs;
    controller.albumData = controller.getAlbumData().obs;
    controller.expansionData = controller.getAllExpansions();
    controller.friendList = controller.getFriends().obs;
    controller.subscribeToFriendChanges();

    return Scaffold(
        drawer: Hamburguesa(),
        appBar: AppBar(
          title: const Text('Profile & Friends',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              )),
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          centerTitle: true,
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
                      Tab(
                        text: "Friends",
                        icon: Icon(UIcons.fibsusers),
                      )
                    ],
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Inter"),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    Obx(() => Column(
                          children: [
                            profileInfo(controller.userData.value),
                            albumInfo(controller.albumData.value)
                          ],
                        )),
                    Obx(() => friendsList(controller.friendList.value)),
                  ])),
                ]))));
  }
}

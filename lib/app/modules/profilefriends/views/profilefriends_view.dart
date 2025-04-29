import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
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

import '../../../../generated/locales.g.dart';
import '../../../data/models/album.dart';
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
                      userData.userName ??
                          LocaleKeys.profile_noInfo_username.tr,
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
                              LocaleKeys.profile_modify_enterUsername.tr,
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
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    label: Text(
                                      LocaleKeys.profile_textBox_username.tr,
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
                              child: Text(LocaleKeys.profile_submit.tr),
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
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          '${userData.description != null ? '"${userData.description}"' : LocaleKeys.profile_noInfo_description.tr}\n\n\n',
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
                                LocaleKeys.profile_modify_enterDescription.tr,
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
                                    decoration: InputDecoration(
                                      label: Text(
                                        LocaleKeys
                                            .profile_textBox_description.tr,
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

  Widget albumInfo(Future<List<Album>> albumData) {
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
          Row(children: [
            Text(LocaleKeys.profile_album.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(78, 78, 78, 1),
                )),
            IconButton(
              onPressed: () {
                controller.editMode.value =
                    !controller.editMode.value; // Toggle edit mode
              },
              icon: controller.editMode.value
                  ? Icon(UIcons.fibspencilslash)
                  : Icon(UIcons.fibspencil),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.only(left: 5),
              constraints: BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]),
          SizedBox.fromSize(
            size: Size(5, 5),
          ),
          albumCardCollection(albumData)
        ]));
  }

  Widget albumCardCollection(Future<List<Album>> albumData) {
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
                    return albumCardLoading();
                  },
                ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            List<Album> albumData = snapshot.data!;
            return Container(
                width: double.infinity,
                height: 340,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 0.6,
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

  Widget albumCard(Album albumData) {
    return FutureBuilder(
        future: controller.getAlbumCardData(albumData.cardId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return albumCardLoading();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found');
          } else {
            card.Card cardData = snapshot.data!;
            return albumCardDetails(cardData, albumData.albumCardId);
          }
        });
  }

  Widget albumCardDetails(card.Card cardData, int albumCardId) {
    return Stack(children: [
      ClipRRect(
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
                      child: FancyShimmerImage(
                        imageUrl: cardData.image,
                        boxFit: BoxFit.cover,
                        width: double.infinity,
                        height: 140,
                      )),
                ),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      cardData.cardName,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(78, 78, 78, 1)),
                    )),
                cardExpansionData(
                    cardData, controller.getExpansionData(cardData)),
                SizedBox(height: 10),
              ],
            ),
          )),
      Obx(() => Positioned(
          right: 5,
          top: 5,
          child: AnimatedOpacity(
              opacity: controller.editMode.value == true ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: IgnorePointer(
                  ignoring: !controller.editMode.value,
                  child: albumCardDeleteButton(albumCardId))))),
    ]);
  }

  Widget albumCardDeleteButton(int albumCardId) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Container(
            color: Color.fromRGBO(244, 67, 54, 0.9),
            width: 27,
            height: 27,
            child: IconButton(
                color: Colors.white,
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.bottomSheet(
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LocaleKeys.profile_modify_deleteCard.tr,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    controller.deleteCard(albumCardId);
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
                                  child: Text(LocaleKeys.profile_album.tr),
                                ),
                              ],
                            ))),
                    isScrollControlled: true,
                    backgroundColor: Color.fromARGB(255, 237, 213, 229),
                    enterBottomSheetDuration: Duration(milliseconds: 150),
                  );
                },
                icon: Icon(UIcons.fibstrash))));
  }

  Widget albumCardLoading() {
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
                    height: 140,
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
                      LocaleKeys.profile_modify_enterCardNo.tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              maxLength: 5,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              controller: controller.expansionCodeC,
                              decoration: InputDecoration(
                                label: Text(
                                  LocaleKeys.profile_textBox_expansion.tr,
                                  style: TextStyle(
                                      color: Color.fromRGBO(152, 151, 151, 1)),
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              controller: controller.cardNoC,
                              decoration: InputDecoration(
                                label: Text(
                                  LocaleKeys.profile_textBox_cardNo.tr,
                                  style: TextStyle(
                                      color: Color.fromRGBO(152, 151, 151, 1)),
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              controller: controller.printedTotalC,
                              decoration: InputDecoration(
                                label: Text(
                                  LocaleKeys.profile_textBox_printedTotal.tr,
                                  style: TextStyle(
                                      color: Color.fromRGBO(152, 151, 151, 1)),
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          )
                        ])),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.addCard();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(135, 45),
                        elevation: 0,
                        backgroundColor: Color.fromARGB(255, 118, 171, 218),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "Inter"),
                      ),
                      child: Text(LocaleKeys.profile_addCard.tr),
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
                  Text(
                    LocaleKeys.profile_addNewCard.tr,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(78, 78, 78, 1)),
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
    return FutureBuilder(
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
            if (friendList.isEmpty) {
              return Container(
                  height: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text(LocaleKeys.friends_noFriends.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(78, 78, 78, 1))))));
            } else {
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
          }
        });
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
                        friendData.userName ??
                            LocaleKeys.friends_noInfo_username.tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(78, 78, 78, 1)),
                      ),
                      Text(
                        friendData.description != null
                            ? '"${friendData.description}"'
                            : LocaleKeys.friends_noInfo_description.tr,
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
                                            LocaleKeys
                                                .friends_removeFriend_prompt
                                                .trParams({
                                              "friend": friendData.userName
                                            }),
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
                                                child: Text(LocaleKeys
                                                    .friends_removeFriend_remove
                                                    .tr),
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
                                                child: Text(LocaleKeys
                                                    .friends_removeFriend_cancel
                                                    .tr),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                  backgroundColor:
                                      Color.fromARGB(255, 237, 213, 229),
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
                    friendData.userName ??
                        LocaleKeys.friends_noInfo_username.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(78, 78, 78, 1)),
                  ),
                  Text(
                    LocaleKeys.friends_incomingRequest.tr,
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
                    friendData.userName ??
                        LocaleKeys.friends_noInfo_username.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color.fromRGBO(78, 78, 78, 1)),
                  ),
                  Text(
                    LocaleKeys.friends_outgoingRequest.tr,
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

  Widget friendBottomSheet() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.profile_modify_enterFriendCode.tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: controller.friendcodeC,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text(
                      LocaleKeys.profile_textBox_friendCode.tr,
                      style: TextStyle(color: Color.fromRGBO(152, 151, 151, 1)),
                    ),
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await controller.sendFriendRequest();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(135, 45),
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 118, 171, 218),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: "Inter"),
              ),
              child: Text(LocaleKeys.profile_submit.tr),
            ),
          ],
        ));
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
          leading: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: const Icon(
                  UIcons.fibsmenuburger,
                  size: 35,
                  color: Color.fromRGBO(78, 78, 78, 1),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          title: Text(LocaleKeys.profile_title.tr,
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              )),
          backgroundColor: Color.fromARGB(255, 237, 213, 229),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(
                  UIcons.fibsuseradd,
                  size: 35,
                  color: Color.fromRGBO(78, 78, 78, 1),
                ),
                onPressed: () => Get.bottomSheet(friendBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Color.fromARGB(255, 237, 213, 229),
                    enterBottomSheetDuration: Duration(milliseconds: 150)),
              ),
            )
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
                        text: LocaleKeys.profile_profile.tr,
                        icon: Icon(UIcons.fibsuser),
                      ),
                      Tab(
                        text: LocaleKeys.profile_friends.tr,
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

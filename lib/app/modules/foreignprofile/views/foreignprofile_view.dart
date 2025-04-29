import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:themewstore/app/modules/generic/sidebar/hamburguesa.dart';

import '../../../../generated/locales.g.dart';
import '../../../../uicon.dart';
import '../../../data/models/album.dart';
import '../../../data/models/expansion.dart';
import '../../../data/models/userData.dart';
import '../controllers/foreignprofile_controller.dart';
import 'package:themewstore/app/data/models/card.dart' as card;

class ForeignprofileView extends GetView<ForeignprofileController> {
  const ForeignprofileView({super.key});

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
          SizedBox(height: 5),
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
                          height: 0.9),
                    );
                  }
                }),
          ]),
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
                          '${userData.description != null ? '"${userData.description}"' : LocaleKeys.profile_noInfo_descriptionForeign.tr}\n\n\n',
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color.fromRGBO(78, 78, 78, 1)),
                        );
                      }
                    })),
          )),
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
            if (albumData.isEmpty) {
              return Container(
                  height: 420,
                  child: Center(
                    child: Text(
                      LocaleKeys.profile_noCardsInAlbum.tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(78, 78, 78, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ));
            } else {
              return Container(
                  width: double.infinity,
                  height: 420,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        maxCrossAxisExtent: 150.9),
                    itemCount: albumData.length,
                    itemBuilder: (context, index) {
                      return albumCard(albumData[index]);
                    },
                  ));
            }
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
    ]);
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

  @override
  Widget build(BuildContext context) {
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
        title: FutureBuilder<UserData>(
          future: controller.friendData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                LocaleKeys.profile_titleForeign.trParams({
                  'user': snapshot.data!.userName ??
                      LocaleKeys.profile_noInfo_username.tr,
                }),
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(78, 78, 78, 1),
                ),
              );
            }
            return const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 237, 213, 229),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                UIcons.fibscross,
                size: 35,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
              onPressed: () => Get.back(),
            ),
          )
        ],
      ),
      body: Container(
          color: const Color.fromARGB(255, 237, 213, 229),
          child: Column(
            children: [
              profileInfo(controller.friendData),
              albumInfo(controller.albumData)
            ],
          )),
    );
  }
}

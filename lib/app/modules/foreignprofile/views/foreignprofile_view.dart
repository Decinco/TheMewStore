import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../uicon.dart';
import '../../../data/models/expansion.dart';
import '../../../data/models/userData.dart';
import '../controllers/foreignprofile_controller.dart';
import 'package:themewstore/app/data/models/card.dart' as card;

class ForeignprofileView extends GetView<ForeignprofileController> {
  const ForeignprofileView({super.key});

  Widget profileInfo(Future<UserData> userData) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 213, 229),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SizedBox(height: 20),
        Row(
          children: [
            profilePicture(userData),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
              child: Container(
                width: 1,
                height: 110,
                color: const Color.fromRGBO(202, 196, 208, 1),
              ),
            ),
            profileStats(userData)
          ],
        ),
        const SizedBox(height: 10),
        profileDescription(userData),
        const SizedBox(height: 20),
      ]),
    );
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
                    padding: const EdgeInsets.all(5),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 217, 217, 217),
                      highlightColor: const Color.fromARGB(255, 255, 255, 255),
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg',
                        ),
                        radius: 50,
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.error),
                  );
                } else if (!snapshot.hasData) {
                  return const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person),
                  );
                } else {
                  final user = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.profilePicture ??
                            'https://efozsdbswdnjwwgdbmzo.supabase.co/storage/v1/object/public/profilepictures//default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714-1760973665.jpg',
                      ),
                      radius: 50,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        FutureBuilder(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 217, 217, 217),
                highlightColor: const Color.fromARGB(255, 255, 255, 255),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 100,
                    height: 10,
                    color: const Color.fromARGB(255, 217, 217, 217),
                  ),
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Text(
                'Unknown',
                style: TextStyle(
                  color: Color.fromRGBO(152, 151, 151, 1),
                  fontSize: 12,
                  height: 0.8,
                ),
              );
            } else {
              return Text(
                snapshot.data!.userCode,
                style: const TextStyle(
                  color: Color.fromRGBO(152, 151, 151, 1),
                  fontSize: 12,
                  height: 0.8,
                ),
              );
            }
          },
        ),
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
            const SizedBox(width: 5),
            FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 217, 217, 217),
                    highlightColor: const Color.fromARGB(255, 255, 255, 255),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 100,
                        height: 20,
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Text(
                    'Unknown User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data!.userName ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: FutureBuilder(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 217, 217, 217),
                      highlightColor: const Color.fromARGB(255, 255, 255, 255),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: 100,
                          height: 12,
                          color: const Color.fromARGB(255, 217, 217, 217),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text(
                      'email@hidden.com',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1,
                        color: Color.fromRGBO(152, 151, 151, 1),
                      ),
                    );
                  } else {
                    String censorEmail(String email) {
                      if (email.isEmpty) return '';
                      final parts = email.split('@');
                      if (parts.length != 2) return email;

                      final name = parts[0];
                      final domain = parts[1];

                      if (name.length <= 2) {
                        return '${name[0]}***@$domain';
                      } else {
                        return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
                      }
                    }

                    return Text(
                      censorEmail(snapshot.data!.email),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1,
                        color: Color.fromRGBO(152, 151, 151, 1),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(
              UIcons.fibsglobe,
              size: 30,
              color: Color.fromRGBO(78, 78, 78, 1),
            ),
            const SizedBox(width: 5),
            FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 217, 217, 217),
                    highlightColor: const Color.fromARGB(255, 255, 255, 255),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 100,
                        height: 16,
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.region.isEmpty) {
                  return const Text(
                    'No info', // Cambiado de 'Unknown' a 'No info'
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(78, 78, 78, 1),
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data!.region,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(78, 78, 78, 1),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              UIcons.fibsmessagestar,
              size: 30,
              color: Color.fromRGBO(78, 78, 78, 1),
            ),
            const SizedBox(width: 2),
            FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 217, 217, 217),
                    highlightColor: const Color.fromARGB(255, 255, 255, 255),
                    child: StarRating(
                      size: 24,
                      color: Color.fromRGBO(78, 78, 78, 1),
                      borderColor: Color.fromRGBO(78, 78, 78, 1),
                      starCount: 5,
                      allowHalfRating: true,
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return StarRating(
                    size: 24,
                    rating: 0,
                    color: Color.fromRGBO(78, 78, 78, 1),
                    borderColor: Color.fromRGBO(78, 78, 78, 1),
                    starCount: 5,
                    allowHalfRating: true,
                  );
                } else {
                  return StarRating(
                    size: 24,
                    rating: snapshot.data!.rating.toDouble(),
                    color: const Color.fromRGBO(78, 78, 78, 1),
                    borderColor: const Color.fromRGBO(78, 78, 78, 1),
                    starCount: 5,
                    allowHalfRating: true,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget albumInfo(Future<List<card.Card>> albumData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromRGBO(202, 196, 208, 1),
          ),
          const SizedBox(height: 5),
          const Text(
            "Album",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(78, 78, 78, 1),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 213, 229),
              borderRadius: BorderRadius.circular(10),
            ),
            child: albumCardCollection(albumData),
          ),
        ],
      ),
    );
  }

  Widget albumCardCollection(Future<List<card.Card>> albumData) {
    return FutureBuilder(
      future: albumData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 217, 217, 217),
            highlightColor: const Color.fromARGB(255, 255, 255, 255),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: double.infinity,
                height: 100,
                color: const Color.fromARGB(255, 237, 213, 229),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading album: ${snapshot.error}',
              style: const TextStyle(
                color: Color.fromRGBO(78, 78, 78, 1),
                fontSize: 16,
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 213, 229),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'No cards in album yet',
                style: TextStyle(
                  color: Color.fromRGBO(78, 78, 78, 1),
                  fontSize: 16,
                ),
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 340,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 213, 229),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 0.606,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 150,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return albumCard(snapshot.data![index]);
              },
            ),
          );
        }
      },
    );
  }
  
  Widget albumCard(card.Card cardData) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 213, 229),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image(
                  image: NetworkImage(cardData.image),
                ),
              ),
            ),
            Text(
              cardData.cardName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(78, 78, 78, 1),
              ),
            ),
            cardExpansionData(cardData, controller.getExpansionData(cardData)),
          ],
        ),
      ),
    );
  }

  Widget cardExpansionData(
      card.Card cardData,
      Future<Expansion> expansionData,
      ) {
    return FutureBuilder(
      future: expansionData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 217, 217, 217),
            highlightColor: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: double.infinity,
                  height: 8,
                  color: const Color.fromARGB(255, 217, 217, 217),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Text(
            'Unknown expansion',
            style: TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(123, 123, 123, 1),
              fontWeight: FontWeight.bold,
              height: 0.8,
            ),
          );
        } else {
          final expansion = snapshot.data!;
          return Text(
            "${expansion.expansionCode} ${cardData.numberInExpansion}/${expansion.printedTotal}",
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(123, 123, 123, 1),
              fontWeight: FontWeight.bold,
              height: 0.8,
            ),
          );
        }
      },
    );
  }

  Widget profileDescription(Future<UserData> userData) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 35, 10),
              child: FutureBuilder(
                future: userData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 217, 217, 217),
                      highlightColor: const Color.fromARGB(255, 255, 255, 255),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          color: const Color.fromARGB(255, 217, 217, 217),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text(
                      'No description available',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    );
                  } else {
                    return Text(
                      '${snapshot.data!.description != null ? '"${snapshot.data!.description}"' : 'This user has no description yet.'}\n\n\n',
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color.fromRGBO(78, 78, 78, 1),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => FutureBuilder<UserData>(
          future: controller.friendData.value,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                '${snapshot.data!.userName ?? 'User'}\'s Profile',
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
        )),
        backgroundColor: const Color.fromARGB(255, 237, 213, 229),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(UIcons.fibsmenuburger),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(UIcons.fibscross),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 237, 213, 229),
        child: Obx(() {
          return FutureBuilder<UserData>(
            future: controller.friendData.value,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading profile: ${userSnapshot.error}',
                    style: const TextStyle(
                      color: Color.fromRGBO(78, 78, 78, 1),
                    ),
                  ),
                );
              }
              if (!userSnapshot.hasData) {
                return const Center(
                  child: Text(
                    'No profile data found',
                    style: TextStyle(
                      color: Color.fromRGBO(78, 78, 78, 1),
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    profileInfo(controller.friendData.value),
                    albumInfo(controller.albumData.value),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
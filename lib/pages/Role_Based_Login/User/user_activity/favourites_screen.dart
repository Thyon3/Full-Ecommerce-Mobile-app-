import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/item_details.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/favourite_provider.dart';

class FavouritesScreen extends ConsumerWidget {
  FavouritesScreen({super.key});

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Your Favourites',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        body:
            userId == null
                ? Center(child: Text('Login first to see Your Favourites'))
                : StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('userFavourite')
                          .doc(userId)
                          .collection('favourites')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final favouriteIds = snapshot.data!.docs;
                    if (favouriteIds.isEmpty) {
                      return Center(child: Text('No favourite items so far'));
                    }

                    return FutureBuilder(
                      future: Future.wait(
                        favouriteIds.map(
                          (doc) =>
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(doc.id)
                                  .get(),
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final favouriteItems =
                            snapshot.data!.where((doc) => doc.exists).toList();

                        if (favouriteItems.isEmpty) {
                          return CircularProgressIndicator();
                        }

                        return ListView.builder(
                          itemCount: favouriteItems.length,
                          itemBuilder: (context, index) {
                            final finalItem = favouriteItems[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 40,
                                      top: 20,
                                      right: 20,
                                    ),
                                    height: size.height * 0.13,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        153,
                                        248,
                                        242,
                                        242,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                finalItem['image'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: 30,
                                            top: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                finalItem['name'],
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.w600,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${finalItem['category']} fashion',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .inverseSurface,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '\$${finalItem['price'].toString()}',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: size.width * 0.8,
                                    bottom: 10,
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(favouriteProvider.notifier)
                                            .toggleFavourite(finalItem);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/Admin/screens/add_items.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminHomeScreenState();
  }
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthService _authService = AuthService();
  final CollectionReference items = FirebaseFirestore.instance.collection(
    'items',
  );
  String? selectedCategory;
  List<String> categories = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: color,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          padding: EdgeInsets.all(6),
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _editItem(String? id) {
    // Implement edit functionality
  }

  void _deleteItem(String? id) {
    // Implement delete functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Your Uploaded Items',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      _authService.signOut();
                    },
                    child: Icon(Icons.exit_to_app_outlined),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream:
                      items
                          .where('uploadedBy', isEqualTo: uid)
                          .where('category', isEqualTo: selectedCategory)
                          .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('An Error has occurred loading the items!'),
                      );
                    }

                    final documents = snapshot.data?.docs ?? [];

                    if (documents.isEmpty) {
                      return Center(child: Text('No items are uploaded'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final mapItems =
                            documents[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Theme.of(
                                        context,
                                      ).colorScheme.surface.withOpacity(0.8),
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant
                                          .withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      // Image Container
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: mapItems['image'],
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.1),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.photo_camera,
                                                          size: 40,
                                                          color: Theme.of(
                                                                context,
                                                              )
                                                              .colorScheme
                                                              .onSurface
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                    ),
                                            fadeInDuration: Duration(
                                              milliseconds: 200,
                                            ),
                                            imageBuilder:
                                                (
                                                  context,
                                                  imageProvider,
                                                ) => Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            Colors.white
                                                                .withOpacity(
                                                                  0.95,
                                                                ),
                                                            BlendMode.dstATop,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Product Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mapItems['name'] ??
                                                  'Untitled Product',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '\$${mapItems['price']?.toStringAsFixed(2) ?? '0.00'}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimaryContainer,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondaryContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      mapItems['category']
                                                              ?.toString()
                                                              .toUpperCase() ??
                                                          'GENERAL',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.5,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onSecondaryContainer,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            // Admin Actions
                                            Row(
                                              children: [
                                                _buildActionButton(
                                                  context,
                                                  icon: Icons.edit,
                                                  color: Colors.blue,
                                                  onPressed:
                                                      () => _editItem(
                                                        mapItems['id'],
                                                      ),
                                                ),
                                                SizedBox(width: 8),
                                                _buildActionButton(
                                                  context,
                                                  icon: Icons.delete,
                                                  color: Colors.red,
                                                  onPressed:
                                                      () => _deleteItem(
                                                        mapItems['id'],
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItems()),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/Admin/models/add_items_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddItemNotifier extends StateNotifier<AddItemsModel> {
  AddItemNotifier() : super(AddItemsModel());

  // lets first create a collection in our firestore database to store the itmes

  CollectionReference items = FirebaseFirestore.instance.collection('items');
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'Category',
  );

  // for picking an image

  void pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        state = state.copyWith(iamgePath: File(pickedFile.path));
      }
    } catch (e) {
      throw Exception('failed picking image:$e');
    }
  }

  // setSelectedCategory the selected category
  void setSelectedCategory(String selectedCategory) {
    state = state.copyWith(selectedCategory: selectedCategory);
  }

  //for adding and removing size

  void addSize(String size) {
    state = state.copyWith(availableSize: [...state.availableSize!, size]);
  }

  // for removing an availbale size

  void removeSize(String size) {
    state = state.copyWith(
      availableSize: state.availableSize!.where((s) => s != size).toList(),
    );
  }

  // for adding a color for the item

  void addColor(String color) {
    state = state.copyWith(availableColors: [...state.availableColors!, color]);
  }

  // for removing the color
  void removeColor(String color) {
    state = state.copyWith(
      availableColors: state.availableColors!.where((c) => c != color).toList(),
    );
  }

  // for toggline either there is a discount or not

  void toggleDiscount(bool? isDiscounted) {
    state = state.copyWith(isDiscounted: isDiscounted);
  }

  // for setSelectedCategoryting the percentage discount

  void setDiscountPercentage(String dicount) {
    state = state.copyWith(discountPercentage: dicount);
  }

  // fetching the categories

  Future<void> fetchingCategories() async {
    try {
      // fist get the snaphshot  of the collection from firestore
      QuerySnapshot snapshot = await categories.get();

      List<String> fetchedCategories =
          snapshot.docs.map((item) => item['name'] as String).toList();
      // now update the state by adding the fecthedCategories
      state = state.copyWith(categories: fetchedCategories);
    } catch (e) {
      throw Exception('failed to fectch category $e');
    }
  }

  // upload images to supabase and return the public URL
  Future<String> uploadImageToSupabase(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final bucket = Supabase.instance.client.storage.from('product-images');

    final response = await bucket.upload('images/$fileName.jpg', imageFile);

    if (response.isEmpty) {
      throw Exception('Failed to upload image');
    }

    // Get the public URL
    final publicURL = bucket.getPublicUrl('images/$fileName.jpg');

    return publicURL;
  }

  // save and upload all itmes to firebase storage

  Future<void> saveAndUploadItems(String price, String name) async {
    // fist check whether all the fields are not null or not

    if (price.isEmpty ||
        name.isEmpty ||
        state.availableColors == null ||
        state.availableSize == null ||
        state.iamgePath == null ||
        state.isDiscounted && state.discountPercentage == null ||
        state.selectedCategory == null) {
      throw Exception(
        'please fill all the inputs and try again${state.availableSize}${name + price}${state.availableColors}${state.iamgePath}${state.isDiscounted}${state.selectedCategory}${state.discountPercentage}',
      );
    }

    // if all of the inputs required then start uploading the items to firebase

    // sicne we are starting to upload make isLoading true

    state = state.copyWith(isLoading: true);
    try {
      // first upload the image
      // final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final reference = FirebaseStorage.instance.ref().child(
      //   'images/$fileName',
      // );

      // print('image path: ${state.iamgePath}');
      // final uploadTask = await reference.putFile(File(state.iamgePath!));

      // // Wait for upload to complete properly
      // if (uploadTask.state != TaskState.success) {
      //   throw Exception('Image upload failed.');
      // }

      // get the image url if the upload is succesfull.

      // final imageUrl = await reference.getDownloadURL();

      // savae the items to the item collection on firestore
      final image = state.iamgePath;
      final imageUrl = await uploadImageToSupabase(image!);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await items.add({
        'name': name,
        'price': int.tryParse(price),
        'sizes': state.availableSize,
        'colors': state.availableColors,
        'image': imageUrl,
        'category': state.selectedCategory,
        'uploadedBy': uid,
        'isDiscounted': state.isDiscounted,
        'discountPercentage':
            state.isDiscounted ? int.tryParse(state.discountPercentage!) : 0,
      });
      // resetSelectedCategory the current state after uploading
      state = AddItemsModel();
    } catch (e) {
      throw Exception('failed to save the item $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final addItemProvider = StateNotifierProvider<AddItemNotifier, AddItemsModel>((
  ref,
) {
  return AddItemNotifier();
});

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thyecommercemobileapp/components/my%20_textfield.dart';
import 'package:thyecommercemobileapp/components/my_elevated_button.dart';
import 'package:thyecommercemobileapp/components/show_snackbar.dart';
import 'dart:io';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/Admin/controllers/add_item_provider.dart';

class AddItems extends ConsumerStatefulWidget {
  const AddItems({super.key});

  @override
  ConsumerState<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends ConsumerState<AddItems> {
  @override
  void initState() {
    super.initState();
    // 🔥 THIS FIXES YOUR ISSUE
    Future.microtask(
      () => ref.read(addItemProvider.notifier).fetchingCategories(),
    );
  }

  // text editing controllwers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // get the state and the notifier of the additems provider
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Add Items '), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // the child is the image if selected and a camera button if not selected
                  child:
                      state.iamgePath != null
                          ? GestureDetector(
                            onTap: () {
                              notifier.pickImage();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(state.iamgePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : state.isLoading
                          ? CircularProgressIndicator()
                          : IconButton(
                            onPressed: () {
                              notifier.pickImage();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              size: 35,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                ),
              ),

              SizedBox(height: 20),
              MyTextfield(controller: _nameController, labelText: 'Name'),
              SizedBox(height: 10),

              MyTextfield(controller: _priceController, labelText: 'Price'),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                items:
                    state.categories
                        .map(
                          (categoryElement) => DropdownMenuItem<String>(
                            value: categoryElement,
                            child: Text(categoryElement),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  notifier.setSelectedCategory(value.toString());
                },
                value:
                    state.selectedCategory != null &&
                            state.categories.contains(state.selectedCategory)
                        ? state.selectedCategory
                        : null,
                decoration: InputDecoration(
                  labelText: 'Choose a Category ',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Enter sizes(comma separated)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  notifier.addSize(value);
                  _sizeController.clear();
                },
              ),
              SizedBox(height: 10),
              // have the wrap widget
              Wrap(
                spacing: 8,
                children:
                    state.availableSize!
                        .map(
                          (size) => Chip(
                            label: Text(size),
                            onDeleted: () {
                              notifier.removeSize(size);
                            },
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Enter the colors(comma separated)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (value) => notifier.addColor(value),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children:
                    state.availableColors!
                        .map(
                          (colors) => Chip(
                            label: Text(colors),
                            onDeleted: () {
                              notifier.removeColor(colors);
                            },
                          ),
                        )
                        .toList(),
              ),

              // before we have the discount contollwer textfield we ahve to check either the item is discounted or not
              Row(
                children: [
                  Checkbox(
                    value: state.isDiscounted,
                    onChanged: (value) {
                      notifier.toggleDiscount(value);
                    },
                  ),
                  Text('is discounted'),
                ],
              ),
              if (state.isDiscounted)
                Column(
                  children: [
                    TextField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: 'Enter the discount percentage',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: notifier.setDiscountPercentage,
                    ),
                  ],
                ),
              SizedBox(height: 10),
              state.isLoading
                  ? CircularProgressIndicator()
                  : MyElevatedButton(
                    onTap: () async {
                      try {
                        await notifier.saveAndUploadItems(
                          _priceController.text,
                          _nameController.text,
                        );
                        showSnackbar(context, 'Item saved succefully!');
                        Navigator.pop(context);
                      } catch (e) {
                        showSnackbar(context, 'Error Saving the Item$e');
                      }
                    },
                    buttonText: 'Save Item',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

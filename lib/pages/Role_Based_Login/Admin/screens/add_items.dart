import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thyecommercemobileapp/components/my%20_textfield.dart';

class AddItems extends ConsumerWidget {
  AddItems({super.key});

  // text editing controllwers
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _sizeController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();

  final TextEditingController _discountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the state
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
                ),
              ),

              SizedBox(height: 20),
              MyTextfield(controller: _nameController, labelText: 'Name'),
              SizedBox(height: 10),

              MyTextfield(controller: _priceController, labelText: 'Price'),
              SizedBox(height: 10),

              MyTextfield(
                controller: _sizeController,
                labelText: 'size (comma separated)',
              ),
              SizedBox(height: 10),

              MyTextfield(
                controller: _colorController,
                labelText: 'Color (coma separated)',
              ),
              SizedBox(height: 10),

              MyTextfield(
                controller: _discountController,
                labelText: 'discount (%)',
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

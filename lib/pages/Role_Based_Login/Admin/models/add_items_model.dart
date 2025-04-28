import 'dart:io';

class AddItemsModel {
  final File? iamgePath;
  final String? name;
  final List<String>? availableSize;
  final List<String>? availableColors;
  final bool isDiscounted;
  final List<String> categories;
  final String? selectedCategory;
  final bool isLoading;
  final String? discountPercentage;

  AddItemsModel({
    this.iamgePath,
    this.name,
    this.availableSize = const [],
    this.availableColors = const [],
    this.isDiscounted = false,
    this.categories = const [],
    this.isLoading = false,
    this.discountPercentage,
    this.selectedCategory,
  });

  AddItemsModel copyWith({
    final File? iamgePath,
    final String? name,
    final List<String>? availableSize,
    final List<String>? availableColors,
    final bool? isDiscounted,
    final List<String>? categories,
    final String? selectedCategory,
    final bool? isLoading,
    final String? discountPercentage,
  }) {
    return AddItemsModel(
      categories: categories ?? this.categories,
      availableColors: availableColors ?? this.availableColors,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      iamgePath: iamgePath ?? this.iamgePath,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      availableSize: availableSize ?? this.availableSize,
    );
  }
}

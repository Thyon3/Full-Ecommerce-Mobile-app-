class CategoryModel {
  String name, imagePath;

  CategoryModel({required this.name, required this.imagePath});
}

final List<CategoryModel> categoriesList = [
  CategoryModel(name: 'Women', imagePath: 'assets/Model/CategoryWomen.png'),
  CategoryModel(name: 'Men', imagePath: 'assets/Model/CategoryMen.png'),
  CategoryModel(name: 'Teen', imagePath: 'assets/Model/CategoryTeen.png'),
  CategoryModel(name: 'Baby', imagePath: 'assets/Model/CategoryBaby.png'),
  CategoryModel(name: 'child', imagePath: 'assets/Model/girl.png'),
];

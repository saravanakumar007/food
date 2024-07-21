class CategoryModel {
  String? name;
  String? image;

  CategoryModel({this.name, this.image});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}

var categories = [
  CategoryModel(image: "appetiser.jpeg", name: "Appetiser"),
  CategoryModel(image: "bbq.jpeg", name: "Bbq"),
  CategoryModel(image: "beans.jpeg", name: "Beans Recipe"),
  CategoryModel(image: "breakfast.jpg", name: "Breakfast"),
  CategoryModel(image: "cake.jpeg", name: "Cake"),
  CategoryModel(image: "coffee.jpeg", name: "Coffee"),
  CategoryModel(image: "cookies.jpeg", name: "Cookies"),
  CategoryModel(image: "curry.jpeg", name: "Curry"),
  CategoryModel(image: "dessert.jpeg", name: "Dessert"),
  CategoryModel(image: "juice.jpeg", name: "Juice"),
  CategoryModel(image: "lunch.jpg", name: "Lunch"),
  CategoryModel(image: "pasta.jpeg", name: "Pasta"),
  CategoryModel(image: "pizza.jpeg", name: "Pizza"),
  CategoryModel(image: "salad.jpeg", name: "Salad"),
  CategoryModel(image: "seafood.jpeg", name: "Seafood"),
  CategoryModel(image: "soup.jpeg", name: "Soup")
];

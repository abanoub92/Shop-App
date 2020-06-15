import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import './product.dart';

class ProductProvider with ChangeNotifier {

  List<Product> products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductProvider({this.authToken, this.userId, this.products});

  /* get the list of products data */
  List<Product> get items {
    return products;
  }

  /* get the favorite list */
  Future<void> fetchFavorites() async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/products.json?auth=$authToken';
    final response = await http.get(url, headers: { 'isFavorite': 'true',});
    //notifyListeners();

    if (response.statusCode == 200){
      print(response.body.toString());
    }
  }
  List<Product> get favoriteItems{
    return products.where((prod) => prod.isFavorite).toList();
  }

  /* get product item by id */
  Product findById(String id){
    return products.firstWhere((prod) => prod.id == id);
  }

  //to add default value to parameter: add the param var in [bool filteredByUser = false]
  Future<void> fetchProductsList([bool filteredByUser = false]) async {
    final filterUrl = filteredByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://onlinestoreapp-a44eb.firebaseio.com/products.json?auth=$authToken&$filterUrl';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null){
        return;
      }
      
      //get the favorites products
      url = 'https://onlinestoreapp-a44eb.firebaseio.com/favorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          //check every product is a favorite
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false, //?? check if the product == null too
        ));
      });
      products = loadedProduct;
    } catch (error){
      print(error);
    }
  }

  /*
   * async convert the function from void to Furture<R>
   * return type (make the function runs on background thread).
   * 
   * await force the compiler to wait these lines of code
   * until the process is done and compile what cames next
   * (samply it take a place of then() function).
   */
  Future<void> addProduct(Product product) async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/products.json?auth=$authToken'; //.json added for firebase endpoint only
    
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),);
    
      final newProduct = Product(
          id: json.decode(response.body)['name'], 
          title: product.title, 
          description: product.description, 
          price: product.price, 
          imageUrl: product.imageUrl,
        );
      products.add(newProduct);   //add item to the end of the list
      //_items.insert(0, newProduct);  //add item to the start of the list
      notifyListeners();
    
    } catch (error){
      print(error);
      throw error;
    }

  }

  // Future<void> addProduct(Product product) {
  //   const url = 'https://onlinestoreapp-a44eb.firebaseio.com/products'; //.json added for firebase endpoint only
  //   return http.post(url, body: json.encode({
  //     'title': product.title,
  //     'description': product.description,
  //     'imageUrl': product.imageUrl,
  //     'price': product.price,
  //     'isFavorite': product.isFavorite,
  //   }),).then((response) {
  //     final newProduct = Product(
  //       id: json.decode(response.body)['name'], 
  //       title: product.title, 
  //       description: product.description, 
  //       price: product.price, 
  //       imageUrl: product.imageUrl,
  //     );
  //     _items.add(newProduct);   //add item to the end of the list
  //     //_items.insert(0, newProduct);  //add item to the start of the list
  //     notifyListeners();
  //   }).catchError((error){
  //     print(error);
  //     throw error;
  //   });
  // }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/products/$id.json?auth=$authToken';
    final prodIndex = products.indexWhere((product) => product.id == id);
    if (prodIndex >= 0){
      try {
        await http.patch(url, body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
        products[prodIndex] = newProduct;
        notifyListeners();
      } catch (error){
        print(error);
      }
    }else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/products/$id.json?auth=$authToken';
    // get the index of product in a list
    final existingProductIndex = products.indexWhere((product) => product.id == id); 
    // store the product in a memory (just in case).
    var existingProduct = products[existingProductIndex];
    // remove it from the list (but still stored in memory)
    products.removeWhere((product) => product.id == id);
    notifyListeners();

    // make a delete request from a server
    final response = await http.delete(url);
    //if delete operation is success delete the product from memory too.
    if (response.statusCode == 200){
      existingProduct = null;
    }else if (response.statusCode >= 400){
      // if it fail return the product to the list from memory
      products.insert(0, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }

}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {

  static const route_name = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;

  var _initValues = {'title': '', 'description': '', 'price': '', 'imageUrl': ''};

  var _editedProduct = Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');

  /*
   * update image preview widget
   * when image url text input lose the focus
   */
  void _updateImage(){
    if (!_imageUrlFocusNode.hasFocus){
      setState(() {}); 
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null){
      Provider.of<ProductProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
        .addProduct(_editedProduct);
      } catch(error){
        //we use await here to force finally method to stop excute
        //until the dialog is close then excute finally function 
        await showDialog(context: context, builder: (ctx){
          return AlertDialog(
            title: Text('An error occurred!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(), 
                child: Text('Okey'),
              ),
            ],
          );
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }
 
  /*
   Provider.of<ProductProvider>(context, listen: false).addProduct(_editedProduct)
      .catchError((error){
        showDialog(context: context, builder: (ctx){
          return AlertDialog(
            title: Text('An error occurred!'),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(), 
                child: Text('Okey'),
              ),
            ],
          );
        });
      })
      .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();   
      }); 
   */

  @override
  void initState(){
    //bind the focus listener when state initialize
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null){
        _editedProduct = Provider.of<ProductProvider>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    //unbind all nodes, controllers and listeners when screen dispose
    //to avoid memory leaks
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveForm()),
        ],
      ),
      body: _isLoading 
      ? Center(
         child: CircularProgressIndicator(),
        )
      : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              
              // Title text input
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  //move to next text input by add the focus node of
                  //next InputField
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },

                //validate text input value
                validator: (value){
                  if (value.isEmpty){
                    return 'please, enter a valid title.';
                  }
                  return null;
                },

                //tregered when user pressed submit form
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: value, 
                    description: _editedProduct.description, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              
              // Price text input
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descFocusNode);
                },

                //validate text input value
                validator: (value){
                  if (value.isEmpty){
                    return 'please, enter a price.';
                  }
                  if (double.tryParse(value) == null){
                    return 'please, enter a valid number.';
                  }
                  if (double.parse(value) <= 0){
                    return 'please, enter a valid price greater than zero.';
                  }
                  return null;
                },

                //tregered when user pressed submit form
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    price: double.parse(value), 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              // Description text input
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descFocusNode,

                //validate text input value
                validator: (value){
                  if (value.isEmpty){
                    return 'please, write a description.';
                  }
                  if (value.length < 10){
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },

                //tregered when user pressed submit form
                onSaved: (value){
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: value, 
                    price: _editedProduct.price, 
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              // Image container
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 16, right: 16),
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey,)),
                    child: _imageUrlController.text.isEmpty ? Text('Enter a URL') : 
                    FittedBox(
                      child: Image.network(_imageUrlController.text, fit: BoxFit.cover,)
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveForm(),
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,

                      //validate text input value
                      validator: (value){
                        if (value.isEmpty){
                          return 'please, enter an image URL.';
                        }
                        if (!value.startsWith('http') && !value.startsWith('https')){
                          return 'please, enter a valid URL.';
                        }
                        if (!value.endsWith('.jpg') && !value.endsWith('.jpeg') && !value.endsWith('.png')){
                          return 'please, enter a valid image URL.';
                        }
                        return null;
                      },

                      //tregered when user pressed submit form
                      onSaved: (value){
                        _editedProduct = Product(
                          id: _editedProduct.id, 
                          title: _editedProduct.title, 
                          description: _editedProduct.description, 
                          price: _editedProduct.price, 
                          imageUrl: value,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
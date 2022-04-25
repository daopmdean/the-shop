import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/model/product.dart';
import 'package:the_shop/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProduct';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: null,
    description: null,
    price: 0,
    imageUrl: null,
  );
  var _isInit = true;
  var _isEdit = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateFocusNode);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
        _isEdit = true;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateFocusNode);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Product' : 'Add Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      validator: _validateTitle,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: _validatePrice,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.tryParse(value),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: _validateDescription,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter your image url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            validator: _validateImageUrl,
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
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

  void _updateFocusNode() {
    if (!_imageUrlFocusNode.hasFocus) {
      var validImageUrl = _validateImageUrl(_imageUrlController.text) == null;
      if (!validImageUrl) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final valid = _form.currentState.validate();
    if (!valid) {
      print('Invalid form');
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_isEdit) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        print('---------inside catch error');
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred!'),
            content: Text('Something went wrong!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Okay'),
              )
            ],
          ),
        );
      }).then(
        (_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    }
  }

  String _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Title required';
    }
    return null;
  }

  String _validatePrice(String value) {
    if (value.isEmpty) {
      return 'Price required';
    }
    if (double.tryParse(value) == null) {
      return 'Price must be number';
    }
    if (double.tryParse(value) <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  String _validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description required';
    }
    return null;
  }

  String _validateImageUrl(String value) {
    if (value.isEmpty) {
      return 'Image URL required';
    }
    if (!value.startsWith('https')) {
      return 'Image URL must start with https';
    }
    return null;
  }
}

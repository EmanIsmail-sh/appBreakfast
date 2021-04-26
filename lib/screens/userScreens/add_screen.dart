import 'package:breakfastApp/models/product.dart';
import 'package:breakfastApp/providers/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widges/Custom_Text_Field.dart';
import 'widges/custom_button.dart';

class AddScreen extends StatefulWidget {
  static String id = 'AddScreen';
  final Product product;
  final int index;

  AddScreen({this.product, this.index});
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _addProductFormKey = GlobalKey<FormState>();
  Future _prod;

  Future<void> getApiProducts() {
    print('fun getapiproduct ');
    return _prod =
        Provider.of<ProductProvider>(context, listen: false).getAllProduct();
  }

 final TextEditingController priceController =  TextEditingController();
 final TextEditingController quantityController =  TextEditingController();

  Product currentItemp;
  List<DropdownMenuItem<Product>> dropDownItems = [];
  @override
  void initState() {
    print('product ${widget.product}');
    getDropDwonItem();
    getFormValueInEditCase();
    super.initState();
    handlePriceController();
    handleQuantityController();
  }

  handlePriceController(){
     priceController.addListener(() {
      final String text = priceController.text.toLowerCase();
      priceController.value = priceController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    
  }
handleQuantityController(){
 quantityController.addListener(() {
      final String text = quantityController.text.toLowerCase();
      quantityController.value = quantityController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
}
 @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }
  isEditCase() {
    if (widget.product != null) {
      return true;
    }
    return false;
  }

  getFormValueInEditCase() {
    if (!isEditCase()) {
      return;
    }
    priceController.text = widget.product.price;
    quantityController.text = widget.product.quantity;
  }

  getDropDwonItem() async {
    await getApiProducts();
    var prod = Provider.of<ProductProvider>(context, listen: false);
    if (widget.product != null) {
      int index =
          prod.allProduct.indexWhere((pro) => pro.name == widget.product.name);
      print('index $index');
      widget.product != null
          ? currentItemp = prod.allProduct[index]
          : currentItemp = prod.allProduct[0];
    }

    for (Product item in prod.allProduct) {
      dropDownItems.add(DropdownMenuItem<Product>(
        value: item,
        child: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ));
    }
  }

  calculateTotalPriceForOneProduct(quantity, productPrice) {
    print('productPrice $productPrice quantity $quantity');
    print('total ${num.parse(productPrice) * num.parse(quantity)}');
    return num.parse(productPrice) * num.parse(quantity);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Form(
            key: _addProductFormKey,
            child: ListView(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder(
                        future: _prod,
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('');
                          }

                          return FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  labelText: 'المنتج',
                                  hintText: 'المنتج',
                                  hintStyle: TextStyle(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  ///error border
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                isEmpty: currentItemp == null,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    icon: Icon(Icons.arrow_circle_down),
                                    value: currentItemp,
                                    isExpanded: true,
                                    items: dropDownItems,
                                    onChanged: (selectedItem) => setState(() {
                                      print('select item $selectedItem');
                                      currentItemp = selectedItem;
                                      currentItemp.type == 'FixedPrice'
                                          ? priceController.text =
                                              currentItemp.price
                                          : priceController.text = '';
                                      print(
                                          'priceController ${priceController.text}');
                                    }),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ),
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  textController: quantityController,
                  backTextColor: Colors.transparent,
                  inputType: TextInputType.number,
                  color: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    quantityController.text = value;
                    print(value);
                  },
                  labelText: 'الكميه',
                  hintText: 'الكميه',
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  textController: priceController,
                  backTextColor: Colors.transparent,
                  inputType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  color: Theme.of(context).primaryColor,
                  onChanged: (value) => priceController.text = value,
                  labelText: 'السعر',
                  hintText: 'السعر',
                  enabled: (currentItemp != null)
                      ? currentItemp.type == 'FixedPrice'
                          ? false
                          : true
                      : true,
                ),
                SizedBox(height: 10),
                Text((currentItemp != null)
                    ? "selected product name is ${currentItemp.name} : and price is : ${currentItemp.price}"
                    : ''),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: CustomButtonWidget(
                    color: Theme.of(context).primaryColor,
                    TextColor: Colors.white,
                    textbutton: widget.product != null ? 'تعديل' : 'اضافه',
                    onPressed: () {
                      widget.product == null
                          ? productProvider.addProduct(Product(
                                  id: currentItemp.id,
                                  name: currentItemp.name,
                                  // price: priceController.text,
                                  price: calculateTotalPriceForOneProduct(
                                      quantityController.text,
                                      priceController.text).toString(),
                                  quantity: quantityController.text,
                                  type: currentItemp.type) ??
                              'new Task')
                          : productProvider.editProduct(
                              Product(
                                  id: currentItemp.id,
                                  name: currentItemp.name,
                                  // price: priceController.text,
                                   price: calculateTotalPriceForOneProduct(
                                      quantityController.text,
                                      priceController.text).toString(),
                                  quantity: quantityController.text,
                                  type: currentItemp.type),
                              widget.index);
                      print(
                          'add_screen line 202 => name  ${currentItemp.name} , id ${currentItemp.name}');

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/store/sqflite.dart';
import '../../controllers/store/sherar_prefrence.dart';
import '../widget/button/custom_button.dart';
import '../widget/textfielde/custom_text_field.dart';
import '../../models/product/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final DatabaseHelper dbHelper = Get.put(DatabaseHelper());
  final SharedPreferenceService sharedPrefService = SharedPreferenceService();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Attach the form key
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.add_a_photo)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: 'Product Name',
                    controller: nameController,
                    icon: Icons.production_quantity_limits,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextField(
                    hintText: 'Product Price',
                    controller: priceController,
                    icon: Icons.price_change,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product price';
                      }
                      double? price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Obx(() => CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String productName = nameController.text.trim();
                        double? productPrice = double.tryParse(priceController.text.trim());
                        String? token = await sharedPrefService.readData();

                        if (_imageFile != null) {
                          await dbHelper.insertProduct(Product(
                            productImage: _imageFile!.path,
                            productName: productName,
                            productPrice: productPrice!,
                            token: token ?? "",
                          ));

                          Get.back();
                          Get.snackbar("Success", "Product added successfully!");
                        } else {
                          Get.snackbar("Error", "Please select an image.");
                        }
                      }
                    },
                    text: 'Submit',
                    loading: dbHelper.isLoading.value,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

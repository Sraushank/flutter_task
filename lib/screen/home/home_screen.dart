import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_task/screen/auth/login_screen.dart';
import 'package:flutter_task/screen/productadd/add_product.dart';
import 'package:get/get.dart';
import '../../controllers/store/sherar_prefrence.dart';
import '../../controllers/store/sqflite.dart';
import '../../models/product/product_model.dart';
import '../utils/colors/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper dbHelper = Get.put(DatabaseHelper());
  TextEditingController searchController = TextEditingController();
  RxList<Product> filteredProducts = <Product>[].obs;
  SharedPreferenceService shearprefrence = SharedPreferenceService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    await dbHelper.getProducts();
    filteredProducts.value = dbHelper.products;
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredProducts.value = dbHelper.products;
    } else {
      filteredProducts.value = dbHelper.products.where((product) {
        return product.productName!.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddProduct());
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () {
                shearprefrence.deleteData();
                Get.showSnackbar(GetSnackBar(
                  title: "LogOut",
                  message: "LogOut Success",
                  duration: const Duration(seconds: 3),
                  backgroundColor: AppColor.lightPrimaryColor,
                  borderRadius: 10,
                  snackPosition: SnackPosition.TOP,
                ));
                Get.offAll(LoginScreen());
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (dbHelper.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (filteredProducts.isEmpty) {
          return const Center(child: Text('No products available.'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              Product product = filteredProducts[index];
              File? productImageFile;

              if (product.productImage != null && product.productImage!.isNotEmpty) {
                productImageFile = File(product.productImage ?? "");
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          productImageFile != null && productImageFile.existsSync()
                              ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: Image.file(
                              productImageFile,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColor.lightPrimaryColor.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 100,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  dbHelper.deleteProduct(product.id!);
                                  dbHelper.products.removeWhere((element) {
                                    return element.id == product.id!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                   Container(
                     margin: EdgeInsets.all(5),
                     child:  Text(
                       product.productName ?? "No Name",
                       style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 18
                       ),
                       overflow: TextOverflow.ellipsis,
                     ),
                   ),
                    Container(
                      margin: EdgeInsets.only(left: 5,bottom: 5),
                      child: Text(
                        " \$${product.productPrice}",
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}

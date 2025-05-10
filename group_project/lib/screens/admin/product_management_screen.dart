import 'package:flutter/material.dart';
import '../../../models/product.dart';
import 'product_form_dialog.dart';
import '../../models/product_service.dart'; // import ProductService

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ProductService _productService = ProductService();
  late Stream<List<Product>> _productsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen to Firestore updates
    _productsStream = _productService.getProducts();
  }

  void _addProduct(Product product) {
    _productService.addProduct(product);
  }

  void _editProduct(String id, Product updatedProduct) {
    _productService.updateProduct(updatedProduct);
  }

  void _deleteProduct(String id) {
    _productService.deleteProduct(id);
  }

  void _openProductForm({Product? product}) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        onSave: product == null
            ? _addProduct
            : (updated) => _editProduct(product.id, updated),
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: StreamBuilder<List<Product>>(
        stream: _productsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)} | Stock: ${product.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openProductForm(product: product),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

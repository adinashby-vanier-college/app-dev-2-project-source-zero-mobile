import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/product.dart';
import 'product_form_dialog.dart';
import '../../models/product_service.dart';

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
    _productsStream = _productService.getProducts();
  }

  void _addProduct(Product product) {
    _productService.addProduct(product);
  }

  void _editProduct(String id, Product updatedProduct) {
    _productService.updateProduct(updatedProduct);
  }

  void _deleteProduct(String id) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Delete',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2E5D32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete this product?',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2E5D32).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2E5D32),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      _productService.deleteProduct(id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Product deleted',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: const Color(0xFF2E5D32),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
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
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        title: Text(
          'Product Inventory',
          style: GoogleFonts.poppins(
            color: const Color(0xFF2E5D32),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2E5D32)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product List',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2E5D32),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFB6D433),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: const Color(0xFF2E5D32).withOpacity(0.6),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load products',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E5D32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E5D32).withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: const Color(0xFF2E5D32).withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E5D32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first product',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2E5D32).withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: const Color(0xFF2E5D32).withOpacity(0.1),
                    ),
                    itemBuilder: (_, index) {
                      final product = products[index];
                      return Dismissible(
                        key: Key(product.id),
                        background: Container(
                          color: Colors.red.withOpacity(0.1),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red.withOpacity(0.6),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDFDFD),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Confirm Delete',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2E5D32),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Are you sure you want to delete this product?',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF2E5D32).withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(0xFF2E5D32),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        onDismissed: (_) => _deleteProduct(product.id),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E5D32).withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            title: Text(
                              product.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2E5D32),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF2E5D32),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Quantity: ${product.quantity}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: product.quantity <= 5
                                        ? const Color(0xFFB6D433)
                                        : const Color(0xFF2E5D32).withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: const Color(0xFF2E5D32).withOpacity(0.6),
                                    ),
                                    onPressed: () => _openProductForm(product: product),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.withOpacity(0.6),
                                    ),
                                    onPressed: () => _deleteProduct(product.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProductForm(),
        backgroundColor: const Color(0xFFB6D433),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
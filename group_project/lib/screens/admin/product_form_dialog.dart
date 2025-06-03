import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/product.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductFormDialog({super.key, this.product, required this.onSave});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _price = widget.product?.price ?? 0.0;
    _quantity = widget.product?.quantity ?? 0;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        price: _price,
        quantity: _quantity,
      );
      widget.onSave(newProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product == null ? 'Add Product' : 'Edit Product',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2E5D32),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        labelStyle: GoogleFonts.poppins(
                          color: const Color(0xFF2E5D32).withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2E5D32),
                      ),
                      onSaved: (val) => _name = val!,
                      validator: (val) => val!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _price.toString(),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: GoogleFonts.poppins(
                          color: const Color(0xFF2E5D32).withOpacity(0.6),
                        ),
                        prefixText: '\$ ',
                        prefixStyle: GoogleFonts.poppins(
                          color: const Color(0xFF2E5D32),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2E5D32),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onSaved: (val) => _price = double.parse(val!),
                      validator: (val) {
                        if (val!.isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid number';
                        if (double.parse(val) <= 0) return 'Must be greater than 0';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _quantity.toString(),
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: GoogleFonts.poppins(
                          color: const Color(0xFF2E5D32).withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E5D32).withOpacity(0.2),
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2E5D32),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _quantity = int.parse(val!),
                      validator: (val) {
                        if (val!.isEmpty) return 'Required';
                        if (int.tryParse(val) == null) return 'Invalid number';
                        if (int.parse(val) < 0) return 'Cannot be negative';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB6D433),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save',
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
            ],
          ),
        ),
      ),
    );
  }
}
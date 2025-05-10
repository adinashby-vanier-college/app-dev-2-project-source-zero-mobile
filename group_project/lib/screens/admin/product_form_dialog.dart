import 'package:flutter/material.dart';
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
  late int _quantity;  // Changed from _stock to _quantity

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _price = widget.product?.price ?? 0.0;
    _quantity = widget.product?.quantity ?? 0;  // Use quantity here
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        price: _price,
        quantity: _quantity,  // Use quantity here
      );
      widget.onSave(newProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Product Name'),
              onSaved: (val) => _name = val!,
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (val) => _price = double.parse(val!),
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              initialValue: _quantity.toString(),  // Change _stock to _quantity here
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onSaved: (val) => _quantity = int.parse(val!),
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

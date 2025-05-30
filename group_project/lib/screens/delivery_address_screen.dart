import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<SavedAddress> _savedAddresses = [];
  SavedAddress? _selectedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable them in app settings.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _streetController.text = [
            place.street,
            place.thoroughfare
          ].where((s) => s != null && s.isNotEmpty).join(' ');
          _cityController.text = place.locality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAddress({bool isMain = false}) async {
    if (_streetController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid address')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isMain) {
        final batch = FirebaseFirestore.instance.batch();
        final existing = await FirebaseFirestore.instance
            .collection('user_addresses')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where('isMain', isEqualTo: true)
            .get();

        for (var doc in existing.docs) {
          batch.update(doc.reference, {'isMain': false});
        }
        await batch.commit();
      }

      await FirebaseFirestore.instance.collection('user_addresses').add({
        'street': _streetController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zip': _zipController.text,
        'country': _countryController.text,
        'fullAddress': '${_streetController.text}, ${_cityController.text}, ${_stateController.text}, ${_countryController.text}',
        'isMain': isMain,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid,
      });

      await _loadSavedAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isMain ? 'Main address saved!' : 'Address saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving address: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSavedAddresses() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_addresses')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      final sortedDocs = snapshot.docs.toList()
        ..sort((a, b) => (b.data()['timestamp'] as Timestamp)
            .compareTo(a.data()['timestamp'] as Timestamp));

      setState(() {
        _savedAddresses = sortedDocs.map((doc) {
          final data = doc.data();
          return SavedAddress(
            id: doc.id,
            street: data['street'] ?? '',
            city: data['city'] ?? '',
            state: data['state'] ?? '',
            zip: data['zip'] ?? '',
            country: data['country'] ?? '',
            fullAddress: data['fullAddress'] ?? '',
            isMain: data['isMain'] ?? false,
          );
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading addresses: $e')),
      );
    }
  }

  Future<void> _deleteAddress(String id) async {
    try {
      await FirebaseFirestore.instance.collection('user_addresses').doc(id).delete();
      await _loadSavedAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address deleted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting address: $e')),
      );
    }
  }

  void _selectAddress(SavedAddress address) {
    setState(() {
      _selectedAddress = address;
      _streetController.text = address.street;
      _cityController.text = address.city;
      _stateController.text = address.state;
      _zipController.text = address.zip;
      _countryController.text = address.country;
    });
  }

  void _clearForm() {
    setState(() {
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipController.clear();
      _countryController.clear();
      _searchController.clear();
      _selectedAddress = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            TypeAheadField<Location>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Address',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.length < 3) return <Location>[];
                try {
                  return await locationFromAddress(pattern);
                } catch (e) {
                  return <Location>[];
                }
              },
              itemBuilder: (context, Location suggestion) {
                return ListTile(
                  title: Text('${suggestion.latitude}, ${suggestion.longitude}'),
                );
              },
              onSuggestionSelected: (Location suggestion) async {
                try {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    suggestion.latitude,
                    suggestion.longitude,
                  );
                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks.first;
                    setState(() {
                      _streetController.text = [
                        place.street,
                        place.thoroughfare
                      ].where((s) => s != null && s.isNotEmpty).join(' ');
                      _cityController.text = place.locality ?? '';
                      _stateController.text = place.administrativeArea ?? '';
                      _zipController.text = place.postalCode ?? '';
                      _countryController.text = place.country ?? '';
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Street address',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      prefixIcon: Icon(Icons.flag),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP code',
                      prefixIcon: Icon(Icons.markunread_mailbox),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      prefixIcon: Icon(Icons.public),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Address'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : () => _saveAddress(isMain: false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.star),
                    label: const Text('Set as Main'),
                    onPressed: _isLoading ? null : () => _saveAddress(isMain: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Saved Addresses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_savedAddresses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No saved addresses yet',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedAddresses.length,
                itemBuilder: (context, index) {
                  final address = _savedAddresses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: _selectedAddress?.id == address.id
                        ? Colors.blue[50]
                        : null,
                    child: ListTile(
                      leading: address.isMain
                          ? const Icon(Icons.star, color: Colors.amber)
                          : const Icon(Icons.location_on),
                      title: Text(address.street),
                      subtitle: Text(
                          '${address.city}, ${address.state} ${address.zip}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAddress(address.id),
                      ),
                      onTap: () => _selectAddress(address),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SavedAddress {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String fullAddress;
  final bool isMain;

  SavedAddress({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.fullAddress,
    required this.isMain,
  });
}
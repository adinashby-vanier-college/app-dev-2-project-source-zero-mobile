import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_navigation.dart';

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

  final String _apiKey = 'AIzaSyC0064ds-xg1CFwF946x6JQj00AsxB_lFo';

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

  Future<List<String>> _getSuggestions(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey&types=address';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      return List<String>.from(
        data['predictions'].map((p) => p['description']),
      );
    } else {
      return [];
    }
  }

  Future<void> _getPlaceDetails(String description) async {
    final autocompleteUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$description&key=$_apiKey&types=address';
    final autocompleteResp = await http.get(Uri.parse(autocompleteUrl));
    final predictions = json.decode(autocompleteResp.body)['predictions'];
    if (predictions.isEmpty) return;

    final placeId = predictions[0]['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';
    final detailsResp = await http.get(Uri.parse(detailsUrl));
    final result = json.decode(detailsResp.body)['result'];

    final components = result['address_components'] as List;
    String getComponent(String type) {
      return components.firstWhere(
            (c) => (c['types'] as List).contains(type),
        orElse: () => {'long_name': ''},
      )['long_name'];
    }

    setState(() {
      _searchController.text = result['formatted_address'] ?? '';
      _streetController.text = getComponent("route") + ' ' + getComponent("street_number");
      _cityController.text = getComponent("locality") != ''
          ? getComponent("locality")
          : getComponent("sublocality");
      _stateController.text = getComponent("administrative_area_level_1");
      _zipController.text = getComponent("postal_code");
      _countryController.text = getComponent("country");
    });
  }

  Future<void> _updateAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _streetController.text =
              [place.street, place.thoroughfare].where((s) => s != null && s.isNotEmpty).join(' ').trim();
          _cityController.text = place.locality ?? place.subLocality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error getting address details',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Enable location services.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Location Permission',
              style: GoogleFonts.poppins(color: const Color(0xFF2E5D32)),
            ),
            content: Text(
              'Location permissions are permanently denied. Please enable them in your device settings.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFF2E5D32)),
                ),
              ),
            ],
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _updateAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAddress({bool isMain = false}) async {
    if (_streetController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid address',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not authenticated',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isMain) {
        final batch = FirebaseFirestore.instance.batch();
        final existing = await FirebaseFirestore.instance
            .collection('user_addresses')
            .where('userId', isEqualTo: user.uid)
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
        'fullAddress':
        '${_streetController.text}, ${_cityController.text}, ${_stateController.text}, ${_countryController.text}',
        'isMain': isMain,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      await _loadSavedAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMain ? 'Main address saved!' : 'Address saved!',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving address: $e',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
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
        SnackBar(
          content: Text(
            'Error loading addresses: $e',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
    }
  }

  Future<void> _deleteAddress(String id) async {
    try {
      await FirebaseFirestore.instance.collection('user_addresses').doc(id).delete();
      await _loadSavedAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Address deleted!',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error deleting address: $e',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2E5D32),
        ),
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

  Widget _buildMinimalLogo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFB6D433),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'source',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32),
            letterSpacing: 2,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 1,
          height: 16,
          color: const Color(0xFF2E5D32).withOpacity(0.3),
        ),
        Text(
          'zero',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E5D32),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'your',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF2E5D32).withOpacity(0.6),
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'delivery address',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF2E5D32),
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: const Color(0xFFFDFDFD),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: _buildMinimalLogo(context),
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E5D32).withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  color: const Color(0xFF2E5D32),
                  iconSize: 22,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildHeaderSection(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB6D433)),
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E5D32).withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              icon: const FaIcon(FontAwesomeIcons.locationDot, size: 16),
                              label: Text(
                                'Use Current Location',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2E5D32),
                                ),
                              ),
                              onPressed: _getCurrentLocation,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Search Address',
                                labelStyle: GoogleFonts.poppins(
                                  color: const Color(0xFF2E5D32).withOpacity(0.6),
                                ),
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E5D32)),
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
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB6D433),
                                  ),
                                ),
                              ),
                            ),
                            suggestionsCallback: _getSuggestions,
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion,
                                  style: GoogleFonts.poppins(),
                                ),
                              );
                            },
                            onSuggestionSelected: _getPlaceDetails,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _streetController,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: 'Street address',
                              labelStyle: GoogleFonts.poppins(
                                color: const Color(0xFF2E5D32).withOpacity(0.6),
                              ),
                              prefixIcon: const Icon(Icons.home, color: Color(0xFF2E5D32)),
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB6D433),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _cityController,
                                  style: GoogleFonts.poppins(),
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    labelStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF2E5D32).withOpacity(0.6),
                                    ),
                                    prefixIcon: const Icon(Icons.location_city, color: Color(0xFF2E5D32)),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFB6D433),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _stateController,
                                  style: GoogleFonts.poppins(),
                                  decoration: InputDecoration(
                                    labelText: 'State',
                                    labelStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF2E5D32).withOpacity(0.6),
                                    ),
                                    prefixIcon: const Icon(Icons.flag, color: Color(0xFF2E5D32)),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFB6D433),
                                      ),
                                    ),
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
                                  style: GoogleFonts.poppins(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'ZIP code',
                                    labelStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF2E5D32).withOpacity(0.6),
                                    ),
                                    prefixIcon: const Icon(Icons.markunread_mailbox, color: Color(0xFF2E5D32)),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFB6D433),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _countryController,
                                  style: GoogleFonts.poppins(),
                                  decoration: InputDecoration(
                                    labelText: 'Country',
                                    labelStyle: GoogleFonts.poppins(
                                      color: const Color(0xFF2E5D32).withOpacity(0.6),
                                    ),
                                    prefixIcon: const Icon(Icons.public, color: Color(0xFF2E5D32)),
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
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFB6D433),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF2E5D32).withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.save, color: Color(0xFF2E5D32)),
                                    label: Text(
                                      'Save Address',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF2E5D32),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : () => _saveAddress(isMain: false),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB6D433),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextButton.icon(
                                    icon: const Icon(Icons.star, color: Colors.white),
                                    label: Text(
                                      'Set as Main',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: _isLoading ? null : () => _saveAddress(isMain: true),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Saved Addresses',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2E5D32),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_savedAddresses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2E5D32).withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB6D433).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                FontAwesomeIcons.mapLocationDot,
                                color: const Color(0xFF2E5D32).withOpacity(0.4),
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No saved addresses',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF2E5D32),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your saved addresses will appear here',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF2E5D32).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _savedAddresses.length,
                        itemBuilder: (context, index) {
                          final address = _savedAddresses[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2E5D32).withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: address.isMain
                                      ? const Color(0xFFB6D433).withOpacity(0.2)
                                      : const Color(0xFF2E5D32).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  address.isMain
                                      ? Icons.star
                                      : Icons.location_on,
                                  color: address.isMain
                                      ? const Color(0xFFB6D433)
                                      : const Color(0xFF2E5D32),
                                ),
                              ),
                              title: Text(
                                address.street,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2E5D32),
                                ),
                              ),
                              subtitle: Text(
                                '${address.city}, ${address.state} ${address.zip}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF2E5D32).withOpacity(0.6),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: const Color(0xFF2E5D32).withOpacity(0.6),
                                onPressed: () => _deleteAddress(address.id),
                              ),
                              onTap: () => _selectAddress(address),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SourceZeroBottomNavigationBar(currentIndex: 1),
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
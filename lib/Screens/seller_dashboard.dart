import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'map_picker_screen.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  // Controllers for product form
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productQuantityController = TextEditingController();

  // Controllers for profile form
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _workingHoursController = TextEditingController();

  final List<String> _categories = [
    'Groceries',
    'Electronics',
    'Fashion',
    'Sports',
    'Home & Living',
    'Health & Beauty',
    'Books',
    'Toys',
    'Food',
    'Pet Supplies'
  ];
  String? _selectedCategory;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  XFile? _shopLogo;
  LatLng? _selectedLocation;
  // File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                _buildStatCard(
                  'Total Products',
                  '24',
                  Icons.inventory,
                  Colors.blue,
                  isDark,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Total Sales',
                  'R2,450',
                  Icons.attach_money,
                  Colors.green,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAddProductForm,
                    icon: const Icon(Icons.add_box),
                    label: const Text('Add New Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.grey[850]
                          : null, // Gray background in dark mode
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showUpdateProfileForm,
                    icon: const Icon(Icons.edit),
                    label: const Text('Update Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.grey[850]
                          : null, // Gray background in dark mode
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity Section
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentActivityList(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Card(
        color: isDark ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(bool isDark) {
    return Card(
      color: isDark ? Colors.grey[850] : Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.shopping_bag),
            ),
            title: Text('Activity ${index + 1}',
                style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            subtitle: Text('Details about activity ${index + 1}',
                style:
                    TextStyle(color: isDark ? Colors.grey[300] : Colors.black)),
            trailing: Text('${index + 1}h ago',
                style:
                    TextStyle(color: isDark ? Colors.grey[500] : Colors.black)),
          );
        },
      ),
    );
  }

  void _showAddProductForm() {
    _showFormModal(
        'Add New Product',
        _productNameController,
        _productDescriptionController,
        _productPriceController,
        _productQuantityController,
        _selectedCategory,
        _uploadProduct);
  }

  void _showUpdateProfileForm() {
    _showProfileModal();
  }

  Future<void> _showFormModal(
      String title,
      TextEditingController nameController,
      TextEditingController descriptionController,
      TextEditingController priceController,
      TextEditingController quantityController,
      String? selectedCategory,
      Function uploadFunction) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Product Name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: 'GHC',
                            border: OutlineInputBorder())),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder())),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                      value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(
                    labelText: 'Select Category', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                  onPressed: _showImagePickerOptions,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Image')),
              if (_pickedImage != null)
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(File(_pickedImage!.path), height: 100)),
              ElevatedButton(
                onPressed: () {
                  uploadFunction();
                  Navigator.pop(context);
                },
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
    return;
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Update Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(
                      labelText: 'Shop Name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _shopAddressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Shop Address', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'Phone Number', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: _workingHoursController,
                  decoration: const InputDecoration(
                      labelText: 'Working Hours',
                      hintText: 'e.g., Mon - Fri, 9AM - 5PM',
                      border: OutlineInputBorder())),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                  onPressed: _pickLogoImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Shop Logo')),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                  onPressed: _selectLocationOnMap,
                  icon: const Icon(Icons.location_pin),
                  label: const Text('Pick Shop Location')),
              if (_selectedLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Location: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadProduct() async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')));
      return;
    }

    try {
      final imageUrl = await _uploadImageToCloudinary(_pickedImage!.path);
      await FirebaseFirestore.instance.collection('products').add({
        'name': _productNameController.text.trim(),
        'description': _productDescriptionController.text.trim(),
        'price': double.tryParse(_productPriceController.text.trim()) ?? 0.0,
        'quantity': int.tryParse(_productQuantityController.text.trim()) ?? 0,
        'category': _selectedCategory,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product uploaded successfully')));
      _clearProductForm();
      Navigator.pop(context); // Close the modal
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<String> _uploadImageToCloudinary(String imagePath) async {
    const cloudName = 'dgg2rcnqc';
    const uploadPreset = 'ml_default';
    final imageFile = File(imagePath);
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image to Cloudinary');
    }

    final resStr = await response.stream.bytesToString();
    final resJson = json.decode(resStr);
    return resJson['secure_url'];
  }

  Future<void> _updateProfile() async {
    // Validate required fields
    if (_shopNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a shop name')));
      return;
    }

    try {
      // Create a data map to store profile info
      final Map<String, dynamic> profileData = {
        'shopName': _shopNameController.text.trim(),
        'address': _shopAddressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'workingHours': _workingHoursController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add logo URL if a logo was uploaded
      if (_shopLogo != null) {
        final imageUrl = await _uploadImageToCloudinary(_shopLogo!.path);
        profileData['logoUrl'] = imageUrl;
      }

      // Add location if it was selected
      if (_selectedLocation != null) {
        profileData['location'] = {
          'lat': _selectedLocation!.latitude,
          'lng': _selectedLocation!.longitude,
        };
      }

      // Upload to Firestore
      await FirebaseFirestore.instance
          .collection('shop_info')
          .doc('shop_info.uid')
          .set(profileData, SetOptions(merge: true));

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  Future<void> _showImagePickerOptions() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
              //Image picker local resource.
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the modal
                final permissionStatus = await Permission.photos.request();
                if (permissionStatus.isGranted) {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() => _pickedImage = pickedFile);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery permission denied')),
                  );
                }
              }),
          ListTile(
              //Camera local resource
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context); // Close the modal
                final permissionStatus = await Permission.camera.request();
                if (permissionStatus.isGranted) {
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() => _pickedImage = pickedFile);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera permission denied')),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<void> _pickLogoImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _shopLogo = pickedImage;
      });
    }
  }

  //Location picker
  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapPickerScreen(), // Using the MapPickerScreen
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location selected successfully')),
        );
      });
    }
  }

  void _clearProductForm() {
    _productNameController.clear();
    _productDescriptionController.clear();
    _productPriceController.clear();
    _productQuantityController.clear();
    setState(() {
      _selectedCategory = null;
      _pickedImage = null;
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productQuantityController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _workingHoursController.dispose();
    super.dispose();
  }
}

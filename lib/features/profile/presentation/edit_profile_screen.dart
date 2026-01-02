import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:near_help/l10n/app_localizations.dart';
import '../../auth/data/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_controller.dart';
import 'package:latlong2/latlong.dart';
import '../../location/presentation/location_picker_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  XFile? _imageFile;
  String? _currentAvatarUrl;
  final _picker = ImagePicker();
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      _nameController.text = profile['name'] ?? '';
      _phoneController.text = profile['phone'] ?? '';
      _emailController.text = ref.read(authRepositoryProvider).currentUser?.email ?? '';
      _addressController.text = profile['address'] ?? profile['area'] ?? ''; 
      _currentAvatarUrl = profile['avatar_url'];
      _latitude = profile['latitude'];
      _longitude = profile['longitude'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
     final LatLng? result = await Navigator.push(
       context,
       MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
     );

     if (result != null) {
       setState(() {
         _latitude = result.latitude;
         _longitude = result.longitude;
         _addressController.text = "Pin: ${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}";
       });
     }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70); 
    if (pickedFile != null) {
      await _cropImage(pickedFile);
    }
  }

  Future<void> _cropImage(XFile pickedFile) async {
    if (kIsWeb) {
      setState(() {
        _imageFile = pickedFile;
      });
      return;
    }
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Edit Photo',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = XFile(croppedFile.path); 
      });
    }
  }

  Future<String?> _uploadAvatar(String userId) async {
    if (_imageFile == null) return null;
    try {
      final fileExt = _imageFile!.name.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = '$userId/$fileName';
      
      final bytes = await _imageFile!.readAsBytes();
      
      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));
      
      final imageUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading image: $e")));
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final userId = ref.read(authRepositoryProvider).currentUser?.id;
        if (userId == null) throw Exception("User not logged in");

        String? avatarUrl = _currentAvatarUrl;
        if (_imageFile != null) {
           final uploaded = await _uploadAvatar(userId);
           if (uploaded != null) avatarUrl = uploaded;
        }

        await ref.read(profileRepositoryProvider).updateProfile(
          userId: userId,
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          // Sync area with address for now
          area: _addressController.text, 
          avatarUrl: avatarUrl,
          latitude: _latitude,
          longitude: _longitude,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Updated Successfully!')),
          );
          Navigator.pop(context);
          ref.refresh(userProfileProvider);
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: $e")));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Background Gradient Curve (Header)
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const BackButton(color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content
          Container(
            margin: const EdgeInsets.only(top: 0), // Use margin or padding in scroll view
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 24), // Push down to overlap curve
              child: Column(
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white, // White border for contrast against curve
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                            ),
                            child: CircleAvatar(
                              radius: 60, // Slightly larger
                              backgroundColor: Colors.blue.shade50,
                              backgroundImage: _imageFile != null
                                 ? (kIsWeb 
                                     ? NetworkImage(_imageFile!.path) 
                                     : FileImage(File(_imageFile!.path))) as ImageProvider
                                 : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty)
                                     ? NetworkImage(_currentAvatarUrl!)
                                     : null,
                              child: (_imageFile == null && (_currentAvatarUrl == null || _currentAvatarUrl!.isEmpty))
                                 ? const Icon(Icons.person, size: 60, color: Colors.blue)
                                 : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.camera_alt, color: Colors.blue, size: 22),
                                  onPressed: () => _showPhotoOptions(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 32),
              
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel("Full Name"),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration(Icons.person_outline),
                          validator: (val) => val!.isEmpty ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildLabel("Phone Number"),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (val) => val!.isEmpty ? 'Phone is required' : null,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("Location / Address"),
                        TextFormField(
                          controller: _addressController,
                          decoration: _inputDecoration(Icons.location_on_outlined).copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.map, color: Colors.blue),
                              onPressed: _pickLocation,
                            ),
                          ),
                          readOnly: false, 
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("Email Address (Read-Only)"),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: _inputDecoration(Icons.email_outlined).copyWith(
                             fillColor: Colors.grey[100],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 5,
                            shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                          ),
                          child: _isLoading 
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                            : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[50], 
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blue)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red)),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Change Profile Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPhotoOption(Icons.camera_alt, "Camera", ImageSource.camera, ctx),
                _buildPhotoOption(Icons.photo_library, "Gallery", ImageSource.gallery, ctx),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(IconData icon, String label, ImageSource source, BuildContext ctx) {
    return InkWell(
      onTap: () {
        Navigator.pop(ctx);
        _pickImage(source);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

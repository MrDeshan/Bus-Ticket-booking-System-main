import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  String userName = 'Deshan Dissanayaka'; // Placeholder initial value
  String? profileImageUrl;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          setState(() {
            nameController.text = data?['name'] ?? '';
            addressController.text = data?['address'] ?? '';
            nicController.text = data?['nic'] ?? '';
            phoneController.text = data?['phone'] ?? '';
            emailController.text = data?['email'] ?? '';
            profileImageUrl = data?['profileImageUrl'];
            userName = data?['name'] ?? ''; // Update userName
          });
        }
      } catch (e) {
        print('Failed to fetch user data: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
        final uploadTask = storageRef.putFile(_imageFile!);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } catch (e) {
        print('Failed to upload image: $e');
        return null;
      }
    }
    return null;
  }

  void _saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
      }
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'address': addressController.text,
          'nic': nicController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'profileImageUrl': imageUrl ?? profileImageUrl,
        });
        _fetchUserData(); // Refresh data
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save data: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isEditing) {
                      _pickImage();
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                    child: profileImageUrl == null
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 8),
                Text(userName, style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                _buildLabelAndTextField('Name', nameController),
                _buildLabelAndTextField('Address', addressController),
                _buildLabelAndTextField('NIC Number', nicController, maxLength: 12, isNumber: true, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIC number';
                  }
                  if (value.length != 12) {
                    return 'NIC number must be exactly 12 digits';
                  }
                  return null;
                }),
                _buildLabelAndTextField('Phone Number', phoneController, maxLength: 10, isNumber: true, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                }),
                _buildEmailField('Change Email Address', emailController, validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
                }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _saveToFirestore();
                          setState(() {
                            isEditing = false;
                          });
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelAndTextField(String label, TextEditingController controller, {int? maxLength, bool isNumber = false, FormFieldValidator<String>? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            enabled: isEditing,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumber
                ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(maxLength)]
                : [LengthLimitingTextInputFormatter(maxLength)],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(String label, TextEditingController controller, {FormFieldValidator<String>? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: isEditing,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

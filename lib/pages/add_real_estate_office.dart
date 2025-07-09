import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddRealEstateOffice extends StatefulWidget {
  final bool inDrawer;
  const AddRealEstateOffice({Key? key, this.inDrawer = false}) : super(key: key);

  @override
  State<AddRealEstateOffice> createState() => _AddRealEstateOfficeState();
}

class _AddRealEstateOfficeState extends State<AddRealEstateOffice> {
  final _formKey = GlobalKey<FormState>();
  

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  

  XFile? _mainImage;
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  
  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  

  
  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('offices')
          .child('$fileName.jpg');
      
      final uploadTask = storageRef.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_mainImage == null) {
        setState(() {
          _errorMessage = 'يرجى اختيار صورة للمكتب العقاري';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      try {

        final imageUrl = await _uploadImage(_mainImage!);
        

        await FirebaseFirestore.instance.collection('offices').add({
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'imageUrl': imageUrl,
        });


        _formKey.currentState!.reset();
        _nameController.clear();
        _locationController.clear();
        
        setState(() {
          _mainImage = null;
          _successMessage = 'تم إضافة المكتب العقاري بنجاح';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء إضافة المكتب العقاري: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerfont = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: widget.inDrawer ? null : AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          'إضافة مكتب عقاري جديد',
          style: TextStyle(
            fontFamily: providerfont.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  if (_successMessage != null)
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _successMessage!,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              

                  buildTextField(
                    context: context,
                    controller: _nameController,
                    label: 'اسم المكتب العقاري',
                    hintText: 'أدخل اسم المكتب العقاري',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم المكتب العقاري';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  buildTextField(
                    context: context,
                    controller: _locationController,
                    label: 'الموقع',
                    hintText: 'أدخل موقع المكتب العقاري',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال موقع المكتب العقاري';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
              

                  buildImagePicker(
                    context: context,
                    label: 'صورة المكتب العقاري',
                    image: _mainImage,
                    onImagePicked: (XFile? image) {
                      setState(() {
                        _mainImage = image;
                      });
                    },
                    onImageDeleted: () {
                      setState(() {
                        _mainImage = null;
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'إضافة المكتب العقاري',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

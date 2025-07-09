import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddResidentialComplex extends StatefulWidget {
  final bool inDrawer;
  const AddResidentialComplex({Key? key, this.inDrawer = false}) : super(key: key);

  @override
  State<AddResidentialComplex> createState() => _AddResidentialComplexState();
}

class _AddResidentialComplexState extends State<AddResidentialComplex> {
  final _formKey = GlobalKey<FormState>();
  

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _areaController = TextEditingController();
  

  XFile? _mainImage;
  List<XFile> _sliderImages = [];
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _areaController.dispose();
    super.dispose();
  }
  

  

  


  Future<String?> _uploadImage(XFile? image, String folder) async {
    if (image == null) return null;
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('residential-complexes/$folder/$fileName');
      

      final uploadTask = storageRef.putFile(File(image.path));
      final snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_mainImage == null) {
        setState(() {
          _errorMessage = 'يرجى اختيار صورة رئيسية للمجمع السكني';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      try {

        final mainImageUrl = await _uploadImage(_mainImage!, 'main-image');
        

        List<String> sliderImageUrls = [];
        for (var image in _sliderImages) {
          final url = await _uploadImage(image, 'slider-images');
          if (url != null) {
            sliderImageUrls.add(url);
          }
        }
        

        await FirebaseFirestore.instance.collection('Residential Complexes').add({
          'title': _titleController.text.trim(),
          'location': _locationController.text.trim(),
          'description': _descriptionController.text.trim(),
          'area': _areaController.text.trim(),
          'imageUrl': mainImageUrl,
          'sliderImages': sliderImageUrls,
          'post-date': FieldValue.serverTimestamp(),
          'owner': 'عقارات النيزك',
        });


        _formKey.currentState!.reset();
        _titleController.clear();
        _locationController.clear();
        _descriptionController.clear();
        _areaController.clear();
        
        setState(() {
          _mainImage = null;
          _sliderImages = [];
          _successMessage = 'تم إضافة المجمع السكني بنجاح';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء إضافة المجمع السكني: $e';
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
    
    return Material(
      color: Colors.transparent,
      child: Container(
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "إضافة مجمع سكني جديد",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: providerfont.fontFamily,
                          fontSize: 20
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
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
                                style: TextStyle(color: Colors.red.shade800),
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
                                style: TextStyle(color: Colors.green.shade800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "معلومات المجمع السكني",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey.shade200),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: buildTextField(
                                  context: context,
                                  label: "اسم المجمع السكني",
                                  controller: _titleController,
                                  hintText: "أدخل اسم المجمع السكني",
                                  validator: (value) =>
                                      value!.isEmpty ? 'الرجاء إدخال اسم المجمع السكني' : null,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: buildTextField(
                                  context: context,
                                  label: "المساحة",
                                  controller: _areaController,
                                  hintText: "المساحة",
                                  suffixText: "م2",
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      value!.isEmpty ? 'الرجاء إدخال المساحة' : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          

                          Row(
                            children: [
                              Expanded(
                                child: buildTextField(
                                  context: context,
                                  label: "الموقع",
                                  controller: _locationController,
                                  hintText: "أدخل موقع المجمع السكني",
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                  validator: (value) =>
                                      value!.isEmpty ? 'الرجاء إدخال الموقع' : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          

                          buildTextField(
                            context: context,
                            label: "وصف المجمع السكني",
                            controller: _descriptionController,
                            hintText: "أدخل وصف المجمع السكني",
                            maxLines: 3,
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال وصف المجمع السكني' : null,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    SizedBox(height: 8),
                    
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.photo_library, color: Colors.blue.shade800),
                                SizedBox(width: 8),
                                Text(
                                  "صور المجمع السكني",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade200),
                          SizedBox(height: 8),
                          

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                flex: 1,
                                child: buildImagePicker(
                                  context: context,
                                  label: "الصورة الرئيسية",
                                  image: _mainImage,
                                  onImagePicked: (pickedFile) {
                                    setState(() {
                                      _mainImage = pickedFile;
                                    });
                                  },
                                  onImageDeleted: () {
                                    setState(() {
                                      _mainImage = null;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              

                              Expanded(
                                flex: 2,
                                child: buildMultiImagePicker(
                                  context: context,
                                  label: "صور إضافية للمجمع",
                                  images: _sliderImages,
                                  onImagesPicked: (pickedFiles) {
                                    setState(() {
                                      _sliderImages = pickedFiles;
                                    });
                                  },
                                  onImageDeleted: (file) {
                                    setState(() {
                                      _sliderImages.remove(file);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "بعد الانتهاء من إدخال جميع البيانات، اضغط على زر الحفظ لإضافة المجمع السكني",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: providerfont.fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: _submitForm,
                                    icon: Icon(Icons.save_outlined, size: 24),
                                    label: Text(
                                      "حفظ المجمع السكني",
                                      style: TextStyle(
                                        fontFamily: providerfont.fontFamily,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    ),
        )
      )
    );
  }
}

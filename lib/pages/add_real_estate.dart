import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _locationDetailsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _locationOwnerController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _postedController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  

  String? _selectedType;
  String? _selectedStatus;
  

  XFile? _mainImage;
  XFile? _ownerImage;
  XFile? _engineeringReport;
  XFile? _legalReport;
  List<XFile> _propertyImages = [];
  

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  

  final List<String> _realEstateTypes = [
    'شقة',
    'فيلا',
    'أرض',
    'محل تجاري',
    'مكتب',
    'مخزن',
    'مزرعة',
    'مصنع',
    'شاليه',
    'استراحة',
  ];
  
  final List<String> _realEstateStatus = [
    'للبيع',
    'للإيجار',
    'للاستثمار',
  ];
  
  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _areaController.dispose();
    _costController.dispose();
    _locationController.dispose();
    _locationDetailsController.dispose();
    _phoneController.dispose();
    _ownerController.dispose();
    _locationOwnerController.dispose();
    _purposeController.dispose();
    _postedController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final providerfont = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3498DB),
        title: Text(
          'إضافة عقار',
          style: TextStyle(
            fontFamily: providerfont.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                        "تفاصيل العقار :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: providerfont.fontFamily,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    

                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "رقم العقار:",
                            controller: _idController,
                            hintText: "أدخل رقم العقار",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال رقم العقار' : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "عنوان العقار:",
                            controller: _titleController,
                            hintText: "أدخل عنوان العقار",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال عنوان العقار' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    

                    Row(
                      children: [
                        Expanded(
                          child: buildDropdownField(
                            context: context,
                            label: "نوع العقار:",
                            value: _selectedType,
                            hint: "اختر نوع العقار",
                            items: _realEstateTypes,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildDropdownField(
                            context: context,
                            label: "حالة العقار:",
                            value: _selectedStatus,
                            hint: "اختر حالة العقار",
                            items: _realEstateStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "مساحة العقار:",
                            controller: _areaController,
                            hintText: "أدخل مساحة العقار",
                            suffixText: "م2",
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال مساحة العقار' : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "سعر العقار:",
                            controller: _costController,
                            hintText: "أدخل سعر العقار",
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال سعر العقار' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "موقع العقار:",
                            controller: _locationController,
                            hintText: "أدخل موقع العقار",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال موقع العقار' : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "تفاصيل الموقع:",
                            controller: _locationDetailsController,
                            hintText: "أدخل تفاصيل الموقع",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال تفاصيل الموقع' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "رقم الهاتف:",
                            controller: _phoneController,
                            hintText: "أدخل رقم الهاتف",
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "الغرض:",
                            controller: _purposeController,
                            hintText: "أدخل الغرض من العقار",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال الغرض' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "رقم صاحب العقار:",
                            controller: _ownerController,
                            hintText: "أدخل رقم صاحب العقار",
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال رقم صاحب العقار' : null,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: buildTextField(
                            context: context,
                            label: "موقع صاحب العقار:",
                            controller: _locationOwnerController,
                            hintText: "أدخل موقع صاحب العقار",
                            validator: (value) =>
                                value!.isEmpty ? 'الرجاء إدخال موقع صاحب العقار' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    buildTextField(
                            context: context,
                      label: "فيديو العقار:",
                      controller: _videoLinkController,
                      hintText: "أدخل رابط الفيديو",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'الرجاء إدخال رابط الفيديو';
                        } else if (!Uri.parse(value).isAbsolute) {
                          return 'الرجاء إدخال رابط صحيح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    buildImagePicker(
                      context: context,
                      label: "صورة العقار الرئيسية:",
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
                    SizedBox(height: 16),
                    
                    buildImagePicker(
                      context: context,
                      label: "صورة صاحب العقار:",
                      image: _ownerImage,
                      onImagePicked: (pickedFile) {
                        setState(() {
                          _ownerImage = pickedFile;
                        });
                      },
                      onImageDeleted: () {
                        setState(() {
                          _ownerImage = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    
                    buildImagePicker(
                      context: context,
                      label: "التقرير الهندسي:",
                      image: _engineeringReport,
                      onImagePicked: (pickedFile) {
                        setState(() {
                          _engineeringReport = pickedFile;
                        });
                      },
                      onImageDeleted: () {
                        setState(() {
                          _engineeringReport = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    
                    buildImagePicker(
                      context: context,
                      label: "التقرير القانوني:",
                      image: _legalReport,
                      onImagePicked: (pickedFile) {
                        setState(() {
                          _legalReport = pickedFile;
                        });
                      },
                      onImageDeleted: () {
                        setState(() {
                          _legalReport = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    
                    buildMultiImagePicker(
                      context: context,
                      label: "صور إضافية للعقار:",
                      images: _propertyImages,
                      onImagesPicked: (pickedFiles) {
                        setState(() {
                          _propertyImages.addAll(pickedFiles);
                        });
                      },
                      onImageDeleted: (image) {
                        setState(() {
                          _propertyImages.remove(image);
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    
                    if (_isLoading)
                      Center(child: CircularProgressIndicator()),
                    
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: providerfont.fontFamily,
                          ),
                        ),
                      ),
                    
                    if (_successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _successMessage!,
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: providerfont.fontFamily,
                          ),
                        ),
                      ),
                    
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C3E50),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _submitForm(),
                        icon: Icon(Icons.save),
                        label: Text(
                          "حفظ العقار",
                          style: TextStyle(
                            fontFamily: providerfont.fontFamily,
                            fontSize: 16,
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
      ),
    );
  }




  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_mainImage == null) {
      setState(() {
        _errorMessage = 'الرجاء اختيار صورة رئيسية للعقار';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {

      final String? mainImageUrl = await _uploadFile(_mainImage, 'real_estate/main_images');
      

      final String? ownerImageUrl = await _uploadFile(_ownerImage, 'real_estate/owner_images');
      

      final String? engineeringReportUrl = await _uploadFile(_engineeringReport, 'real_estate/engineering_reports');
      

      final String? legalReportUrl = await _uploadFile(_legalReport, 'real_estate/legal_reports');
      

      List<String> propertyImagesUrls = [];
      for (var image in _propertyImages) {
        final url = await _uploadFile(image, 'real_estate/property_images');
        if (url != null) {
          propertyImagesUrls.add(url);
        }
      }
      

      await FirebaseFirestore.instance.collection('real_estate').add({
        'id': _idController.text,
        'title': _titleController.text,
        'type': _selectedType,
        'status': _selectedStatus,
        'area': double.parse(_areaController.text),
        'cost': double.parse(_costController.text),
        'location': _locationController.text,
        'locationDetails': _locationDetailsController.text,
        'phone': _phoneController.text,
        'owner': _ownerController.text,
        'locationOwner': _locationOwnerController.text,
        'purpose': _purposeController.text,
        'videoLink': _videoLinkController.text,
        'mainImage': mainImageUrl,
        'ownerImage': ownerImageUrl,
        'engineeringReport': engineeringReportUrl,
        'legalReport': legalReportUrl,
        'propertyImages': propertyImagesUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });
      

      _formKey.currentState!.reset();
      setState(() {
        _selectedType = null;
        _selectedStatus = null;
        _mainImage = null;
        _ownerImage = null;
        _engineeringReport = null;
        _legalReport = null;
        _propertyImages = [];
        _successMessage = 'تم حفظ العقار بنجاح';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء حفظ العقار: ${e.toString()}';
        _isLoading = false;
      });
    }
  }


  Future<String?> _uploadFile(XFile? file, String folder) async {
    if (file == null) return null;
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
      await ref.putFile(File(file.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
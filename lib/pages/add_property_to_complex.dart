import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddPropertyToComplex extends StatefulWidget {
  const AddPropertyToComplex({Key? key}) : super(key: key);

  @override
  State<AddPropertyToComplex> createState() => _AddPropertyToComplexState();
}

class _AddPropertyToComplexState extends State<AddPropertyToComplex> {
  final _formKey = GlobalKey<FormState>();
  

  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _locationDetailsController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();

  String? _selectedType;
  String? _selectedStatus;
  String? _selectedComplex;
  DateTime? _selectedDate;
  List<String> _complexesList = [];
  bool _isLoading = false;
  bool _isLoadingComplexes = true;
  String? _errorMessage;
  String? _successMessage;

  XFile? _mainImage;
  XFile? _engineeringReport;
  XFile? _legalReport;
  List<XFile> _propertyImages = [];

  final ImagePicker _picker = ImagePicker();

  final List<String> _realEstateTypes = ["منزل", "أرض", "فيلا", "شقة"];
  final List<String> _realEstateStatus = [
    "متاح للايجار",
    "متاح للبيع",
    "تم البيع",
    "تم الإيجار"
  ];

  @override
  void initState() {
    super.initState();
    _fetchComplexes();
  }

  Future<void> _fetchComplexes() async {
    setState(() {
      _isLoadingComplexes = true;
    });
    
    try {
      final complexesSnapshot = await FirebaseFirestore.instance.collection('residential_complexes').get();
      
      List<String> complexes = [];
      for (var doc in complexesSnapshot.docs) {
        complexes.add(doc['name']);
      }
      
      setState(() {
        _complexesList = complexes;
        _isLoadingComplexes = false;
      });
    } catch (e) {
      print('Error fetching complexes: $e');
      setState(() {
        _isLoadingComplexes = false;
      });
    }
  }

  @override
  void dispose() {
    _areaController.dispose();
    _costController.dispose();
    _locationController.dispose();
    _locationDetailsController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _titleController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedComplex == null) {
        setState(() {
          _errorMessage = 'يرجى اختيار المجمع السكني';
        });
        return;
      }
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      try {
        await FirebaseFirestore.instance.collection('properties').add({
          'type': _selectedType,
          'area': _areaController.text.trim(),
          'cost': _costController.text.trim(),
          'location': _locationController.text.trim(),
          'locationDetails': _locationDetailsController.text.trim(),
          'ownerName': _ownerNameController.text.trim(),
          'ownerPhone': _ownerPhoneController.text.trim(),
          'title': _titleController.text.trim(),
          'videoLink': _videoLinkController.text.trim(),
          'status': _selectedStatus,
          'publishDate': _selectedDate ?? DateTime.now(),
          'complex': _selectedComplex,
          'isInComplex': true,
          'isInOffice': false,
          'office': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _formKey.currentState!.reset();
        _areaController.clear();
        _costController.clear();
        _locationController.clear();
        _locationDetailsController.clear();
        _ownerNameController.clear();
        _ownerPhoneController.clear();
        _titleController.clear();
        _videoLinkController.clear();
        setState(() {
          _selectedType = null;
          _selectedStatus = null;
          _selectedDate = null;
          _mainImage = null;
          _engineeringReport = null;
          _legalReport = null;
          _propertyImages = [];
          _successMessage = 'تم إضافة العقار بنجاح للمجمع السكني';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء إضافة العقار: $e';
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
      appBar: AppBar(
        title: Text('إضافة عقار لمجمع سكني'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  'إضافة عقار جديد لمجمع سكني',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                  ),
                ),
                SizedBox(height: 24),
                
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
                
                
                Text(
                  'اختيار المجمع السكني',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16),
                
                _isLoadingComplexes 
                  ? Center(child: CircularProgressIndicator())
                  : _complexesList.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد مجمعات سكنية متاحة. يرجى إضافة مجمع سكني أولاً.',
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      )
                    : buildDropdownField(
                        context: context,
                        label: 'المجمع السكني',
                        value: _selectedComplex,
                        hint: 'اختر المجمع السكني',
                        items: _complexesList,
                        onChanged: (value) {
                          setState(() {
                            _selectedComplex = value;
                          });
                        },
                      ),
                SizedBox(height: 24),
                
                
                Text(
                  'تفاصيل العقار',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16),
                
                
                buildDropdownField(
                  context: context,
                  label: 'نوع العقار',
                  value: _selectedType,
                  hint: 'اختر نوع العقار',
                  items: _realEstateTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'مساحة العقار',
                  controller: _areaController,
                  hintText: 'أدخل مساحة العقار',
                  suffixText: 'م²',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال مساحة العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'سعر العقار',
                  controller: _costController,
                  hintText: 'أدخل سعر العقار',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال سعر العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'موقع العقار',
                  controller: _locationController,
                  hintText: 'أدخل موقع العقار',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال موقع العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'تفاصيل الموقع',
                  controller: _locationDetailsController,
                  hintText: 'أدخل تفاصيل الموقع',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تفاصيل الموقع';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                Text(
                  'معلومات المالك',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'اسم المالك',
                  controller: _ownerNameController,
                  hintText: 'أدخل اسم المالك',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المالك';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'رقم هاتف المالك',
                  controller: _ownerPhoneController,
                  hintText: 'أدخل رقم هاتف المالك',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم هاتف المالك';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'عنوان العقار',
                  controller: _titleController,
                  hintText: 'أدخل عنوان العقار',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildDropdownField(
                  context: context,
                  label: 'حالة العقار',
                  value: _selectedStatus,
                  hint: 'اختر حالة العقار',
                  items: _realEstateStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'رابط الفيديو',
                  controller: _videoLinkController,
                  hintText: 'أدخل رابط الفيديو (اختياري)',
                  validator: (_) => null,
                ),
                SizedBox(height: 24),
                
                
                buildImagePicker(
                  context: context,
                  label: 'الصورة الرئيسية للعقار',
                  image: _mainImage,
                  onImagePicked: (file) {
                    setState(() {
                      _mainImage = file;
                    });
                  },
                  onImageDeleted: () {
                    setState(() {
                      _mainImage = null;
                    });
                  },
                ),
                SizedBox(height: 24),
                
                
                buildMultiImagePicker(
                  context: context,
                  label: 'صور إضافية للعقار',
                  images: _propertyImages,
                  onImagesPicked: (files) {
                    setState(() {
                      _propertyImages = files;
                    });
                  },
                  onImageDeleted: (file) {
                    setState(() {
                      _propertyImages.remove(file);
                    });
                  },
                ),
                SizedBox(height: 24),
                
                
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _submitForm,
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
                
                SizedBox(height: 24),
                
                
                buildDatePickerField(
                  context: context,
                  label: 'تاريخ النشر',
                  selectedDate: _selectedDate,
                  hint: 'اختر تاريخ النشر',
                  onDatePicked: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                buildTextField(
                  context: context,
                  label: 'موقع العقار',
                  controller: _locationController,
                  hintText: 'أدخل موقع العقار',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال موقع العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                TextFormField(
                  controller: _locationDetailsController,
                  decoration: InputDecoration(
                    labelText: 'تفاصيل الموقع',
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تفاصيل الموقع';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                Text(
                  'معلومات المالك',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                  ),
                ),
                SizedBox(height: 16),
                
                
                TextFormField(
                  controller: _ownerNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المالك',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المالك';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'رقم هاتف المالك',
                  controller: _ownerPhoneController,
                  hintText: 'أدخل رقم هاتف المالك',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم هاتف المالك';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                
                Text(
                  'تفاصيل النشر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
                  ),
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'عنوان المنشور',
                  controller: _titleController,
                  hintText: 'أدخل عنوان المنشور',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان المنشور';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                buildDropdownField(
                  context: context,
                  label: 'حالة العقار',
                  value: _selectedStatus,
                  hint: 'اختر حالة العقار',
                  items: _realEstateStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                
                buildDatePickerField(
                  context: context,
                  label: 'تاريخ النشر',
                  selectedDate: _selectedDate,
                  hint: 'اختر تاريخ النشر',
                  onDatePicked: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                SizedBox(height: 16),
                
                
                buildTextField(
                  context: context,
                  label: 'رابط الفيديو',
                  controller: _videoLinkController,
                  hintText: 'أدخل رابط الفيديو (اختياري)',
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !Uri.parse(value).isAbsolute) {
                      return 'يرجى إدخال رابط صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitForm,
                    icon: _isLoading 
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.add_home),
                    label: Text(
                      _isLoading ? 'جاري الإضافة...' : 'إضافة العقار للمجمع السكني',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
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

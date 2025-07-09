import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddPropertyToOffice extends StatefulWidget {
  const AddPropertyToOffice({Key? key}) : super(key: key);

  @override
  State<AddPropertyToOffice> createState() => _AddPropertyToOfficeState();
}

class _AddPropertyToOfficeState extends State<AddPropertyToOffice> {
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
  String? _selectedOffice;
  DateTime? _selectedDate;
  List<String> _officesList = [];
  bool _isLoading = false;
  bool _isLoadingOffices = true;
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
    _fetchOffices();
  }

  Future<void> _fetchOffices() async {
    setState(() {
      _isLoadingOffices = true;
    });
    
    try {
      final officesSnapshot = await FirebaseFirestore.instance.collection('real_estate_offices').get();
      
      List<String> offices = [];
      for (var doc in officesSnapshot.docs) {
        offices.add(doc['name']);
      }
      
      setState(() {
        _officesList = offices;
        _isLoadingOffices = false;
      });
    } catch (e) {
      print('Error fetching offices: $e');
      setState(() {
        _isLoadingOffices = false;
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
      if (_selectedOffice == null) {
        setState(() {
          _errorMessage = 'يرجى اختيار المكتب العقاري';
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
          'complex': null,
          'isInComplex': false,
          'isInOffice': true,
          'office': _selectedOffice,
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
          _successMessage = 'تم إضافة العقار بنجاح للمكتب العقاري';
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
        title: Text('إضافة عقار لمكتب عقاري',
          style: TextStyle(
            fontFamily: providerfont.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  'إضافة عقار جديد لمكتب عقاري',
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
                
                
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختيار المكتب العقاري',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: providerfont.fontFamily,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      _isLoadingOffices 
                        ? Center(child: CircularProgressIndicator())
                        : _officesList.isEmpty
                          ? Center(
                              child: Text(
                                'لا توجد مكاتب عقارية متاحة. يرجى إضافة مكتب عقاري أولاً.',
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            )
                          : buildDropdownField(
                              context: context,
                              label: 'المكتب العقاري',
                              value: _selectedOffice,
                              hint: 'اختر المكتب العقاري',
                              items: _officesList,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOffice = value;
                                });
                              },
                            ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                
                Text(
                  'تفاصيل العقار',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: providerfont.fontFamily,
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
                  controller: _areaController,
                  label: 'مساحة العقار',
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
                
                
                TextFormField(
                  controller: _costController,
                  decoration: InputDecoration(
                    labelText: 'سعر العقار',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال سعر العقار';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                
                
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'موقع العقار',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
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
                
                
                TextFormField(
                  controller: _ownerPhoneController,
                  decoration: InputDecoration(
                    labelText: 'رقم هاتف المالك',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
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
                
                
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان المنشور',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
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
                  controller: _videoLinkController,
                  label: 'رابط الفيديو',
                  hintText: 'أدخل رابط الفيديو',
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رابط الفيديو';
                    }
                    if (!Uri.parse(value).isAbsolute) {
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
                      : Icon(Icons.add_business),
                    label: Text(
                      _isLoading ? 'جاري الإضافة...' : 'إضافة العقار للمكتب العقاري',
                      style: TextStyle(fontSize: 16, fontFamily: providerfont.fontFamily),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
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

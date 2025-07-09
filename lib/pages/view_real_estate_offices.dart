import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewRealEstateOffices extends StatefulWidget {
  final bool inDrawer;
  
  const ViewRealEstateOffices({Key? key, this.inDrawer = false}) : super(key: key);

  @override
  State<ViewRealEstateOffices> createState() => _ViewRealEstateOfficesState();
}

class _ViewRealEstateOfficesState extends State<ViewRealEstateOffices> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _offices = [];

  @override
  void initState() {
    super.initState();
    _fetchOffices();
  }

  Future<void> _fetchOffices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('offices')
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> loadedOffices = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        loadedOffices.add({
          'id': doc.id,
          'name': data['name'] ?? 'بدون اسم',
          'location': data['location'] ?? 'غير محدد',
          'imageUrl': data['imageUrl'] ?? '',
          'createdAt': data['createdAt'] ?? Timestamp.now(),
        });
      }

      setState(() {
        _offices = loadedOffices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب المكاتب العقارية: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteOffice(String id, String name) async {
    bool confirmDelete = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 48),
              SizedBox(height: 16),
              Text(
                'تأكيد الحذف',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'هل أنت متأكد من حذف المكتب العقاري "$name"؟',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text('إلغاء'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text('حذف'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;

    if (confirmDelete) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await FirebaseFirestore.instance
            .collection('offices')
            .doc(id)
            .delete();
        

        await _fetchOffices();
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء حذف المكتب العقاري: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> office) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'تعديل المكتب العقاري',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              Text(
                'هل تريد تعديل المكتب العقاري "${office['name']}"؟',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_real_estate_office',
                        arguments: office,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text('متابعة التعديل'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showDetailsDialog(Map<String, dynamic> office) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.business, color: Colors.blue.shade700),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      office['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (office['imageUrl'] != null && office['imageUrl'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            office['imageUrl'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.error, size: 50),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      _detailRow(Icons.location_on, 'الموقع', office['location']),
                      _detailRow(Icons.calendar_today, 'تاريخ الإنشاء', _getFormattedDate(office)),
                      if (office['phone'] != null && office['phone'].toString().isNotEmpty)
                        _detailRow(Icons.phone, 'رقم الهاتف', office['phone']),
                      if (office['email'] != null && office['email'].toString().isNotEmpty)
                        _detailRow(Icons.email, 'البريد الإلكتروني', office['email']),
                      SizedBox(height: 16),
                      if (office['description'] != null && office['description'].toString().isNotEmpty) ...[  
                        Text(
                          'الوصف',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          office['description'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getFormattedDate(Map<String, dynamic> office) {
    if (office['creationDate'] != null) {
      try {
        final timestamp = office['creationDate'] as Timestamp;
        final date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        return 'غير محدد';
      }
    }
    return 'غير محدد';
  }
  
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المكاتب العقارية'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchOffices,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 60),
                      SizedBox(height: 16),
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchOffices,
                        child: Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : _offices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business, color: Colors.grey, size: 60),
                          SizedBox(height: 16),
                          Text('لا توجد مكاتب عقارية'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/add_real_estate_office');
                            },
                            child: Text('إضافة مكتب عقاري'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: _offices.length,
                        itemBuilder: (context, index) {
                          final office = _offices[index];
                          final timestamp = office['createdAt'] as Timestamp;
                          final date = timestamp.toDate();
                          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                          
                          return Card(
                            margin: EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  child: office['imageUrl'] != null && office['imageUrl'].isNotEmpty
                                      ? Image.network(
                                          office['imageUrl'],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 200,
                                              width: double.infinity,
                                              color: Colors.grey.shade300,
                                              child: Center(
                                                child: Icon(Icons.error_outline, size: 50),
                                              ),
                                            );
                                          },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              height: 200,
                                              width: double.infinity,
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                          child: Icon(Icons.business, size: 50),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              office['name'],
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () => _showEditDialog(office),
                                                tooltip: 'تعديل',
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _deleteOffice(
                                                  office['id'],
                                                  office['name'],
                                                ),
                                                tooltip: 'حذف',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              office['location'],
                                              style: TextStyle(color: Colors.grey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => _showDetailsDialog(office),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade700,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        ),
                                        child: Text('عرض التفاصيل'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_real_estate_office');
        },
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'إضافة مكتب عقاري جديد',
      ),
    );
  }
}

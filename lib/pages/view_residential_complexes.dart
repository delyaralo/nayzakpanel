import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel_nayzak/Provider/slected.dart';
import 'package:provider/provider.dart';

class ViewResidentialComplexes extends StatefulWidget {
  final bool inDrawer;
  
  const ViewResidentialComplexes({Key? key, this.inDrawer = false}) : super(key: key);

  @override
  State<ViewResidentialComplexes> createState() => _ViewResidentialComplexesState();
}

class _ViewResidentialComplexesState extends State<ViewResidentialComplexes> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _complexes = [];

  @override
  void initState() {
    super.initState();
    _fetchComplexes();
  }

  Future<void> _fetchComplexes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Residential Complexes')
          .orderBy('post-date', descending: true)
          .get();

      final List<Map<String, dynamic>> loadedComplexes = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        loadedComplexes.add({
          'id': doc.id,
          'title': data['title'] ?? 'بدون عنوان',
          'location': data['location'] ?? 'غير محدد',
          'description': data['description'] ?? '',
          'area': data['area'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'sliderImages': List<String>.from(data['sliderImages'] ?? []),
          'post-date': data['post-date'] ?? Timestamp.now(),
          'owner': data['owner'] ?? 'غير معروف',
        });
      }

      setState(() {
        _complexes = loadedComplexes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء جلب المجمعات السكنية: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showEditDialog(Map<String, dynamic> complex) {
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
                    'تعديل المجمع السكني',
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
                'هل تريد تعديل المجمع السكني "${complex['title']}"؟',
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
                        '/edit_residential_complex',
                        arguments: complex,
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

  void _showDetailsDialog(Map<String, dynamic> complex) {
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
                  Icon(Icons.home_work, color: Colors.blue.shade700),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      complex['title'],
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
                      if (complex['imageUrl'] != null && complex['imageUrl'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            complex['imageUrl'],
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
                      _detailRow(Icons.location_on, 'الموقع', complex['location']),
                      _detailRow(Icons.square_foot, 'المساحة', '${complex['area']} متر مربع'),
                      _detailRow(Icons.person, 'المالك', complex['owner'] ?? 'غير محدد'),
                      SizedBox(height: 16),
                      Text(
                        'الوصف',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        complex['description'],
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      if (complex['sliderImages'] != null && (complex['sliderImages'] as List).isNotEmpty) ...[
                        Text(
                          'صور إضافية',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (complex['sliderImages'] as List).length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    complex['sliderImages'][index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey.shade300,
                                      child: Icon(Icons.error, size: 30),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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





  Future<void> _deleteComplex(String id, String title) async {
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
                'هل أنت متأكد من حذف المجمع السكني "$title"؟',
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
            .collection('Residential Complexes')
            .doc(id)
            .delete();
        

        await _fetchComplexes();
      } catch (e) {
        setState(() {
          _errorMessage = 'حدث خطأ أثناء حذف المجمع السكني: $e';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildContent() {
    return _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchComplexes,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            )
          : _complexes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apartment_outlined, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('لا توجد مجمعات سكنية', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (widget.inDrawer) {
                            final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                            providerselected.selectPage('إضافة مجمع سكني');
                          } else {
                            Navigator.pushNamed(context, '/add_residential_complex');
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة مجمع سكني'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المجمعات السكنية',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (widget.inDrawer) {
                                final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                providerselected.selectPage('إضافة مجمع سكني');
                              } else {
                                Navigator.pushNamed(context, '/add_residential_complex');
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('إضافة مجمع سكني'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _complexes.length,
                          itemBuilder: (context, index) {
                            final complex = _complexes[index];
                            return _buildComplexCard(complex);
                          },
                        ),
                      ),
                    ],
                  ),
                );
  }

  @override
  Widget build(BuildContext context) {
    return widget.inDrawer ? _buildContent() : Scaffold(
      appBar: AppBar(
        title: const Text('المجمعات السكنية'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_residential_complex');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }
  
  Widget _buildComplexCard(Map<String, dynamic> complex) {
    String formattedDate = 'غير محدد';
    if (complex['post-date'] != null) {
      try {
        final timestamp = complex['post-date'] as Timestamp;
        final date = timestamp.toDate();
        formattedDate = DateFormat('yyyy-MM-dd', 'ar').format(date);
      } catch (e) {
        formattedDate = 'غير محدد';
      }
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: complex['imageUrl'] != null && complex['imageUrl'].isNotEmpty
                ? Image.network(
                    complex['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error_outline, size: 50),
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
                    child: const Icon(Icons.home_work, size: 50),
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
                        complex['title'],
                        style: const TextStyle(
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
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditDialog(complex);
                          },
                          tooltip: 'تعديل',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteComplex(
                            complex['id'],
                            complex['title'],
                          ),
                          tooltip: 'حذف',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        complex['location'],
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (complex['area'] != null && complex['area'].isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.square_foot, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${complex['area']} متر مربع',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  complex['description'],
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showDetailsDialog(complex);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('عرض التفاصيل'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

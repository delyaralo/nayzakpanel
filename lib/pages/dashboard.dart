import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:admin_panel_nayzak/constants/app_colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final int _totalUsers = 1250;
  final int _totalRealEstateOffices = 85;
  final int _totalProperties = 3720;
  final int _totalRequests = 142;


  final Map<String, double> _propertyTypes = {
    'شقق': 45.0,
    'فلل': 25.0,
    'أراضي': 15.0,
    'محلات تجارية': 10.0,
    'مكاتب': 5.0,
  };


  final Map<String, int> _propertiesByRegion = {
    'الرياض': 1200,
    'جدة': 850,
    'الدمام': 620,
    'مكة': 580,
    'المدينة': 470,
  };


  final List<Map<String, dynamic>> _recentRequests = [
    {
      'id': 'REQ-2025-0142',
      'type': 'شراء',
      'property': 'شقة',
      'location': 'الرياض - حي النزهة',
      'date': '20-06-2025',
      'status': 'جديد',
      'statusColor': Colors.green,
    },
    {
      'id': 'REQ-2025-0141',
      'type': 'إيجار',
      'property': 'فيلا',
      'location': 'جدة - حي الروضة',
      'date': '19-06-2025',
      'status': 'قيد المعالجة',
      'statusColor': Colors.amber,
    },
    {
      'id': 'REQ-2025-0140',
      'type': 'شراء',
      'property': 'أرض',
      'location': 'الدمام - حي الفيصلية',
      'date': '18-06-2025',
      'status': 'مكتمل',
      'statusColor': Colors.blue,
    },
    {
      'id': 'REQ-2025-0139',
      'type': 'إيجار',
      'property': 'محل تجاري',
      'location': 'الرياض - حي العليا',
      'date': '17-06-2025',
      'status': 'ملغي',
      'statusColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final providerfont = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'لوحة التحكم',
                  style: TextStyle(
                    fontFamily: providerfont.fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 20),
                
 
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'المستخدمين', 
                        _totalUsers.toString(),
                        Icons.people,
                        AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'المكاتب العقارية', 
                        _totalRealEstateOffices.toString(),
                        Icons.business,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'العقارات', 
                        _totalProperties.toString(),
                        Icons.home,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context, 
                        'الطلبات', 
                        _totalRequests.toString(),
                        Icons.assignment,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
 
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أنواع العقارات',
                            style: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 300,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                
                                Expanded(
                                  flex: 3,
                                  child: CustomPaint(
                                    size: Size(150, 150),
                                    painter: CircleProgressPainter(
                                      _propertyTypes.values.toList(),
                                      [
                                        Colors.blue,
                                        Colors.green,
                                        Colors.amber,
                                        Colors.purple,
                                        Colors.red,
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _propertyTypes.entries.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: _getColorForPropertyType(entry.key),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              entry.key,
                                              style: TextStyle(
                                                fontFamily: providerfont.fontFamily,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              '${entry.value.toInt()}%',
                                              style: TextStyle(
                                                fontFamily: providerfont.fontFamily,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: 24),
                    

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العقارات حسب المنطقة',
                            style: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 300,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: _propertiesByRegion.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontFamily: providerfont.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            entry.value.toString(),
                                            style: TextStyle(
                                              fontFamily: providerfont.fontFamily,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      LinearProgressIndicator(
                                        value: entry.value / _propertiesByRegion.values.reduce((a, b) => a > b ? a : b),
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                        minHeight: 8,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                
                Text(
                  'الطلبات العقارية الأخيرة',
                  style: TextStyle(
                    fontFamily: providerfont.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _recentRequests.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final request = _recentRequests[index];
                      return ListTile(
                        title: Text(
                          '${request['type']} - ${request['property']}',
                          style: TextStyle(
                            fontFamily: providerfont.fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${request['location']} | ${request['date']}',
                          style: TextStyle(
                            fontFamily: providerfont.fontFamily,
                            fontSize: 12,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: request['statusColor'].withOpacity(0.2),
                          child: Icon(
                            request['type'] == 'شراء' ? Icons.shopping_cart : Icons.home,
                            color: request['statusColor'],
                            size: 20,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: request['statusColor'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            request['status'],
                            style: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              color: request['statusColor'],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 24),
                
                
                Text(
                  'العقارات المضافة حديثاً',
                  style: TextStyle(
                    fontFamily: providerfont.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing: 20,
                            headingTextStyle: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                            dataTextStyle: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              color: Colors.black87,
                            ),
                            columns: [
                              DataColumn(label: Text('نوع العقار')),
                              DataColumn(label: Text('الموقع')),
                              DataColumn(label: Text('السعر')),
                              DataColumn(label: Text('التاريخ')),
                            ],
                            rows: [
                              _buildPropertyRow('شقة', 'الرياض - حي النزهة', '850,000 ر.س', '21-06-2025', Colors.blue, providerfont),
                              _buildPropertyRow('فيلا', 'جدة - حي الروضة', '2,500,000 ر.س', '20-06-2025', Colors.green, providerfont),
                              _buildPropertyRow('أرض', 'الدمام - حي الفيصلية', '1,200,000 ر.س', '19-06-2025', Colors.amber, providerfont),
                              _buildPropertyRow('محل تجاري', 'الرياض - حي العليا', '950,000 ر.س', '18-06-2025', Colors.purple, providerfont),
                              _buildPropertyRow('شقة', 'مكة - حي العزيزية', '750,000 ر.س', '17-06-2025', Colors.blue, providerfont),
                            ],
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
    );
  }
  
  
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final providerfont = Provider.of<LocaleProvider>(context);
    
    return Container(
      height: 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: providerfont.fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontFamily: providerfont.fontFamily,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
  
  
  DataRow _buildPropertyRow(String type, String location, String price, String date, Color color, LocaleProvider providerfont) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getPropertyIcon(type), color: color, size: 16),
              SizedBox(width: 8),
              Text(type),
            ],
          ),
        ),
        DataCell(Text(location)),
        DataCell(Text(price)),
        DataCell(Text(date)),
      ],
    );
  }
  
  
  Color _getColorForPropertyType(String type) {
    switch (type) {
      case 'شقق':
        return Colors.blue;
      case 'فلل':
        return Colors.green;
      case 'أراضي':
        return Colors.amber;
      case 'محلات تجارية':
        return Colors.purple;
      case 'مكاتب':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  
  IconData _getPropertyIcon(String type) {
    switch (type) {
      case 'شقة':
        return Icons.apartment;
      case 'فيلا':
        return Icons.home;
      case 'أرض':
        return Icons.landscape;
      case 'محل تجاري':
        return Icons.storefront;
      default:
        return Icons.business;
    }
  }
}

class CircleProgressPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  
  CircleProgressPainter(this.values, this.colors);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final total = values.reduce((a, b) => a + b);
    
    double startAngle = -math.pi / 2;
    
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = 2 * math.pi * (values[i] / total);
      
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = colors[i % colors.length];
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
    
    
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()..color = Colors.white,
    );
  }
  
  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors;
  }
}

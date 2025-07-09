import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:admin_panel_nayzak/Provider/slected.dart';
import 'package:admin_panel_nayzak/firebase_options.dart';
import 'package:admin_panel_nayzak/pages/add_property_to_complex.dart';
import 'package:admin_panel_nayzak/pages/add_property_to_office.dart';
import 'package:admin_panel_nayzak/pages/add_real_estate.dart';
import 'package:admin_panel_nayzak/pages/add_Advertise.dart';
import 'package:admin_panel_nayzak/pages/add_real_estate_office.dart';
import 'package:admin_panel_nayzak/pages/add_residential_complex.dart';
import 'package:admin_panel_nayzak/pages/dashboard.dart';
import 'package:admin_panel_nayzak/pages/view_real_estate_offices.dart';
import 'package:admin_panel_nayzak/pages/view_residential_complexes.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => PageSelectionProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم النيزك',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Cairo',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          titleTextStyle: TextStyle(color: Colors.blue.shade800, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationWrapper(),
        '/login': (context) => const LoginScreen(),
        '/add_residential_complex': (context) => AddResidentialComplex(),
        '/add_real_estate_office': (context) => AddRealEstateOffice(),
        '/add_property_to_complex': (context) => AddPropertyToComplex(),
        '/add_property_to_office': (context) => AddPropertyToOffice(),
        '/view_residential_complexes': (context) => ViewResidentialComplexes(),
        '/view_real_estate_offices': (context) => ViewRealEstateOffices(),
      },
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'فشل تسجيل الدخول: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue.shade700, Colors.blue.shade900],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.real_estate_agent,
                          size: 80,
                          color: Colors.blue.shade800,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'لوحة تحكم النيزك',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تسجيل الدخول للوحة التحكم',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16)),
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
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _fcmToken;
  
  

  
  final Map<String, IconData> drawerIcons = {
    'الرئيسية': Icons.dashboard,
    'إضافة إعلان': Icons.add_circle,
    'العقارات': Icons.home,
    'المجمعات السكنية': Icons.apartment,
    'المكاتب العقارية': Icons.business,
    'العقارات الموجودة': Icons.list,

    'الإعدادات': Icons.settings,
    'المساعدة': Icons.help,
  };
  
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $_fcmToken');
      
      if (_fcmToken != null) {
        await FirebaseFirestore.instance.collection('fcm_tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'token': _fcmToken,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Widget _buildPageContent() {
    final providerselected = Provider.of<PageSelectionProvider>(context, listen: true);
    final selectedPage = providerselected.selectedPage;

    
    if (selectedPage == 'الرئيسية') {
      return Dashboard();
    } else if (selectedPage == 'إضافة إعلان') {
       return AddAdvertise();
    } else if (selectedPage == 'العقارات') {
      return Center(child: Text('قسم العقارات', style: TextStyle(fontSize: 24)));
    } else if (selectedPage == 'إضافة عقار جديد') {
       return AddPropertyPage();
    } 
    
    else if (selectedPage == 'المجمعات السكنية') {
      return ViewResidentialComplexes(inDrawer: true);
    } else if (selectedPage == 'إضافة مجمع سكني') {
      return AddResidentialComplex(inDrawer: true);
    } 
    
    else if (selectedPage == 'المكاتب العقارية') {
      return ViewRealEstateOffices(inDrawer: true);
    } else if (selectedPage == 'إضافة مكتب عقاري') {
      return AddRealEstateOffice(inDrawer: true);
    } 
    
    else if (selectedPage == 'العقارات الموجودة') {
      return Center(child: Text('صفحة العقارات الموجودة', style: TextStyle(fontSize: 24)));
    } else if (selectedPage == 'الإعدادات') {
      return Center(child: Text('صفحة الإعدادات', style: TextStyle(fontSize: 24)));
    } else if (selectedPage == 'المساعدة') {
      return Center(child: Text('صفحة المساعدة', style: TextStyle(fontSize: 24)));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize, size: 80, color: Colors.blue.shade300),
            const SizedBox(height: 16),
            Text(
              'مرحباً بك في لوحة تحكم النيزك',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'اختر الصفحة التي تريد الانتقال إليها',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerfont = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: Row(
        children: [

          Container(
            width: 250,
            color: Colors.blue.shade900,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  color: Colors.blue.shade800,
                  child: Row(
                    children: [
                      Icon(Icons.dashboard, color: Colors.white, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'لوحة تحكم النيزك',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            fontFamily: providerfont.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 160),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              'الرئيسية',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                          
                          ListTile(
                            dense: true,
                            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                            leading: Icon(Icons.dashboard, color: Colors.white),
                            title: Text('لوحة التحكم', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                            onTap: () {
                              final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                              providerselected.selectPage('الرئيسية');
                            },
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              'العقارات',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                            
                          ExpansionTile(
                            leading: Icon(Icons.home, color: Colors.white),
                            title: Text('إدارة العقارات', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            childrenPadding: EdgeInsets.only(right: 16),
                            initiallyExpanded: false,
                            children: [
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.add_home, color: Colors.white70),
                                title: Text('إضافة عقار جديد', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('إضافة عقار جديد');
                                },
                              ),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.home_work, color: Colors.white70),
                                title: Text('العقارات الموجودة', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('العقارات الموجودة');
                                },
                              ),
                            ],
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              'المجمعات السكنية',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                          
                          ExpansionTile(
                            leading: Icon(Icons.apartment, color: Colors.white),
                            title: Text('إدارة المجمعات', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            childrenPadding: EdgeInsets.only(right: 16),
                            initiallyExpanded: false,
                            children: [
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.add_business, color: Colors.white70),
                                title: Text('إضافة مجمع سكني', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('إضافة مجمع سكني');
                                },
                              ),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.location_city, color: Colors.white70),
                                title: Text('المجمعات الموجودة', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('المجمعات السكنية');
                                },
                              ),
                            ],
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              'المكاتب العقارية',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: providerfont.fontFamily,
                              ),
                            ),
                          ),
                          
                          ExpansionTile(
                            leading: Icon(Icons.business, color: Colors.white),
                            title: Text('إدارة المكاتب', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            childrenPadding: EdgeInsets.only(right: 16),
                            initiallyExpanded: false,
                            children: [
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.add_business, color: Colors.white70),
                                title: Text('إضافة مكتب عقاري', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('إضافة مكتب عقاري');
                                },
                              ),
                              ListTile(
                                dense: true,
                                visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                                leading: Icon(Icons.business_center, color: Colors.white70),
                                title: Text('المكاتب الموجودة', style: TextStyle(color: Colors.white70, fontFamily: providerfont.fontFamily)),
                                contentPadding: EdgeInsets.only(left: 16, right: 32),
                                onTap: () {
                                  final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                                  providerselected.selectPage('المكاتب العقارية');
                                },
                              ),
                            ],
                          ),
                          
                          ListTile(
                            dense: true,
                            visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                            leading: Icon(Icons.add_circle, color: Colors.white),
                            title: Text('إضافة إعلان', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                            onTap: () {
                              final providerselected = Provider.of<PageSelectionProvider>(context, listen: false);
                              providerselected.selectPage('إضافة إعلان');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(color: Colors.white30),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Text(
                          'الإعدادات',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: providerfont.fontFamily,
                          ),
                        ),
                      ),
                      
                      ExpansionTile(
                        leading: Icon(Icons.settings, color: Colors.white),
                        title: Text('إعدادات النظام', style: TextStyle(color: Colors.white, fontFamily: providerfont.fontFamily)),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            color: Colors.blue.shade700,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, color: Colors.blue.shade700, size: 24),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'مدير النظام',
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'admin@alnayzak.com',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.person_outline, color: Colors.white70),
                            title: Text('تعديل الملف الشخصي', style: TextStyle(color: Colors.white70)),
                            onTap: () {
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.password, color: Colors.white70),
                            title: Text('تغيير كلمة المرور', style: TextStyle(color: Colors.white70)),
                            onTap: () {
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.language, color: Colors.white70),
                            title: Text('تغيير اللغة', style: TextStyle(color: Colors.white70)),
                            onTap: () {
                              final providerlang = Provider.of<LocaleProvider>(context, listen: false);
                              providerlang.setLocale(providerlang.locale?.languageCode == 'ar' ? Locale('en') : Locale('ar'));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout, color: Colors.white70),
                            title: Text('تسجيل الخروج', style: TextStyle(color: Colors.white70)),
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _buildPageContent(),
          ),
        ],
      ),
    );
  }
}
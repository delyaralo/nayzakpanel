import 'dart:io';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel_nayzak/widgets/form_components.dart';

class AddAdvertise extends StatefulWidget {
  const AddAdvertise({Key? key}) : super(key: key);

  @override
  State<AddAdvertise> createState() => _AddAdvertiseState();
}

class _AddAdvertiseState extends State<AddAdvertise> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imageUrls = [];
  List<XFile> _selectedImages = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  int _totalImages = 0;
  int _uploadedImages = 0;

  @override
  void initState() {
    super.initState();
    _fetchAds();
  }

  Future<void> _fetchAds() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Main_Banner')
          .doc('aNv5Mx81TNrQKa01WKNB')
          .get();
      final urls = List<String>.from(doc.data()?['url'] ?? []);
      setState(() {
        _imageUrls
          ..clear()
          ..addAll(urls);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تحميل الإعلانات: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) return;

    setState(() {
      _selectedImages = images;
    });

    await _uploadImages();
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      setState(() {
        _isUploading = false;
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
      _totalImages = _selectedImages.length;
      _uploadedImages = 0;
    });

    try {
      List<String> newUrls = [];
      
      for (var i = 0; i < _selectedImages.length; i++) {
        var image = _selectedImages[i];
        
        final filename = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('banner_images/$filename');

        final uploadTask = storageRef.putFile(File(image.path));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        await uploadTask.whenComplete(() => null);

        final downloadUrl = await storageRef.getDownloadURL();
        newUrls.add(downloadUrl);
        
        setState(() {
          _uploadedImages++;
          _uploadProgress = _uploadedImages / _totalImages;
        });
      }

      await _saveToFirestore([..._imageUrls, ...newUrls]);

      setState(() {
        _imageUrls.addAll(newUrls);
        _selectedImages = [];
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم رفع الصور بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل رفع الصور: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _deleteImage(int index) async {
    if (index < 0 || index >= _imageUrls.length) return;
    
    final url = _imageUrls[index];
    
    setState(() => _isSaving = true);
    
    try {
      List<String> updatedUrls = List.from(_imageUrls);
      updatedUrls.removeAt(index);
      
      await _saveToFirestore(updatedUrls);
      

      try {
        final ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      } catch (e) {
        print('Warning: Could not delete file from storage: $e');
      }
      
      setState(() {
        _imageUrls.removeAt(index);
        _isSaving = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف الصورة بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل حذف الصورة: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _saveToFirestore(List<String> urls) async {
    await FirebaseFirestore.instance
        .collection('Main_Banner')
        .doc('aNv5Mx81TNrQKa01WKNB')
        .update({'url': urls});
  }

  @override
  Widget build(BuildContext context) {
    final providerfont = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'إضافة إعلانات',
          style: TextStyle(
            fontFamily: providerfont.fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchAds,
            tooltip: 'تحديث الإعلانات',
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.primary.withOpacity(0.1)],
          ),
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'جاري التحميل...',
                      style: TextStyle(
                        fontFamily: providerfont.fontFamily,
                        fontSize: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        children: [
                          Icon(Icons.photo_library, color: Colors.blue.shade900),
                          SizedBox(width: 10),
                          Text(
                            'صور الإعلانات: ${_imageUrls.length}',
                            style: TextStyle(
                              fontFamily: providerfont.fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton.icon(
                            onPressed: _addImages,
                            icon: Icon(Icons.add_photo_alternate, size: 18),
                            label: Text(
                              'إضافة صور',
                              style: TextStyle(fontFamily: providerfont.fontFamily),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      
                      if (_isUploading)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                value: _uploadProgress,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'جاري رفع الصور... ($_uploadedImages/$_totalImages)',
                                style: TextStyle(
                                  fontFamily: providerfont.fontFamily,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(height: 20),
                      
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            if (_selectedImages.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الصور المحددة للإضافة: ${_selectedImages.length}',
                                      style: TextStyle(
                                        fontFamily: providerfont.fontFamily,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 3,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: _selectedImages.map((image) {
                                          return Stack(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: FileImage(File(image.path)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedImages.remove(image);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.danger.withOpacity(0.8),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _uploadImages,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.success,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'رفع الصور',
                                            style: TextStyle(fontFamily: providerfont.fontFamily),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            
                            
                            Text(
                              'صور الإعلانات الحالية',
                              style: TextStyle(
                                fontFamily: providerfont.fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 10),
                            
                            
                            Expanded(
                              child: _imageUrls.isEmpty
                                ? Center(
                                    child: Text(
                                      'لا توجد صور إعلانات حالياً',
                                      style: TextStyle(
                                        fontFamily: providerfont.fontFamily,
                                        fontSize: 16,
                                        color: AppColors.secondary.withOpacity(0.7),
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: EdgeInsets.all(8),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: _imageUrls.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: _imageUrls[index],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                placeholder: (context, url) => Container(
                                                  color: Colors.grey.shade200,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: Colors.grey.shade200,
                                                  child: Icon(Icons.error, color: AppColors.danger),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: InkWell(
                                              onTap: () => _deleteImage(index),
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.danger.withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
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
}

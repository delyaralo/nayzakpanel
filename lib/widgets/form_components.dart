import 'package:flutter/material.dart';
import 'package:admin_panel_nayzak/Provider/lang.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class AppColors {
  static const Color primary = Color(0xFF3498DB);
  static const Color secondary = Color(0xFF2C3E50);
  static const Color background = Color(0xFFECF0F1);
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color lightGrey = Color(0xFFE0E0E0);
}


Widget buildDropdownField({
  required BuildContext context,
  required String label,
  required String? value,
  required String hint,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  final providerfont = Provider.of<LocaleProvider>(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: providerfont.fontFamily,
            fontSize: 14,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey.shade300,
            ),
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hint,
              style: TextStyle(
                fontFamily: providerfont.fontFamily,
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontFamily: providerfont.fontFamily,
              fontSize: 14,
              color: Colors.black87,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((
              String value,
            ) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}


Widget buildDatePickerField({
  required BuildContext context,
  required String label,
  required DateTime? selectedDate,
  required String hint,
  required void Function(DateTime) onDatePicked,
}) {
  final providerfont = Provider.of<LocaleProvider>(context);
  String formattedDate = selectedDate != null 
      ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
      : hint;
      
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: providerfont.fontFamily,
            fontSize: 14,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.secondary,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              onDatePicked(pickedDate);
            }
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontFamily: providerfont.fontFamily,
                    fontSize: 14,
                    color: selectedDate != null ? Colors.black87 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget buildTextField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required String hintText,
  String? suffixText,
  TextInputType keyboardType = TextInputType.text,
  required String? Function(String?) validator,
  Icon? prefixIcon,
  int? maxLines = 1,
}) {
  final providerfont = Provider.of<LocaleProvider>(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: providerfont.fontFamily,
            fontSize: 14,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey.shade300,
            ),
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontFamily: providerfont.fontFamily),
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: providerfont.fontFamily,
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              suffixText: suffixText,
              suffixStyle: TextStyle(color: AppColors.secondary),
              prefixIcon: prefixIcon,
            ),
            validator: validator,
          ),
        ),
      ],
    ),
  );
}


Widget buildImagePicker({
  required BuildContext context,
  required String label,
  required XFile? image,
  required void Function(XFile?) onImagePicked,
  required void Function() onImageDeleted,
}) {
  final providerfont = Provider.of<LocaleProvider>(context);
  final ImagePicker picker = ImagePicker();
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: providerfont.fontFamily,
            fontSize: 14,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(height: 10),
        if (image != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(image.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppColors.danger),
                  onPressed: onImageDeleted,
                ),
              ],
            ),
          )
        else
          InkWell(
            onTap: () async {
              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                onImagePicked(pickedFile);
              }
            },
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade300, style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 40),
                  SizedBox(height: 5),
                  Text(
                    'اختر صورة',
                    style: TextStyle(
                      fontFamily: providerfont.fontFamily,
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}


Widget buildMultiImagePicker({
  required BuildContext context,
  required String label,
  required List<XFile> images,
  required void Function(List<XFile>) onImagesPicked,
  required void Function(XFile) onImageDeleted,
}) {
  final providerfont = Provider.of<LocaleProvider>(context);
  final ImagePicker picker = ImagePicker();
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: providerfont.fontFamily,
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
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: images.map((image) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(image.path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: -5,
                              top: -5,
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => onImageDeleted(image),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.close, size: 16, color: AppColors.danger),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              InkWell(
                onTap: () async {
                  final pickedFiles = await picker.pickMultiImage();
                  if (pickedFiles.isNotEmpty) {
                    onImagesPicked(pickedFiles);
                  }
                },
                child: Container(
                  height: 80,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: AppColors.primary, size: 30),
                      SizedBox(height: 5),
                      Text(
                        'إضافة صور',
                        style: TextStyle(
                          fontFamily: providerfont.fontFamily,
                          fontSize: 12,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

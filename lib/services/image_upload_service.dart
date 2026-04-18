// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to upload images to ImgBB (free CDN)
/// No Firebase Storage billing required
class ImageUploadService {

  static const String _apiKey = '25f2fdda3a7d61543363500454a371de';
  
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  static Future<String> uploadImage(File imageFile) async {
    try {
      print('📤 Starting image upload to ImgBB...');

      // Read image as bytes
      final bytes = await imageFile.readAsBytes();
      
      // Convert to base64
      final base64Image = base64Encode(bytes);

      // Prepare the request
      final response = await http.post(
        Uri.parse('$_uploadUrl?key=$_apiKey'),
        body: {
          'image': base64Image,
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Upload timeout - please check your connection');
        },
      );

      // Check response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final imageUrl = data['data']['url'] as String;
          print('Image uploaded successfully!');
          print('URL: $imageUrl');
          return imageUrl;
        } else {
          throw Exception('Upload failed: ${data['error']['message']}');
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Image upload error: $e');
      rethrow;
    }
  }
  /// Validate API key is set
  static bool isConfigured() {
    return _apiKey != 'yor api here' && _apiKey.isNotEmpty;
  }
}
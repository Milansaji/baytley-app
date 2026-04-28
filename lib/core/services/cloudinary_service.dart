import 'package:http/http.dart' as http;
import 'dart:io';

class CloudinaryService {
  // Cloudinary credentials
  static const String cloudName = '874d49a4-779a-4506-b6a7-8620dab97476';
  static const String uploadPreset = 'baytley_uploads';
  
  // Cloudinary API endpoints
  static final String _uploadUrl = 
    'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static final String _deleteUrl = 
    'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';

  /// Upload a file to Cloudinary
  /// Returns the secure URL of the uploaded image
  static Future<String> uploadFile(File file) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      
      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
      
      // Add upload preset for unsigned uploads
      request.fields['upload_preset'] = uploadPreset;
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        // Parse the response to get the secure URL
        // Response contains JSON with 'secure_url' field
        final jsonResponse = _parseJsonResponse(responseBody);
        final secureUrl = jsonResponse['secure_url'] as String?;
        
        if (secureUrl != null) {
          return secureUrl;
        } else {
          throw Exception('No secure_url in response');
        }
      } else {
        throw Exception('Upload failed: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  /// Delete an image from Cloudinary using its public ID
  /// You need to extract the public ID from the URL
  static Future<void> deleteFile(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) {
        return; // No image to delete
      }

      // Extract public ID from the secure URL
      // URL format: https://res.cloudinary.com/{cloudName}/image/upload/{version}/{publicId}
      // We need to extract the public ID
      final publicId = _extractPublicIdFromUrl(imageUrl);
      
      if (publicId.isEmpty) {
        throw Exception('Could not extract public ID from URL');
      }

      final request = http.MultipartRequest('POST', Uri.parse(_deleteUrl));
      
      // Add public ID
      request.fields['public_id'] = publicId;
      
      // Add upload preset for unsigned deletes
      request.fields['upload_preset'] = uploadPreset;
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode != 200) {
        throw Exception('Delete failed: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      print('Error deleting file: $e');
      // Don't throw - allow deletion to fail silently as it's not critical
    }
  }

  /// Extract public ID from Cloudinary URL
  static String _extractPublicIdFromUrl(String url) {
    try {
      // URL format: https://res.cloudinary.com/{cloudName}/image/upload/{version}/{publicId}
      // Example: https://res.cloudinary.com/cloudname/image/upload/v1234567890/publicid
      
      if (!url.contains('cloudinary.com')) {
        return '';
      }
      
      // Split by 'upload/' and get the part after it
      final parts = url.split('upload/');
      if (parts.length < 2) {
        return '';
      }
      
      final afterUpload = parts[1];
      
      // Remove version prefix if it exists (v1234567890/)
      final versionPattern = RegExp(r'^v\d+/');
      final withoutVersion = afterUpload.replaceFirst(versionPattern, '');
      
      // Remove file extension
      final publicId = withoutVersion.split('.').first;
      
      return publicId.isNotEmpty ? publicId : '';
    } catch (e) {
      print('Error extracting public ID: $e');
      return '';
    }
  }

  /// Parse JSON response from Cloudinary
  static Map<String, dynamic> _parseJsonResponse(String responseBody) {
    try {
      // Simple JSON parsing without external dependencies
      // Looking for "secure_url": "value"
      final secureUrlPattern = RegExp(r'"secure_url"\s*:\s*"([^"]*)"');
      final match = secureUrlPattern.firstMatch(responseBody);
      
      if (match != null && match.groupCount >= 1) {
        return {'secure_url': match.group(1)};
      }
      
      return {};
    } catch (e) {
      print('Error parsing response: $e');
      return {};
    }
  }
}

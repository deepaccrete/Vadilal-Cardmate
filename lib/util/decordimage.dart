import 'dart:convert';
import 'dart:typed_data';


Uint8List? decodeBase64Image(String base64String) {
  try {
    if (base64String.isEmpty) return null;

    String cleanBase64 = base64String;

    if (cleanBase64.startsWith('data:')) {
      int commaIndex = cleanBase64.indexOf(',');
      if (commaIndex != -1) {
        cleanBase64 = cleanBase64.substring(commaIndex + 1);
      }
    }

    cleanBase64 = cleanBase64.replaceAll(RegExp(r'[\s\n]'), '');
    int paddingLength = cleanBase64.length % 4;
    if (paddingLength > 0) {
      cleanBase64 += '=' * (4 - paddingLength);
    }

    var bytes = base64Decode(cleanBase64);

    String decodedString = String.fromCharCodes(bytes);
    if (decodedString.contains('base64,')) {
      String secondBase64 = decodedString.split('base64,').last;
      secondBase64 = secondBase64.replaceAll(RegExp(r'[\s\n]'), '');
      paddingLength = secondBase64.length % 4;
      if (paddingLength > 0) {
        secondBase64 += '=' * (4 - paddingLength);
      }
      bytes = base64Decode(secondBase64);
    }

    if (bytes.length > 8) {
      if ((bytes[0] == 0xFF && bytes[1] == 0xD8) || // JPEG
          (bytes[0] == 0x89 && bytes[1] == 0x50) || // PNG
          (bytes[0] == 0x47 && bytes[1] == 0x49)) { // GIF
        return bytes;
      }
    }

    return bytes;
  } catch (_) {
    return null;
  }
}



// void _decodeCardImages() {
//   print('\nProcessing front image...');
//   if (widget.dataCard.cardFrontImageBase64 != null && widget.dataCard.cardFrontImageBase64!.isNotEmpty) {
//     final frontImage = decodeBase64Image(widget.dataCard.cardFrontImageBase64!);
//     if (frontImage != null) {
//       images.add(frontImage);
//       print('Successfully added front image');
//     } else {
//       print('Failed to decode front image');
//     }
//   } else {
//     print('No front image data available');
//   }
//
//   print('\nProcessing back image...');
//   if (widget.dataCard.cardBackImageBase64 != null && widget.dataCard.cardBackImageBase64!.isNotEmpty) {
//     final backImage = decodeBase64Image(widget.dataCard.cardBackImageBase64!);
//     if (backImage != null) {
//       images.add(backImage);
//       print('Successfully added back image');
//     } else {
//       print('Failed to decode back image');
//     }
//   } else {
//     print('No back image data available');
//   }
//
//   print('\nFinal results:');
//   print('Total images decoded: ${images.length}');
// }
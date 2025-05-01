import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

String preprocessPictureUrl(String pictureUrl, String baseUrl) {
  if (pictureUrl.startsWith(baseUrl)) {
    return pictureUrl;
  } else {
    return baseUrl + pictureUrl;
  }
}

void displayErrorToast(String message) {
  showToast(
    message,
    position: ToastPosition.bottom,
    duration: const Duration(milliseconds: 2000),
    backgroundColor: Colors.grey.shade300,
    textStyle: const TextStyle(color: Colors.black, fontSize: 16),
    textPadding: const EdgeInsets.all(8),
  );
}




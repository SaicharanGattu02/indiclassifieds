import 'dart:io';
import 'package:dio/dio.dart';


abstract class RemoteDataSource {

}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      // Handle list of files (e.g., portfolio[])
      if (value is List<File> && key == 'portfolio') {
        formMap.addAll({
          for (int i = 0; i < value.length; i++)
            'portfolio[]': await MultipartFile.fromFile(
              value[i].path,
              filename: value[i].path.split('/').last,
            ),
        });
      } else if (value is List<String> && key == 'specializations') {
        formMap.addAll({for (final item in value) 'specializations[]': item});
      }
      // Handle single file (e.g., document)
      else if (value is File) {
        formMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      }
      // Handle normal fields
      else {
        formMap[key] = value.toString().trim();
      }
    }

    return FormData.fromMap(formMap);
  }

}

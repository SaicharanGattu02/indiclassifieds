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
      final isFile =
          value is String &&
          value.contains('/') &&
          (key.contains('image') ||
              key.contains('aadhar_card_front') ||
              key.contains('aadhar_card_back') ||
              key.contains('pan_card_front') ||
              key.contains('pan_card_back') ||
              key.contains('driving_license_front') ||
              key.contains('driving_license_back') ||
              key.contains('signature'));
      if (isFile) {
        formMap[key] = await MultipartFile.fromFile(
          value,
          filename: value.split('/').last,
        );
      } else {
        formMap[key] = value;
      }
    }

    return FormData.fromMap(formMap);
  }

}

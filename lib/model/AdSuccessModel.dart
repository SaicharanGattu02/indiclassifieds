class AdSuccessModel {
  final bool? success;
  final String? message;
  final String? error;
  final int? listingId;

  AdSuccessModel({
    this.success,
    this.message,
    this.error,
    this.listingId,
  });

  /// Factory constructor for creating an instance from JSON
  factory AdSuccessModel.fromJson(Map<String, dynamic> json) {
    return AdSuccessModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      listingId: json['listing_id'] as int?,
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'listing_id': listingId,
    };
  }

  /// Optional: Copy with new values
  AdSuccessModel copyWith({
    bool? success,
    String? message,
    String? error,
    int? listingId,
  }) {
    return AdSuccessModel(
      success: success ?? this.success,
      message: message ?? this.message,
      error: error ?? this.error,
      listingId: listingId ?? this.listingId,
    );
  }
}

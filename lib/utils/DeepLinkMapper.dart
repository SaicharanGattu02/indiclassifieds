// lib/deep_link_mapper.dart
import 'package:flutter/cupertino.dart';

class DeepLinkMapper {
  /// Returns a go_router location (e.g. '/products_details?listingId=130&subcategory_id=175')
  /// or null if we don't recognize the link.
  static String? toLocation(Uri? uri) {
    if (uri == null) {
        debugPrint('DeepLinkMapper: received null uri');
      return null;
    }

    debugPrint('DeepLinkMapper: parsing uri -> $uri');

    final host = uri.host.toLowerCase();
    final isOurDomain =
        host == 'indclassifieds.in' || host == 'www.indclassifieds.in';
    debugPrint('DeepLinkMapper: host=$host isOurDomain=$isOurDomain');

    // Only handle HTTPS links for our domain. (Add custom scheme support if you use one.)
    if (uri.scheme == 'https' && !isOurDomain) {
      debugPrint('DeepLinkMapper: not our domain, ignoring');
      return null;
    }

    final segs = uri.pathSegments; // e.g. ["singlelistingdetails","130"]
    debugPrint('DeepLinkMapper: pathSegments=$segs');

    if (segs.isNotEmpty && segs.first == 'singlelistingdetails') {
      final detailId = (segs.length >= 2) ? segs[1] : null; // "130"
      debugPrint('DeepLinkMapper: detailId=$detailId');
      if (detailId == null || detailId.isEmpty) {
        debugPrint('DeepLinkMapper: detailId missing, ignoring');
        return null;
      }

      // Web uses ?detailId=175. Your app route expects subcategory_id.
      final listingId = uri.queryParameters['detailId'] ?? '0';
      debugPrint('DeepLinkMapper: queryParam.detailId=$listingId');

      // Build your existing in-app location:
      final location =
          '/products_details?listingId=$listingId&subcategory_id=$detailId';

      debugPrint('DeepLinkMapper: mapped to location=$location');
      return location;
    }

    debugPrint('DeepLinkMapper: no matching pattern, ignoring');
    return null;
  }
}


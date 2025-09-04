// lib/deep_link_mapper.dart
import 'package:flutter/cupertino.dart';

class DeepLinkMapper {
  /// Maps an incoming URI to an internal go_router *location* string,
  /// e.g. '/products_details?listingId=130&subcategory_id=175'.
  static String? toLocation(Uri? uri) {
    if (uri == null) {
      debugPrint('DeepLinkMapper: received null uri');
      return null;
    }

    debugPrint('DeepLinkMapper: parsing -> $uri');

    // Allow internal (no-scheme) and explicit https. Reject foreign https hosts.
    if (uri.hasScheme) {
      final scheme = uri.scheme.toLowerCase();
      if (scheme == 'https') {
        final host = uri.host.toLowerCase();
        final isOurDomain =
            host == 'indclassifieds.in' || host == 'www.indclassifieds.in';
        debugPrint('DeepLinkMapper: https host=$host ours=$isOurDomain');
        if (!isOurDomain) {
          debugPrint('DeepLinkMapper: foreign https host, ignore');
          return null;
        }
      } else {
        // If you also support a custom scheme, whitelist it here.
        // if (scheme != 'indclassifieds') return null;
        debugPrint('DeepLinkMapper: non-https scheme "$scheme" allowed');
      }
    }

    final segs = uri.pathSegments.where((s) => s.isNotEmpty).map((s) => s.toLowerCase()).toList();
    debugPrint('DeepLinkMapper: segs=$segs query=${uri.queryParameters}');

    // --- Single Listing Details ---
    final isSingle =
        segs.isNotEmpty && segs.first == 'singlelistingdetails';

    if (isSingle) {
      // We’ve seen two variants in the wild:
      // 1) /singlelistingdetails/:subcategoryId?detailId=:listingId
      // 2) /singlelistingdetails?subcategory_id=:subcategoryId&detailId=:listingId

      // Try to read both ways, with sensible fallbacks.
      final subcatFromPath = segs.length >= 2 ? segs[1] : null;
      final listingFromQuery = uri.queryParameters['detailId'];

      // Also accept alternative param names just in case.
      final subcatFromQuery =
          uri.queryParameters['subcategory_id'] ?? uri.queryParameters['subCatId'];
      final listingAlt =
          uri.queryParameters['listingId'] ?? uri.queryParameters['id'];

      // Decide final values
      final listingId = listingFromQuery ?? listingAlt;
      final subcategoryId = subcatFromPath ?? subcatFromQuery;

      if (listingId == null || listingId.isEmpty) {
        debugPrint('DeepLinkMapper: listingId missing, ignore');
        return null;
      }

      // Build location safely (properly encoded).
      final qp = <String, String>{
        'listingId': listingId,
        if (subcategoryId != null && subcategoryId.isNotEmpty)
          'subcategory_id': subcategoryId,
      };
      final loc = Uri(path: '/products_details', queryParameters: qp).toString();
      debugPrint('DeepLinkMapper: mapped -> $loc');
      return loc;
    }

    // TODO: Add other patterns here (chat, search, category, etc.)

    debugPrint('DeepLinkMapper: no match, ignore');
    return null;
  }
}



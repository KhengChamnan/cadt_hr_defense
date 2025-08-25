import 'package:geocoding/geocoding.dart';

/// Utility class for formatting addresses in Cambodia-specific format
class CambodiaAddressFormatter {
  
  /// Format address specifically for Cambodia with proper structure
  static String formatCambodianAddress(Placemark place) {
    List<String> addressLines = [];
    
    // Line 1: Street number and street name
    String streetLine = _buildStreetLine(place);
    if (streetLine.isNotEmpty) {
      addressLines.add(streetLine);
    }
    
    // Line 2: Sublocality (Borey/Village) and Administrative areas (Sankat)
    String localityLine = _buildLocalityLine(place);
    if (localityLine.isNotEmpty) {
      addressLines.add(localityLine);
    }
    
    // Line 3: Administrative area (Khan) and City/Country
    String adminLine = _buildAdminLine(place);
    if (adminLine.isNotEmpty) {
      addressLines.add(adminLine);
    }
    
    // If we have no proper address, create a fallback
    if (addressLines.isEmpty) {
      addressLines.add('Current Location');
      addressLines.add('Phnom Penh, Cambodia');
    }
    
    return addressLines.join('\n');
  }
  
  /// Build street line (street number + street name)
  static String _buildStreetLine(Placemark place) {
    List<String> streetParts = [];
    
    // Add street number if available
    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      streetParts.add('#${place.subThoroughfare!}');
    }
    
    // Add street name if available
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      String streetName = place.thoroughfare!;
      
      // Format street name in Cambodian style
      if (!streetName.toLowerCase().startsWith('st.') && 
          !streetName.toLowerCase().startsWith('street')) {
        // Check if it's a number, then format as "St.XX"
        final streetNumber = int.tryParse(streetName);
        if (streetNumber != null) {
          streetName = 'St.$streetNumber';
        }
      }
      
      streetParts.add(streetName);
    }
    
    return streetParts.join(', ');
  }
  
  /// Build locality line (Borey/Village + Sankat)
  static String _buildLocalityLine(Placemark place) {
    List<String> localityParts = [];
    
    // Add sublocality (Borey, Village, etc.)
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      String subLocality = place.subLocality!;
      
      // Add "Borey" prefix if it's not already there and looks like a development name
      if (!subLocality.toLowerCase().contains('borey') && 
          !subLocality.toLowerCase().contains('village') &&
          !subLocality.toLowerCase().contains('commune')) {
        subLocality = 'Borey $subLocality';
      }
      
      localityParts.add(subLocality);
    }
    
    // Add Sankat (sub-administrative area)
    if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
      String sankat = place.subAdministrativeArea!;
      
      // Add "Sankat" prefix if not already there
      if (!sankat.toLowerCase().contains('sankat') &&
          !sankat.toLowerCase().contains('commune')) {
        sankat = 'Sankat $sankat';
      }
      
      localityParts.add(sankat);
    }
    
    return localityParts.join(', ');
  }
  
  /// Build administrative line (Khan + City/Country)
  static String _buildAdminLine(Placemark place) {
    List<String> adminParts = [];
    
    // Add Khan (administrative area)
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      String khan = place.administrativeArea!;
      
      // Add "Khan" prefix if not already there
      if (!khan.toLowerCase().contains('khan') &&
          !khan.toLowerCase().contains('district')) {
        khan = 'Khan $khan';
      }
      
      adminParts.add(khan);
    }
    
    // Add city and country
    List<String> locationParts = [];
    
    if (place.locality != null && place.locality!.isNotEmpty) {
      locationParts.add(place.locality!);
    } else {
      // Default to Phnom Penh if no locality
      locationParts.add('Phnom Penh');
    }
    
    if (place.country != null && place.country!.isNotEmpty) {
      locationParts.add(place.country!);
    } else {
      // Default to Cambodia if no country
      locationParts.add('Cambodia');
    }
    
    adminParts.addAll(locationParts);
    
    return adminParts.join(', ');
  }
  
  /// Create a sample formatted address for testing
  static String createSampleAddress() {
    return '#161, St.24, Borey Pipumthmey\nChoukva2, Sankat Samrong Krom, Khan Porcheny Chey, Phnom Penh,\nCambodia';
  }
  
  /// Validate if address looks like a proper Cambodian format
  static bool isValidCambodianFormat(String address) {
    // Check if address contains typical Cambodian administrative terms
    final lowerAddress = address.toLowerCase();
    return lowerAddress.contains('sankat') || 
           lowerAddress.contains('khan') || 
           lowerAddress.contains('borey') ||
           lowerAddress.contains('phnom penh') ||
           lowerAddress.contains('cambodia');
  }
}

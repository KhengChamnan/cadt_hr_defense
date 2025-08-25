import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// CompanyProfileCard displays detailed company information
/// - Shows company logo
/// - Displays company name
/// - Shows industry information
/// - Provides main contact information
/// - Shows company location
class CompanyProfileCard extends StatelessWidget {
  final String logoPath;
  final String companyName;
  final String? industry;
  final String contactInfo;
  final String location;
  
  const CompanyProfileCard({
    Key? key,
    required this.logoPath,
    required this.companyName,
     this.industry,
    required this.contactInfo,
    required this.location,
  }) : super(key: key);

  // Helper method to determine if the logoPath is a URL or local asset
  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract phone and email from contactInfo
    final parts = contactInfo.split('|');
    final phone = parts[0].trim();
    final email = parts.length > 1 ? parts[1].trim() : '';

    return Container(
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius - 3),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PalmColors.backgroundAccent,
                  ),
                  child: ClipOval(
                    child: Image(
                      image: _getImageProvider(logoPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to default logo if image fails to load
                        return Image.asset(
                          'assets/images/palm_logo.png',
                          fit: BoxFit.cover,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const SizedBox(width: PalmSpacings.m),
                
                // Company Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Name
                      Text(
                        companyName,
                        style: PalmTextStyles.title.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PalmColors.dark,
                        ),
                      ),
                      
                      const SizedBox(height: PalmSpacings.s / 2),
                      
                      // // Industry
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.business_center,
                      //       size: 16,
                      //       color: PalmColors.neutralLight,
                      //     ),
                      //     const SizedBox(width: 4),
                      //     Text(
                      //       'Industry: $industry',
                      //       style: PalmTextStyles.label.copyWith(
                      //         color: PalmColors.neutralLight,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      
                      const SizedBox(height: PalmSpacings.s / 2),
                      
                      // Phone Contact Info
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: PalmColors.neutralLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            phone,
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.neutralLight,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: PalmSpacings.s / 2),
                      
                      // Email Contact Info
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 16,
                            color: PalmColors.neutralLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            email,
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.neutralLight,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: PalmSpacings.s / 2),
                      
                      // Location Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: PalmColors.neutralLight,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: PalmTextStyles.label.copyWith(
                                color: PalmColors.neutralLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: PalmSpacings.s),
            
            // Edit Button
           
          ],
        ),
      ),
    );
  }
} 
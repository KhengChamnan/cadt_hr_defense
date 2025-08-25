import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// CompanyProfileHeader displays company profile information
/// - Shows company logo
/// - Displays company name and tagline
/// - Provides an edit button for company profile
class CompanyProfileHeader extends StatelessWidget {
  final String logoPath;
  final String companyName;
  final String tagline;
  
  const CompanyProfileHeader({
    Key? key,
    required this.logoPath,
    required this.companyName,
    required this.tagline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(PalmSpacings.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo and Company Info
            Row(
              children: [
                _buildCompanyLogo(),
                const SizedBox(width: PalmSpacings.s),
                _buildCompanyInfo(),
              ],
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: PalmIcons.size - 8,
              color: PalmColors.dark,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the company logo with edit button
  Widget _buildCompanyLogo() {
    return Stack(
      children: [
        // Company Logo
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PalmColors.backgroundAccent,
            image: DecorationImage(
              image: AssetImage(logoPath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Edit Button
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: PalmColors.success,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.edit,
                size: 10,
                color: PalmColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the company name and tagline information
  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          companyName,
          style: PalmTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: PalmColors.dark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          tagline,
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.neutralLight,
          ),
        ),
      ],
    );
  }
} 
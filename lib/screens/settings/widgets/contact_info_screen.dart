import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// ContactInfoScreen displays detailed contact information
/// - Shows contact details in a professional layout
/// - Provides interactive elements (call, email, map)
/// - Consistent with app's design patterns
class ContactInfoScreen extends StatelessWidget {
  final ContactUs contactInfo;

  const ContactInfoScreen({
    Key? key,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: AppBar(
        backgroundColor: PalmColors.backGroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Contact Us',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Contact Methods
            _buildContactMethods(),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Address Section
            _buildAddressSection(),
            
            const SizedBox(height: PalmSpacings.l),
            
            // Social Media Section
            _buildSocialMediaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document type
        Text(
          'SUPPORT',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: PalmSpacings.s),
        
        // Description (removed redundant "Contact Us" title)
        Text(
          'Get in touch with our support team for any questions or assistance.',
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.neutralLight,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildContactMethods() {
    final contactMethods = <Map<String, dynamic>>[];
    
    // Build list of available contact methods
    if (contactInfo.phone.isNotEmpty) {
      contactMethods.add({
        'icon': Icons.phone,
        'title': 'Phone',
        'subtitle': contactInfo.phone,
        'onTap': () => _launchPhone(contactInfo.phone),
        'color': PalmColors.success,
      });
    }
    
    if (contactInfo.email.isNotEmpty) {
      contactMethods.add({
        'icon': Icons.email,
        'title': 'Email',
        'subtitle': contactInfo.email,
        'onTap': () => _launchEmail(contactInfo.email),
        'color': PalmColors.primary,
      });
    }
    
    if (contactInfo.website.isNotEmpty) {
      contactMethods.add({
        'icon': Icons.language,
        'title': 'Website',
        'subtitle': contactInfo.website,
        'onTap': () => _launchUrl(contactInfo.website),
        'color': PalmColors.secondary,
      });
    }

    if (contactMethods.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Methods',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.neutralDark,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: PalmSpacings.m),
        
        // Grouped contact methods without spacing
        Container(
          decoration: BoxDecoration(
            color: PalmColors.white,
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
            boxShadow: [
              BoxShadow(
                color: PalmColors.dark.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: contactMethods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              final isFirst = index == 0;
              final isLast = index == contactMethods.length - 1;
              
              return _buildContactListTile(
                icon: method['icon'],
                title: method['title'],
                subtitle: method['subtitle'],
                onTap: method['onTap'],
                color: method['color'],
                isFirst: isFirst,
                isLast: isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required bool isFirst,
    required bool isLast,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? PalmSpacings.radius : 0),
            topRight: Radius.circular(isFirst ? PalmSpacings.radius : 0),
            bottomLeft: Radius.circular(isLast ? PalmSpacings.radius : 0),
            bottomRight: Radius.circular(isLast ? PalmSpacings.radius : 0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(PalmSpacings.m),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PalmSpacings.s),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: PalmSpacings.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: PalmTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: PalmColors.neutralDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.neutral,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: PalmColors.neutral,
                ),
              ],
            ),
          ),
        ),
        // Divider between items (except for last item)
        if (!isLast)
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(left: 68), // Align with text content
            color: PalmColors.greyLight,
          ),
      ],
    );
  }

  Widget _buildAddressSection() {
    if (contactInfo.address.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Location',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.neutralDark,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: PalmSpacings.m),
        
        Container(
          decoration: BoxDecoration(
            color: PalmColors.white,
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
            boxShadow: [
              BoxShadow(
                color: PalmColors.dark.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _openMap(),
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
            child: Padding(
              padding: const EdgeInsets.all(PalmSpacings.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(PalmSpacings.s),
                    decoration: BoxDecoration(
                      color: PalmColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: PalmColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: PalmSpacings.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: PalmTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: PalmColors.neutralDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contactInfo.address,
                          style: PalmTextStyles.body.copyWith(
                            color: PalmColors.neutral,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: PalmSpacings.s),
                        Text(
                          'Tap to open in Maps',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    final socialLinks = [
      if (contactInfo.facebook.isNotEmpty) 
        {'icon': Icons.facebook, 'name': 'Facebook', 'url': contactInfo.facebook},
      if (contactInfo.instagram.isNotEmpty) 
        {'icon': Icons.camera_alt, 'name': 'Instagram', 'url': contactInfo.instagram},
      if (contactInfo.youtube.isNotEmpty) 
        {'icon': Icons.play_arrow, 'name': 'YouTube', 'url': contactInfo.youtube},
      if (contactInfo.telegram.isNotEmpty) 
        {'icon': Icons.send, 'name': 'Telegram', 'url': contactInfo.telegram},
      if (contactInfo.tiktok.isNotEmpty) 
        {'icon': Icons.music_note, 'name': 'TikTok', 'url': contactInfo.tiktok},
    ];

    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow Us',
          style: PalmTextStyles.title.copyWith(
            fontWeight: FontWeight.bold,
            color: PalmColors.neutralDark,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: PalmSpacings.m),
        
        Wrap(
          spacing: PalmSpacings.m,
          runSpacing: PalmSpacings.m,
          children: socialLinks.map((social) {
            return InkWell(
              onTap: () => _launchUrl(social['url'] as String),
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: PalmColors.white,
                  borderRadius: BorderRadius.circular(PalmSpacings.radius),
                  border: Border.all(color: PalmColors.primary.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: PalmColors.dark.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      social['icon'] as IconData,
                      color: PalmColors.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      social['name'] as String,
                      style: PalmTextStyles.label.copyWith(
                        color: PalmColors.neutral,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMap() async {
    try {
      String mapUrl;
      
      if (contactInfo.hasValidCoordinates) {
        final lat = contactInfo.latitudeDouble!;
        final lng = contactInfo.longitudeDouble!;
        // Use Google Maps URL for web compatibility
        mapUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      } else {
        // Use Google Maps search URL for address
        final encodedAddress = Uri.encodeComponent(contactInfo.address);
        mapUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
      }
      
      final Uri mapUri = Uri.parse(mapUrl);
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(mapUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for mobile devices - try geo scheme
        String fallbackUrl;
        if (contactInfo.hasValidCoordinates) {
          final lat = contactInfo.latitudeDouble!;
          final lng = contactInfo.longitudeDouble!;
          fallbackUrl = 'geo:$lat,$lng?q=$lat,$lng';
        } else {
          fallbackUrl = 'geo:0,0?q=${Uri.encodeComponent(contactInfo.address)}';
        }
        
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri);
        }
      }
    } catch (e) {
      // Handle error silently or show a message
      print('Error opening map: $e');
    }
  }
} 
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/phone_model.dart'; // Import your PhoneModel

class PhoneDetailSheet extends StatelessWidget {
  final PhoneModel phone;

  const PhoneDetailSheet({Key? key, required this.phone}) : super(key: key);

  // Helper function to launch URLs
  Future<void> _launchUrl(BuildContext context, String? urlString, String buttonLabel) async {
    if (urlString == null || urlString.isEmpty) {
      _showSnackBar(context, "No $buttonLabel URL available.");
      return;
    }

    final Uri? url = Uri.tryParse(urlString);
    if (url == null) {
      _showSnackBar(context, "Invalid $buttonLabel URL.");
      return;
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar(context, "Failed to launch $buttonLabel URL.");
      }
    } catch (e) {
      _showSnackBar(context, "An error occurred: $e"); //Catch errors.
    }
  }

  // Helper function to show snack bars
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: _sheetDecoration(),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),
              _buildPhoneImage(),
              const SizedBox(height: 24),
              _buildPhoneName(),
              const SizedBox(height: 12),
              _buildPhonePrice(context),
              const SizedBox(height: 24),
              if (phone.specifications.isNotEmpty) _buildSpecifications(context),
              const SizedBox(height: 32),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _sheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 5,
          offset: const Offset(0, -5),
        ),
      ],
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2.5),
        ),
      ),
    );
  }

  Widget _buildPhoneImage() {
    return Hero(
      tag: 'phone_image_${phone.name}',
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(phone.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildPhoneName() {
    return Text(
      phone.name,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildPhonePrice(BuildContext context) {
    return Text(
      "₹${phone.price}",
      style: TextStyle(
        fontSize: 24,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildSpecifications(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Specifications",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: phone.specifications.entries.map((entry) {
          return _buildSpecCard(context, entry.key, entry.value);
        }).toList(),
      ),
    ],
  );
}

  Widget _buildSpecCard(BuildContext context, String key, String value) {
    return Container(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getIconForSpec(key),
              size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            key,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: -0.3,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700], letterSpacing: -0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            Icons.play_circle_outline,
            "Watch Review",
            () => _launchUrl(context, phone.youtube_link, "Review"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            Icons.shopping_cart,
            "Buy Now",
            () => _launchUrl(context, phone.product_url, "Buy Now"),
          ),
        ),
      ],
    );
  }

  IconData _getIconForSpec(String specName) {
    const Map<String, IconData> specIcons = {
      'processor': Icons.memory,
      'cpu': Icons.memory,
      'ram': Icons.storage,
      'storage': Icons.sd_storage,
      'camera': Icons.camera_alt,
      'display': Icons.phonelink,
      'screen': Icons.phonelink,
      'battery': Icons.battery_full,
      'os': Icons.android,
      'operating system': Icons.android,
    };
    return specIcons[specName.toLowerCase()] ?? Icons.smartphone;
  }
}


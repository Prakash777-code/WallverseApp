import 'package:flutter/material.dart';

class SubscriptionPopup extends StatelessWidget {
  const SubscriptionPopup({super.key});

  static const Color background = Color(0xFF080808);
  static const Color purple = Color(0xFFA855F7);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF292929)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: muted),
                ),
              ),

              const Center(
                child: Icon(Icons.auto_awesome, size: 42, color: purple),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Unlock your creativity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "You've reached your free AI generation limit. "
                "Choose a plan to keep creating amazing wallpapers.",
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 13, height: 1.5),
              ),

              const SizedBox(height: 24),

              _planCard(
                title: 'Free',
                subtitle: 'Perfect for getting started',
                limit: '5 generations / 24 hours',
                icon: Icons.eco_outlined,
                color: muted,
                features: const [
                  'Basic AI wallpaper generation',
                  'Daily generation limit',
                ],
                buttonText: 'Current plan',
                onTap: null,
              ),

              const SizedBox(height: 14),

              _planCard(
                title: 'Premium',
                subtitle: 'For creative enthusiasts',
                limit: '50 generations / 24 hours',
                icon: Icons.workspace_premium_outlined,
                color: purple,
                features: const [
                  'More creative freedom',
                  'Generate more wallpapers',
                  'High-quality wallpaper creation',
                ],
                buttonText: 'Choose Premium',
                onTap: () {
                  // Add your Premium subscription flow here.
                },
                popular: true,
              ),

              const SizedBox(height: 14),

              _planCard(
                title: 'Unlimited',
                subtitle: 'Create without limits',
                limit: 'Unlimited generations',
                icon: Icons.all_inclusive,
                color: cyan,
                features: const [
                  'No daily generation limit',
                  'Create whenever inspiration strikes',
                  'For endless creativity',
                ],
                buttonText: 'Explore Unlimited',
                onTap: () {
                  // Add your Unlimited subscription flow here.
                },
              ),

              const SizedBox(height: 18),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Maybe later',
                    style: TextStyle(color: muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String subtitle,
    required String limit,
    required IconData icon,
    required Color color,
    required List<String> features,
    required String buttonText,
    required VoidCallback? onTap,
    bool popular = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: popular ? purple : const Color(0xFF303030),
          width: popular ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (popular)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          Row(
            children: [
              Icon(icon, color: color, size: 27),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)),

          const SizedBox(height: 12),

          Text(
            limit,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, size: 17, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        color: Color(0xFFD4D4D8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: popular ? purple : const Color(0xFF202020),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF202020),
                disabledForegroundColor: muted,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

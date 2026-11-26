import 'package:flutter/material.dart';
import '../app/app.dart';
import '../model/app.dart';
import 'butia_header.dart';

class CardApp extends StatelessWidget {
  final AppModel app;

  const CardApp({super.key, required this.app});

  Color _corBadge(String pricing) {
    switch (pricing.toLowerCase()) {
      case 'paid':
        return Colors.red.shade600;
      case 'freemium':
        return const Color(0xFFF28C28);
      case 'foss':
        return Colors.teal.shade700;
      default:
        return const Color(0xFF1B8A3D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetalheAppPage(appId: app.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RemoteIconAvatar(
                imageUrl: app.icon,
                size: 72,
                borderRadius: 22,
                fallbackIcon: Icons.widgets_rounded,
                fallbackIconColor: const Color(0xFF1B8A3D),
                fallbackGradient: LinearGradient(
                  colors: [
                    const Color(0xFF3CE86B).withValues(alpha: 0.25),
                    const Color(0xFFDCE043).withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                app.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2,
                  color: Color(0xFF1A1C19),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                app.developerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  app.smallDescription,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          app.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _corBadge(app.pricing),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      app.pricing.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
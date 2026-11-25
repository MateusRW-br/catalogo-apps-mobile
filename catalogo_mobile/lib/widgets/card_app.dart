import 'package:flutter/material.dart';
import '../app/app.dart';
import '../model/app.dart';

class CardApp extends StatelessWidget {
  final AppModel app;

  const CardApp({super.key, required this.app});

  Color _corBadge(String pricing) {
    switch (pricing.toLowerCase()) {
      case 'paid':
        return Colors.red.shade700;
      case 'freemium':
        return Colors.amber.shade700;
      default:
        return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetalheAppPage(appId: app.id)),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                app.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                app.developerName,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                app.smallDescription,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(app.rating.toStringAsFixed(1)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _corBadge(app.pricing),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      app.pricing.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
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
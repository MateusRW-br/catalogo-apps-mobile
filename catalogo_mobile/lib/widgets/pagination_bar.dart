import 'package:flutter/material.dart';

/// Barra tradicional de paginação horizontal em estilo Material Expressive.
class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
                color: const Color(0xFF1B8A3D),
                disabledColor: Colors.grey.shade300,
                visualDensity: VisualDensity.compact,
                tooltip: 'Página anterior',
              ),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(totalPages, (index) {
                      final pageNumber = index + 1;
                      final isSelected = pageNumber == currentPage;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Material(
                          color: isSelected
                              ? const Color(0xFF3CE86B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: isSelected
                                ? null
                                : () => onPageChanged(pageNumber),
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 38,
                                minHeight: 38,
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: isSelected
                                    ? null
                                    : Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                '$pageNumber',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF0A2E14)
                                      : const Color(0xFF1A1C19),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
                color: const Color(0xFF1B8A3D),
                disabledColor: Colors.grey.shade300,
                visualDensity: VisualDensity.compact,
                tooltip: 'Próxima página',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

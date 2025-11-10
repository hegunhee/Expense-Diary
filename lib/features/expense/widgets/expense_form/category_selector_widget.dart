import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter/material.dart';

/// 카테고리 선택 위젯
class CategorySelectorWidget extends StatelessWidget {
  /// 카테고리 선택 위젯 생성자
  const CategorySelectorWidget({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });
  
  /// 선택된 카테고리
  final ExpenseCategory? selectedCategory;
  
  /// 카테고리 변경 콜백
  final ValueChanged<ExpenseCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카테고리',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ExpenseCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            return GestureDetector(
              onTap: () => onChanged(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      color: isSelected ? Colors.white : Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
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
}

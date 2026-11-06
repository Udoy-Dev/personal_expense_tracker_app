import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionItem extends StatefulWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final int index;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
    this.index = 0,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool _isPressed = false;

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'salary':
      case 'business':
      case 'investment':
      case 'freelance':
        return Icons.work_outline;
      case 'food':
      case 'food & dining':
        return Icons.restaurant;
      case 'transport':
      case 'transportation':
        return Icons.directions_bus;
      case 'utilities':
      case 'utilities & bills':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
      case 'health & fitness':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.transaction.type.toLowerCase() == 'income';
    final amountColor = isIncome ? Colors.green.shade700 : Colors.red.shade700;
    final amountSign = isIncome ? '+' : '-';

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(widget.transaction.date);
    } catch (_) {
      parsedDate = DateTime.now();
    }
    final formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

    // Calculate staggered delay for item entrance
    final delayMillis = (widget.index * 60).clamp(0, 500);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delayMillis),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 30),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 2,
            shadowColor: Colors.black.withAlpha(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                leading: Hero(
                  tag: 'avatar_${widget.transaction.id}',
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        isIncome ? Colors.green.shade50 : Colors.red.shade50,
                    child: Icon(
                      _getCategoryIcon(widget.transaction.category),
                      color: amountColor,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  widget.transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          widget.transaction.category,
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade800),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isIncome
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.transaction.type,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: amountColor,
                          ),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                trailing: Hero(
                  tag: 'amount_${widget.transaction.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$amountSign\$${widget.transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

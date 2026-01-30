import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final String name;
  final String price;
  final String sold;

  const ProductListItem({super.key, required this.name, required this.price, required this.sold});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF800000).withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
  ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text('Terjual: $sold', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
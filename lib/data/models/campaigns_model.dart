class DiscountCampaignModel {
  final String? id;
  final String? name;
  final String? category;
  final double? discount;
  final double? threshold;
  final String? discountType;
  final List<DiscountCategory>? discountCategory;
  final double? maxDiscount;
  final bool? isSelected;

  DiscountCampaignModel({
    this.id,
    this.name,
    this.category,
    this.discount,
    this.threshold,
    this.discountType,
    this.discountCategory,
    this.maxDiscount,
    this.isSelected,
  });

  factory DiscountCampaignModel.fromJson(Map<String, dynamic> json) {
    return DiscountCampaignModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      discount: (json['discount'] as num).toDouble(),
      threshold:
          json['threshold'] != null
              ? (json['threshold'] as num).toDouble()
              : null,
      discountType: json['discount_type'] as String,
      discountCategory:
          (json['discount_category'] as List<dynamic>)
              .map((e) => DiscountCategory.fromJson(e))
              .toList(),
      maxDiscount:
          json['max_discount'] != null
              ? (json['max_discount'] as num).toDouble()
              : null,
      isSelected: json['isSelected'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'discount': discount,
      'threshold': threshold,
      'discount_type': discountType,
      'discount_category':
          discountCategory != null
              ? discountCategory!.map((e) => e.toJson()).toList()
              : [],
      'max_discount': maxDiscount,
      'isSelected': isSelected,
    };
  }
}

class DiscountCategory {
  final String category;

  DiscountCategory({required this.category});

  factory DiscountCategory.fromJson(Map<String, dynamic> json) {
    return DiscountCategory(category: json['category'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'category': category};
  }
}

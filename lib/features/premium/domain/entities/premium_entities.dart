enum PremiumPlan { monthly, yearly }

class PremiumOffering {
  const PremiumOffering({
    required this.monthly,
    required this.yearly,
  });

  final PremiumPackage monthly;
  final PremiumPackage yearly;
}

class PremiumPackage {
  const PremiumPackage({
    required this.plan,
    required this.identifier,
    required this.priceString,
    required this.priceAmountMicros,
  });

  final PremiumPlan plan;
  final String identifier;
  final String priceString;
  final int priceAmountMicros;
}

class PremiumStatus {
  const PremiumStatus({
    required this.isActive,
    this.activeUntil,
    this.plan,
  });

  const PremiumStatus.free()
      : isActive = false,
        activeUntil = null,
        plan = null;

  final bool isActive;
  final DateTime? activeUntil;
  final PremiumPlan? plan;
}

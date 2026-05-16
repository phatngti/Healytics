class ProfileSummaryEntity {
  const ProfileSummaryEntity({
    required this.ordersCount,
    required this.wishlistCount,
    required this.points,
    required this.pointsLabel,
  });

  final int ordersCount;
  final int wishlistCount;
  final int points;
  final String pointsLabel;
}

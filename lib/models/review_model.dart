class ReviewModel {
  final String userId;
  final String serviceId;
  final String comment;
  final int rating; // Nombre d'étoiles (1 à 5)

  ReviewModel({
    required this.userId,
    required this.serviceId,
    required this.comment,
    required this.rating,
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/domain/service_model.dart';
import '../../delivery/domain/delivery_model.dart';

class TrackedItems {
  final List<ServiceModel> services;
  final List<DeliveryModel> deliveries;

  TrackedItems({
    this.services = const [],
    this.deliveries = const [],
  });

  TrackedItems copyWith({
    List<ServiceModel>? services,
    List<DeliveryModel>? deliveries,
  }) {
    return TrackedItems(
      services: services ?? this.services,
      deliveries: deliveries ?? this.deliveries,
    );
  }
}

class TrackingNotifier extends StateNotifier<TrackedItems> {
  TrackingNotifier() : super(TrackedItems());

  void addServiceBooking(ServiceModel service) {
    state = state.copyWith(
      services: [...state.services, service],
    );
  }

  void addDeliveryRequest(DeliveryModel delivery) {
    state = state.copyWith(
      deliveries: [...state.deliveries, delivery],
    );
  }
}

final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackedItems>((ref) {
  return TrackingNotifier();
});

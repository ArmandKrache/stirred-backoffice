import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

/// A generic state class for paginated lists
@freezed
class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    /// The list of items
    @Default([]) List<T> items,
    
    /// Whether more items are being loaded
    @Default(false) bool isLoadingMore,
    
    /// Whether the list is being reloaded
    @Default(false) bool isReloading,
    
    /// Whether we've reached the end of the list
    @Default(false) bool isUpToDate,
    
    /// The current search query
    @Default('') String searchQuery,
    
    /// The active filters
    @Default({}) Map<String, dynamic> activeFilters,
  }) = _PaginationState<T>;
} 
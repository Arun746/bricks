class PaginatedData<T, U> {
  final int page, nextPage, perPage;
  final int? totalPages, totalItems;
  final List<T> results;
  final U? extra;
  final bool hasNextPage;
  final bool? hasPrevPage;
  final String? message;
  final String? nextPageState;
  final int? size;
  PaginatedData(
      {this.page = 1,
      this.results = const [],
      this.nextPage = 2,
      this.perPage = 10,
      this.hasNextPage = true,
      this.totalItems,
      this.message,
      this.extra,
      this.totalPages,
      this.hasPrevPage,
      this.nextPageState,
      this.size});

  PaginatedData<T, U?> copyWith({
    List<T>? results,
    int? page,
    int? nextPage,
    bool? hasNextPage,
    int? totalPages,
    int? totalItems,
    String? message,
    String? nextPageState,
    int? size,
    U? extra,
    int? perPage,
    bool? hasPrevPage,
  }) {
    return PaginatedData(
        size: size ?? this.size,
        nextPageState: nextPageState ?? this.nextPageState,
        extra: extra ?? this.extra,
        nextPage: nextPage ?? this.nextPage,
        totalPages: totalPages ?? this.totalPages,
        results: results ?? this.results,
        perPage: perPage ?? this.perPage,
        totalItems: totalItems ?? this.totalItems,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        hasPrevPage: hasPrevPage ?? this.hasPrevPage,
        message: message ?? this.message,
        page: page ?? this.page);
  }
}

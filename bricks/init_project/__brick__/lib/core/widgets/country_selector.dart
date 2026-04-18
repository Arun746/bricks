import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';
import 'package:wrench_and_bolts/features/profile/models/country_response.dart';
import 'package:wrench_and_bolts/features/profile/providers/countries_provider.dart';

class CountrySelectorBottomSheet extends ConsumerStatefulWidget {
  final CountryResponseDatum selectedCountry;
  final ValueChanged<CountryResponseDatum> onCountryChanged;
  final bool showSearch;
  final String? searchHint;

  const CountrySelectorBottomSheet({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.showSearch = false,
    this.searchHint = 'Search countries...',
  });

  @override
  ConsumerState<CountrySelectorBottomSheet> createState() =>
      _CountrySelectorBottomSheetState();
}

class _CountrySelectorBottomSheetState
    extends ConsumerState<CountrySelectorBottomSheet> {
  late List<CountryResponseDatum> filteredCountries;
  late List<CountryResponseDatum> allCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCountries = allCountries
          .where((country) =>
              country.name!.contains(query) || country.code!.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesProvider);

    return countriesAsync.when(
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('Error loading countries: $error'),
        ),
      ),
      data: (countries) {
        allCountries = countries;
        filteredCountries = countries;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 22,
              ),
              // Header
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  'Select Your Country',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),

              // Search field
              if (widget.showSearch)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 2),

              // Countries list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredCountries.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (context, index) {
                    return SizedBox.shrink();
                  },
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final isSelected = country == widget.selectedCountry;

                    return ListTile(
                      onTap: () {
                        widget.onCountryChanged(country);
                        Navigator.pop(context);
                      },
                      leading: Text(
                        (country.flag ?? '').unicodeToEmoji,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      title: Text(
                        '${country.name} ${country.code}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

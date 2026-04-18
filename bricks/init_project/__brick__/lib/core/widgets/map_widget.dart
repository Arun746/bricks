import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wrench_and_bolts/core/styles/assets.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';
import 'package:wrench_and_bolts/features/user_info_form/models/place_autocomplete_response.dart';
import 'package:wrench_and_bolts/features/user_info_form/providers/user_info_form_repository_provider.dart';
import 'dart:async';

class MapWidget extends ConsumerStatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;
  final Function(LatLng, String)? onLocationChanged;
  final VoidCallback? onConfirmButtonPressed;
  final bool showConfirmButton;
  final String confirmButtonText;
  final bool showCenterMarker;

  const MapWidget({
    super.key,
    this.initialLocation,
    this.onLocationSelected,
    this.onLocationChanged,
    this.onConfirmButtonPressed,
    this.showConfirmButton = true,
    this.confirmButtonText = 'Confirm Location',
    this.showCenterMarker = true,
  });

  @override
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Prediction> _searchSuggestions = [];
  bool _showSuggestions = false;
  Timer? _debounceTimer;
  bool _isUpdatingText = false;
  Timer? _hideSuggestionsTimer;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _getAddressFromCoordinates(_selectedLocation!);
    } else {
      _getCurrentLocation();
    }
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    _hideSuggestionsTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (_isUpdatingText) {
      return;
    }

    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  void _onSearchFocusChanged() {
    _hideSuggestionsTimer?.cancel(); 
    if (!_searchFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _showSuggestions = false;
        });
      });
    }
  }

  Future<void> _searchPlaces(String query) async {
    try {
      final repository = ref.read(userInfoFormRepositoryProvider);
      final response = await repository.getPlaceAutoComplete(query);

      if (response.predictions != null) {
        setState(() {
          _searchSuggestions = response.predictions!;
          _showSuggestions = true;
        });
      }
    } catch (e) {
      showErrorSnackbar(e, context);
    }
  }

  Future<void> _selectSuggestedPlace(Prediction prediction) async {
    if (prediction.placeId == null) {
      return;
    }
    _searchFocusNode.unfocus();
    try {
      setState(() => _isLoading = true);

      final repository = ref.read(userInfoFormRepositoryProvider);
      final geocodeResponse = await repository.getGeocode(prediction.placeId!);

      if (geocodeResponse.results != null &&
          geocodeResponse.results!.isNotEmpty) {
        final result = geocodeResponse.results!.first;
        final location = result.geometry?.location;

        if (location?.lat != null && location?.lng != null) {
          final latLng = LatLng(location!.lat!, location.lng!);

          setState(() {
            _selectedLocation = latLng;
            _selectedAddress =
                result.formattedAddress ?? prediction.description ?? '';
            _showSuggestions = false;
            _isLoading = false;
          });

          _isUpdatingText = true;
          _searchController.text = prediction.description ?? '';
          _isUpdatingText = false;

          _controller?.animateCamera(
            CameraUpdate.newLatLngZoom(latLng, 15.0),
          );

          if (widget.onLocationChanged != null) {
            widget.onLocationChanged!(latLng, _selectedAddress);
          }
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorSnackbar(e, context);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = location;
        _isLoading = false;
      });

      _getAddressFromCoordinates(location);

      _controller?.animateCamera(
        CameraUpdate.newLatLng(location),
      );
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final formattedAddress = getFormattedAddress(placemark);

        setState(() {
          _selectedAddress = formattedAddress;
        });

        if (widget.onLocationChanged != null) {
          widget.onLocationChanged!(location, formattedAddress);
        }
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Address not found';
      });

      if (widget.onLocationChanged != null) {
        widget.onLocationChanged!(location, 'Address not found');
      }
    }
  }

  void _onLocationChanged(LatLng location) {
    if (!mounted) return;

    setState(() {
      _selectedLocation = location;
      _selectedAddress = 'Loading address...';
    });
    _getAddressFromCoordinates(location);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _selectedLocation ?? const LatLng(37.4219983, -122.084),
            zoom: 15.0,
          ),
          onCameraIdle: () {
            if (_controller != null) {
              _controller!.getVisibleRegion().then((visibleRegion) {
                final center = LatLng(
                  (visibleRegion.northeast.latitude +
                          visibleRegion.southwest.latitude) /
                      2,
                  (visibleRegion.northeast.longitude +
                          visibleRegion.southwest.longitude) /
                      2,
                );
                _onLocationChanged(center);
              });
            }
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
        ),
        if (widget.showCenterMarker)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AssetsPath.mapCenterMarkerIcon,
                  height: 40,
                ),
                SizedBox(height: 30)
              ],
            ),
          ),
        Positioned(
          top: 42,
          left: 2,
          right: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter your address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _showSuggestions = false;
                              });
                            },
                            child: Icon(Icons.clear),
                          )
                        : null,
                  ),
                  onSubmitted: (value) {
                    if (_searchSuggestions.isNotEmpty) {
                      _selectSuggestedPlace(_searchSuggestions.first);
                    }
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              // Search suggestions
              if (_showSuggestions && _searchSuggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchSuggestions.length > 5
                        ? 5
                        : _searchSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _searchSuggestions[index];
                      return ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(
                          suggestion.structuredFormatting?.mainText ??
                              suggestion.description ??
                              '',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: suggestion
                                    .structuredFormatting?.secondaryText !=
                                null
                            ? Text(
                                suggestion.structuredFormatting!.secondaryText!)
                            : null,
                        onTap: () => _selectSuggestedPlace(suggestion),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        // Loading indicator
        if (_isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),

        // Address display && confirm button
        Positioned(
          bottom: 20,
          left: 2,
          right: 2,
          child: Column(
            children: [
              Container(
                width: 350,
                padding: const EdgeInsets.only(top: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedAddress.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Selected Address',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          bottom: 12,
                          top: 8,
                        ),
                        child: Text(
                          _selectedAddress,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                    if (widget.showConfirmButton && _selectedLocation != null)
                      SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: widget.onConfirmButtonPressed,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(widget.confirmButtonText),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

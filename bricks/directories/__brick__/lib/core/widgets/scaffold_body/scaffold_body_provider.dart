import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scaffold_body_provider.freezed.dart';
part 'scaffold_body_provider.g.dart';

@freezed
class ScaffoldBodyState with _$ScaffoldBodyState {
  factory ScaffoldBodyState({
    required Widget loading,
    required bool isLoading,
    required bool disableInteraction,
    required bool shouldShowConnectionLostMessage,
    required bool preventBack,
  }) = _ScaffoldBodyState;
}

@riverpod
class ScaffoldBody extends _$ScaffoldBody {
  StreamSubscription<List<ConnectivityResult>>? _networkListener;
  bool _isConnectedToInternet = true;
  bool _hasInitializedConnectivity = false;

  @override
  ScaffoldBodyState build() {
    return ScaffoldBodyState(
      loading: const SizedBox(),
      disableInteraction: false,
      isLoading: false,
      shouldShowConnectionLostMessage: false,
      preventBack: false,
    );
  }

  void _startNetworkMonitoring() {
    if (_networkListener != null) return;

    _networkListener = Connectivity().onConnectivityChanged.listen((results) {
      _updateConnectivityStatus(results);
    });

    // Initialize connectivity state properly
    Connectivity().checkConnectivity().then((results) {
      _isConnectedToInternet = results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.other);
      _hasInitializedConnectivity = true;
    });
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnectedToInternet;

    final newConnectionStatus = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.other);

    // Only update connection status if it has actually changed
    if (_hasInitializedConnectivity &&
        newConnectionStatus != _isConnectedToInternet) {
      _isConnectedToInternet = newConnectionStatus;

      // Only show connection lost message if:
      // 1. We had a previous connection (wasConnected = true)
      // 2. Connection is now lost (!_isConnectedToInternet)
      // 3. Loading is currently enabled (state.isLoading)
      // 4. We've properly initialized connectivity
      if (wasConnected && !_isConnectedToInternet && state.isLoading) {
        state = state.copyWith(
          loading: const SizedBox(),
          isLoading: false,
          shouldShowConnectionLostMessage: true,
          preventBack: false,
        );
        // _stopNetworkMonitoring();
      }
    } else if (!_hasInitializedConnectivity) {
      // First time initialization - don't trigger any events
      _isConnectedToInternet = newConnectionStatus;
      _hasInitializedConnectivity = true;
    }
  }

  enableLoading({Color? color, String? message, bool preventBack = false}) {
    _startNetworkMonitoring();

    state = state.copyWith(
        loading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator.adaptive(
              valueColor:
                  AlwaysStoppedAnimation<Color>(color ?? Color(0xff4F5583)),
            ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                          )
                        ],
                      )),
                ),
              )
          ],
        ),
        isLoading: true,
        shouldShowConnectionLostMessage: false,
        preventBack: preventBack);
  }

  disableLoading() {
    // _stopNetworkMonitoring();

    state = state.copyWith(
      loading: const SizedBox(),
      isLoading: false,
      shouldShowConnectionLostMessage: false,
      preventBack: false,
    );
  }

  void disableInteraction() {
    state = state.copyWith(disableInteraction: true);
  }

  void enableInteraction() {
    state = state.copyWith(disableInteraction: false);
  }

  void clearConnectionLostMessage() {
    state = state.copyWith(
      shouldShowConnectionLostMessage: false,
      preventBack: false,
    );
  }
}

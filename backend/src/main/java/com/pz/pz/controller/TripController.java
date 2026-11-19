package com.pz.pz.controller;

import com.pz.pz.dto.TripCreateRequestDto;
import com.pz.pz.dto.TripDetailsResponseDto;
import com.pz.pz.dto.TripSummaryResponseDto;
import com.pz.pz.dto.TripUpdateRequestDto;
import com.pz.pz.security.CustomUserDetails;
import com.pz.pz.service.TripService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trips")
@RequiredArgsConstructor
public class TripController {

    private final TripService tripService;

    @GetMapping
    public ResponseEntity<List<TripSummaryResponseDto>> getUserTrips(
            @AuthenticationPrincipal CustomUserDetails currentUser) {
        List<TripSummaryResponseDto> trips = tripService.getUserTrips(currentUser.getId());
        return ResponseEntity.ok(trips);
    }

    @GetMapping("/{id}")
    public ResponseEntity<TripDetailsResponseDto> getTripDetails(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails currentUser) {
        TripDetailsResponseDto trip = tripService.getTripById(id, currentUser.getId());
        return ResponseEntity.ok(trip);
    }

    @PostMapping
    public ResponseEntity<TripDetailsResponseDto> createTrip(
            @Valid @RequestBody TripCreateRequestDto dto,
            @AuthenticationPrincipal CustomUserDetails currentUser) {
        TripDetailsResponseDto createdTrip = tripService.createTrip(dto, currentUser.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(createdTrip);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TripDetailsResponseDto> updateTrip(
            @PathVariable Long id,
            @Valid @RequestBody TripUpdateRequestDto dto,
            @AuthenticationPrincipal CustomUserDetails currentUser) {
        TripDetailsResponseDto updatedTrip = tripService.updateTrip(id, dto, currentUser.getId());
        return ResponseEntity.ok(updatedTrip);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTrip(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails currentUser) {
        tripService.deleteTrip(id, currentUser.getId());
        return ResponseEntity.noContent().build();
    }
}

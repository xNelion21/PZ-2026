package com.pz.pz.controller;

import com.pz.pz.dto.TripSummaryResponseDto;
import com.pz.pz.service.TripService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final TripService tripService;

    @GetMapping("/{userId}/trips")
    public ResponseEntity<List<TripSummaryResponseDto>> getPublicUserTrips(@PathVariable Long userId) {
        List<TripSummaryResponseDto> trips = tripService.getPublicUserTrips(userId);
        return ResponseEntity.ok(trips);
    }
}

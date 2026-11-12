package com.pz.pz.service;

import com.pz.pz.dto.*;
import com.pz.pz.mapper.TripMapper;
import com.pz.pz.model.Trip;
import com.pz.pz.model.TripPoint;
import com.pz.pz.model.TripSegment;
import com.pz.pz.model.User;
import com.pz.pz.repository.TripRepository;
import com.pz.pz.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class TripService {

    private final TripRepository tripRepository;
    private final UserRepository userRepository;
    private final TripMapper tripMapper;

    @Transactional(readOnly = true)
    public List<TripSummaryResponseDto> getUserTrips(Long userId) {
        return tripRepository.findAllByUserId(userId).stream()
                .map(tripMapper::toSummaryDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public TripDetailsResponseDto getTripById(Long tripId, Long userId) {
        Trip trip = getTripIfOwner(tripId, userId);
        return tripMapper.toDetailsDto(trip);
    }

    @Transactional
    public TripDetailsResponseDto createTrip(TripCreateRequestDto dto, Long userId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new EntityNotFoundException("User not found with id: " + userId));

        Trip trip = Trip.builder()
                .title(dto.getTitle())
                .startDate(dto.getStartDate())
                .endDate(dto.getEndDate())
                .description(dto.getDescription())
                .user(user)
                .build();

        applyPointsAndSegments(trip, dto.getPoints(), dto.getSegments());

        Trip tripCreated = tripRepository.save(trip);

        return tripMapper.toDetailsDto(tripCreated);
    }

    @Transactional
    public TripDetailsResponseDto updateTrip(Long tripId, TripUpdateRequestDto dto, Long userId) {
        Trip trip = getTripIfOwner(tripId, userId);

        trip.setTitle(dto.getTitle());
        trip.setStartDate(dto.getStartDate());
        trip.setEndDate(dto.getEndDate());
        trip.setDescription(dto.getDescription());

        trip.getSegments().clear();
        trip.getPoints().clear();
        tripRepository.flush();

        applyPointsAndSegments(trip, dto.getPoints(), dto.getSegments());

        Trip tripUpdated = tripRepository.save(trip);
        return tripMapper.toDetailsDto(tripUpdated);
    }

    @Transactional
    public void deleteTrip(Long tripId, Long userId) {
        Trip trip = getTripIfOwner(tripId, userId);
        tripRepository.delete(trip);
    }

    private Trip getTripIfOwner(Long tripId, Long userId) {
        return tripRepository.findAllByIdAndUserId(tripId, userId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Trip with id " + tripId + " not found for current user"
                ));
    }

    private void applyPointsAndSegments(
            Trip trip,
            List<TripPointRequestDto> pointDtos,
            List<TripSegmentRequestDto> segmentDtos) {

        trip.getPoints().clear();
        trip.getSegments().clear();

        if (pointDtos == null || pointDtos.isEmpty()) {
            if (segmentDtos != null && !segmentDtos.isEmpty()) {
                throw new IllegalArgumentException("Cannot create segments when points list is empty");
            }
            return;
        }

        Map<Integer, TripPoint> pointsByOrderIndex = new HashMap<>();

        for (TripPointRequestDto pointDto : pointDtos) {
            Integer index = pointDto.getOrderIndex();

            if (pointsByOrderIndex.containsKey(index)) {
                throw new IllegalArgumentException("Duplicate orderIndex in points: " + index);
            }

            TripPoint point = TripPoint.builder()
                    .name(pointDto.getName())
                    .latitude(pointDto.getLatitude())
                    .longitude(pointDto.getLongitude())
                    .countryCode(pointDto.getCountryCode())
                    .orderIndex(index)
                    .trip(trip)
                    .build();

            trip.getPoints().add(point);
            pointsByOrderIndex.put(index, point);
        }

        for (int i = 0; i < pointDtos.size(); i++) {
            if (!pointsByOrderIndex.containsKey(i)) {
                throw new IllegalArgumentException(
                        "Invalid point orderIndex sequence. Missing index: " + i
                );
            }
        }

        if (segmentDtos != null) {
            for (TripSegmentRequestDto segmentDto : segmentDtos) {
                TripPoint fromPoint = pointsByOrderIndex.get(segmentDto.getFromPointOrderIndex());
                TripPoint toPoint = pointsByOrderIndex.get(segmentDto.getToPointOrderIndex());

                if (fromPoint == null || toPoint == null) {
                    throw new IllegalArgumentException(
                            "Segment refers to non-existent point orderIndex: "
                                    + segmentDto.getFromPointOrderIndex() + " -> " + segmentDto.getToPointOrderIndex()
                    );
                }

                if (fromPoint.equals(toPoint)) {
                    throw new IllegalArgumentException(
                            "Segment cannot connect a point to itself (orderIndex: "
                                    + segmentDto.getFromPointOrderIndex() + ")"
                    );
                }

                TripSegment segment = TripSegment.builder()
                        .fromPoint(fromPoint)
                        .toPoint(toPoint)
                        .transportType(segmentDto.getTransportType())
                        .trip(trip)
                        .build();

                trip.getSegments().add(segment);
            }
        }
    }
}

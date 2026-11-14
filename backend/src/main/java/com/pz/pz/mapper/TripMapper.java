package com.pz.pz.mapper;

import com.pz.pz.dto.TripDetailsResponseDto;
import com.pz.pz.dto.TripPointResponseDto;
import com.pz.pz.dto.TripSegmentResponseDto;
import com.pz.pz.dto.TripSummaryResponseDto;
import com.pz.pz.model.Trip;
import com.pz.pz.model.TripPoint;
import com.pz.pz.model.TripSegment;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class TripMapper {

    public TripSummaryResponseDto toSummaryDto(Trip trip) {
        return new TripSummaryResponseDto(
                trip.getId(),
                trip.getTitle(),
                trip.getStartDate(),
                trip.getEndDate(),
                trip.getDescription()
        );
    }

    public TripDetailsResponseDto toDetailsDto(Trip trip) {
        List<TripPointResponseDto> pointDtos = trip.getPoints().stream()
                .map(this::toPointDto)
                .toList();

        List<TripSegmentResponseDto> segmentDtos = trip.getSegments().stream()
                .map(this::toSegmentDto)
                .toList();

        return new TripDetailsResponseDto(
                trip.getId(),
                trip.getTitle(),
                trip.getStartDate(),
                trip.getEndDate(),
                trip.getDescription(),
                pointDtos,
                segmentDtos
        );
    }

    public TripPointResponseDto toPointDto(TripPoint point) {
        return new TripPointResponseDto(
                point.getId(),
                point.getName(),
                point.getLatitude(),
                point.getLongitude(),
                point.getCountryCode(),
                point.getOrderIndex()
        );
    }

    public TripSegmentResponseDto toSegmentDto(TripSegment segment) {
        return new TripSegmentResponseDto(
                segment.getId(),
                segment.getFromPoint().getOrderIndex(),
                segment.getToPoint().getOrderIndex(),
                segment.getTransportType()
        );
    }
}

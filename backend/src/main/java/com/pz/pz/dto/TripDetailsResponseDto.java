package com.pz.pz.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripDetailsResponseDto {

    private Long id;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String description;
    private List<TripPointResponseDto> points;
    private List<TripSegmentResponseDto> segments;
}

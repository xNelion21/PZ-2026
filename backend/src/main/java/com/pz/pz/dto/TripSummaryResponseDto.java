package com.pz.pz.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripSummaryResponseDto {

    private Long id;
    private String title;
    private LocalDate startDate;
    private LocalDate endDate;
    private String description;
}

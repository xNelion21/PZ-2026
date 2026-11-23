package com.pz.pz.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TripPointResponseDto {
    private Long id;
    private String name;
    private Double latitude;
    private Double longitude;
    private String countryCode;
    private Integer orderIndex;
}

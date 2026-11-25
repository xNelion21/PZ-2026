package com.pz.pz.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RouteRequestDto {

    @NotNull
    @Size(min = 2, message = "At least 2 points are required to calculate a route")
    private List<@Valid CoordinateDto> points;
}

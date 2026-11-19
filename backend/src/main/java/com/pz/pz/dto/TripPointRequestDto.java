package com.pz.pz.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripPointRequestDto {

    @NotBlank(message = "Name cannot be blank")
    private String name;

    @NotNull
    @DecimalMin(value = "-90.0")
    @DecimalMax(value = "90.0")
    private Double latitude;

    @NotNull
    @DecimalMin(value = "-180.0")
    @DecimalMax(value = "180.0")
    private Double longitude;

    @NotNull
    @Size(min = 2, max = 2, message = "Country Code has length of 2 characters")
    @Pattern(regexp = "^[A-Z]{2}$", message = "Country Code must be 2 capital letters")
    private String countryCode;

    @NotNull
    @Min(0)
    private Integer orderIndex;
}

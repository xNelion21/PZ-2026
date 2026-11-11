package com.pz.pz.dto;

import com.pz.pz.model.TransportType;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripSegmentRequestDto {

    @NotNull
    private Integer fromPointOrderIndex;

    @NotNull
    private Integer toPointOrderIndex;

    @NotNull
    private TransportType transportType;

}

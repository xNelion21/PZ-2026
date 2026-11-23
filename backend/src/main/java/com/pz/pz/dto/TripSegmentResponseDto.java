package com.pz.pz.dto;

import com.pz.pz.model.TransportType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripSegmentResponseDto {

    private Long id;
    private Integer fromPointOrderIndex;
    private Integer toPointOrderIndex;
    private TransportType transportType;
}

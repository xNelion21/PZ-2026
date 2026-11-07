package com.pz.pz.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "trip_segments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripSegment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_point_id", nullable = false)
    private TripPoint fromPoint;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_point_id", nullable = false)
    private TripPoint toPoint;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TransportType transportType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;
}
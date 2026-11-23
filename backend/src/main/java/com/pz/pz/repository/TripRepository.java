package com.pz.pz.repository;

import com.pz.pz.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TripRepository extends JpaRepository<Trip, Long> {

    Optional<Trip> findAllByUserId(Long userId);

    Optional<Trip> findAllByIdAndUserId(Long id, Long userId);
}

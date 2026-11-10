package com.pz.pz.repository;

import com.pz.pz.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TripRepository extends JpaRepository<Trip, Long> {

    List<Trip> findAllByUserId(Long userId);

    List<Trip> findAllByIdAndUserId(Long id, Long userId);
}

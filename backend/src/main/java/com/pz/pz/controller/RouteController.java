package com.pz.pz.controller;

import com.pz.pz.dto.RouteRequestDto;
import com.pz.pz.dto.RouteResponseDto;
import com.pz.pz.service.RoutingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/routes")
@RequiredArgsConstructor
public class RouteController {

    private final RoutingService routingService;

    @PostMapping("/calculate")
    public ResponseEntity<RouteResponseDto> calculateRoute(@Valid @RequestBody RouteRequestDto dto) {
        RouteResponseDto route = routingService.calculateCarRoute(dto);
        return ResponseEntity.ok(route);
    }
}

package com.pz.pz.service;

import com.pz.pz.dto.CoordinateDto;
import com.pz.pz.dto.RouteRequestDto;
import com.pz.pz.dto.RouteResponseDto;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class RoutingService {

    private final RestClient restClient = RestClient.builder()
            .baseUrl("https://router.project-osrm.org")
            .defaultHeader(HttpHeaders.ACCEPT_ENCODING, "identity")
            .build();

    public RouteResponseDto calculateCarRoute(RouteRequestDto request) {
        String coordinatesParam = request.getPoints().stream()
                .map(p -> p.getLongitude() + "," + p.getLatitude())
                .collect(Collectors.joining(";"));

        OsrmResponse response = restClient.get()
                .uri("/route/v1/driving/{coords}?overview=full&geometries=geojson", coordinatesParam)
                .accept(MediaType.APPLICATION_JSON)
                .retrieve()
                .body(OsrmResponse.class);

        if (response == null || !"Ok".equals(response.code()) || response.routes().isEmpty()) {
            throw new IllegalArgumentException("Could not calculate route for given coordinates");
        }

        OsrmRoute mainRoute = response.routes().getFirst();

        double distanceKm = Math.round((mainRoute.distance() / 1000.0) * 100.0) / 100.0;

        List<CoordinateDto> geometry = mainRoute.geometry().coordinates().stream()
                .map(pair -> new CoordinateDto(pair.getLast(), pair.getFirst()))
                .toList();

        return new RouteResponseDto(distanceKm, geometry);
    }

    private record OsrmResponse(String code, List<OsrmRoute> routes) {}
    private record OsrmRoute(double distance, OsrmGeometry geometry) {}
    private record OsrmGeometry(List<List<Double>> coordinates) {}
}

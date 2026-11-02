package com.pz.pz.service;

import com.pz.pz.dto.AuthResponseDto;
import com.pz.pz.dto.LoginRequestDto;
import com.pz.pz.dto.RegisterRequestDto;
import com.pz.pz.model.User;
import com.pz.pz.repository.UserRepository;
import com.pz.pz.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    public String register(RegisterRequestDto dto) {
        if (userRepository.existsByUsername(dto.getUsername())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nazwa użytkownika jest już zajęta");
        }

        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Adres e-mail jest już zarejestrowany");
        }

        User user = new User();
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPasswordHash(passwordEncoder.encode(dto.getPassword()));
        user.setPublic(true);

        userRepository.save(user);

        return "Rejestracja przebiegła pomyślnie";
    }

    public AuthResponseDto login(LoginRequestDto dto) {
        User user = userRepository.findByUsernameOrEmail(dto.getUsernameOrEmail(), dto.getUsernameOrEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Niepoprawna nazwa użytkownika/e-mail lub hasło"));

        if (!passwordEncoder.matches(dto.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Niepoprawna nazwa użytkownika/e-mail lub hasło");
        }

        String token = jwtTokenProvider.generateToken(user.getUsername());

        return AuthResponseDto.builder()
                .token(token)
                .tokenType("Bearer")
                .username(user.getUsername())
                .email(user.getEmail())
                .build();
    }
}
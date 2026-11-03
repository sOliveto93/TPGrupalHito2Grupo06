package com.unla.hito2.service;

import com.unla.hito2.repository.TokenRecuperacionRepository;
import com.unla.hito2.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.unla.hito2.entity.TokenRecuperacion;
import com.unla.hito2.entity.Usuario;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import com.unla.hito2.dto.RestablecerContraseniaDto;

import java.time.LocalDateTime;
import java.util.Optional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;


@Service
public class RecuperacionContraseniaService {

    @Value("${app.url-base}")
    private String urlBase;
    private final TokenRecuperacionRepository tokenRepository;
    private final UserRepository userRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    public RecuperacionContraseniaService(
            TokenRecuperacionRepository tokenRecuperacionRepository,
            UserRepository userRepository,
            EmailService emailService,
            PasswordEncoder passwordEncoder){

        this.tokenRepository = tokenRecuperacionRepository;
        this.userRepository = userRepository;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void solicitarRecuperacion(String email) {

        Optional<Usuario> resultado = userRepository.findByEmail(email.trim());

        if (resultado.isEmpty()) {
            return;
        }

        Usuario usuario = resultado.get();

        if (!usuario.isEnabled()) {
            return;
        }

        String codigo = generarToken();

        TokenRecuperacion token = new TokenRecuperacion();
        token.setHuellaToken(calcularHuella(codigo));
        token.setUsuario(usuario);
        token.setFechaVencimiento(LocalDateTime.now().plusMinutes(15));
        token.setUtilizado(false);

        tokenRepository.save(token);

        String enlace = urlBase
                + "/recuperar-contrasenia/restablecer?token="
                + codigo;

        emailService.enviarEnlaceRecuperacion(usuario.getEmail(), enlace);
    }

    private String generarToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(bytes);
    }

    private String calcularHuella(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            byte[] huella = digest.digest(
                    token.getBytes(StandardCharsets.UTF_8));

            return HexFormat.of().formatHex(huella);

        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(
                    "No se pudo calcular la huella del token.", e);
        }

    }

    private TokenRecuperacion buscarTokenValido(String codigo) {

        if (codigo == null || codigo.isBlank()) {
            throw new IllegalArgumentException(
                    "El enlace de recuperación no es válido.");
        }

        TokenRecuperacion token = tokenRepository
                .findByHuellaToken(calcularHuella(codigo))
                .orElseThrow(() -> new IllegalArgumentException(
                        "El enlace de recuperación no es válido."));

        comprobarToken(token);
        return token;
    }

    private void comprobarToken(TokenRecuperacion token) {

        if (token.isUtilizado()) {
            throw new IllegalArgumentException(
                    "El enlace de recuperación ya fue utilizado.");
        }

        if (!token.getFechaVencimiento().isAfter(LocalDateTime.now())) {
            throw new IllegalArgumentException(
                    "El enlace de recuperación venció. Solicitá uno nuevo.");
        }

        if (!token.getUsuario().isEnabled()) {
            throw new IllegalArgumentException(
                    "La cuenta no está habilitada.");
        }
    }


    @Transactional(readOnly = true)
    public void validarEnlace(String codigo) {
        buscarTokenValido(codigo);
    }

    @Transactional
    public void restablecerContrasenia(RestablecerContraseniaDto dto) {

        if (dto.getToken() == null || dto.getToken().isBlank()) {
            throw new IllegalArgumentException(
                    "El enlace de recuperación no es válido.");
        }

        TokenRecuperacion token = tokenRepository
                .buscarParaRestablecer(calcularHuella(dto.getToken()))
                .orElseThrow(() -> new IllegalArgumentException(
                        "El enlace de recuperación no es válido."));

        comprobarToken(token);

        if (!dto.getNuevaContrasenia().equals(
                dto.getConfirmarContrasenia())) {
            throw new IllegalArgumentException(
                    "La nueva contraseña y su confirmación no coinciden.");
        }

        Usuario usuario = token.getUsuario();

        usuario.setPassword(
                passwordEncoder.encode(dto.getNuevaContrasenia()));

        token.setUtilizado(true);

        userRepository.save(usuario);
        tokenRepository.save(token);
    }



}

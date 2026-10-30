package com.unla.hito2.service;

import com.unla.hito2.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.unla.hito2.dto.CambiarContraseniaDto;
import com.unla.hito2.entity.Usuario;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ContraseniaService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public ContraseniaService(UserRepository userRepository, PasswordEncoder passwordEncoder){

        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;

    }

    @Transactional
    public void cambiarContrasenia(String username,
                                   CambiarContraseniaDto dto) {

        Usuario usuario = userRepository
                .findByUsernameOrEmail(username, username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró el usuario."));

        if ((!passwordEncoder.matches(dto.getContraseniaActual(),usuario.getPassword()))){
            throw new IllegalArgumentException("La contraseña actual es incorrecta");
        }

        if (!dto.getNuevaContrasenia().equals(dto.getConfirmarContrasenia())){
            throw new IllegalArgumentException(
                    "La nueva contraseña y su confirmacion no coinciden");
        }

        usuario.setPassword(passwordEncoder.encode(dto.getNuevaContrasenia()));

        userRepository.save(usuario);


    }

    @Transactional(readOnly = true)
    public Usuario obtenerUsuario(String username) {
        return userRepository.findByUsernameOrEmail(username, username)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró el usuario."));
    }

}

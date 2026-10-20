package com.unla.hito2.service;

import com.unla.hito2.Enum.Rol;
import com.unla.hito2.entity.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.unla.hito2.dto.EmpleadoDto;
import com.unla.hito2.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;

import java.time.LocalDate;
import java.time.Period;

@Service
public class EmpleadoService {

    private final StaffRepository staffRepository;
    private final CajeroRepository cajeroRepository;
    private final CocineroRepository cocineroRepository;
    private final UserRepository userRepository;
    private final UsuarioRolRepository usuarioRolRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    public EmpleadoService(StaffRepository staffRepository, CajeroRepository cajeroRepository, CocineroRepository cocineroRepository, UserRepository userRepository, UsuarioRolRepository usuarioRolRepository, EmailService emailService, PasswordEncoder passwordEncoder) {
        this.staffRepository = staffRepository;
        this.cajeroRepository = cajeroRepository;
        this.cocineroRepository = cocineroRepository;
        this.userRepository = userRepository;
        this.usuarioRolRepository = usuarioRolRepository;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
    }

    private void validarEmpleado(EmpleadoDto dto) throws Exception {

        if (staffRepository.existsByDni(dto.getDni())) {
            throw new Exception("Ya existe un usuario registrado con el mismo DNI");
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new Exception("Ya existe un usuario registrado con el mismo email");
        }
        int edad = Period.between(dto.getFechaNac(), LocalDate.now()).getYears();
        if (edad < 18) {
            throw new Exception("El Usuario debe ser mayor de edad");
        }
        if (dto.getFechaIngreso().isAfter(LocalDate.now())) {
            throw new Exception("La fecha de ingreso no puede ser posterior a la actual");
        }
        if (dto.getFechaNac().isAfter(LocalDate.now())) {
            throw new Exception("La fecha de nacimiento no puede ser posterior a la fecha actual");
        }
        if (dto.getFechaIngreso().isBefore(dto.getFechaNac())) {
            throw new Exception("La fecha de ingreso no puede ser anterior a la de nacimiento.");
        }
    }

    private String generarContraseña() {
        SecureRandom random = new SecureRandom();
        String rango = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        int longitud = random.nextInt(6, 12);
        StringBuilder sb = new StringBuilder(longitud);

        for (int i = 0; i < longitud; i++) {
            int j = random.nextInt(rango.length());
            sb.append(rango.charAt(j));
        }
        return sb.toString();
    }

    public void registrarEmpleado(EmpleadoDto dto, UnidadDeVenta unidadDeVenta) throws Exception {
        validarEmpleado(dto);

        String passwordPlana = generarContraseña();

        Usuario usuario = new Usuario();
        usuario.setUsername(dto.getEmail());
        usuario.setEmail(dto.getEmail());
        usuario.setPassword(passwordEncoder.encode(passwordPlana));
        usuario.setEnabled(true);
        usuario = userRepository.save(usuario);

        UsuarioRol usuarioRol = new UsuarioRol();
        usuarioRol.setUsuario(usuario);
        usuarioRol.setRol(Rol.ROLE_EMPLEADO);

        if ("COCINERO".equalsIgnoreCase(dto.getTipoEmpleado())) {
            Cocinero cocinero = new Cocinero();
            cocinero.setName(dto.getName());
            cocinero.setApellido(dto.getApellido());
            cocinero.setDni(dto.getDni());
            cocinero.setFechaNac(dto.getFechaNac());
            cocinero.setFechaIngreso(dto.getFechaIngreso());
            cocinero.setActivo(true);
            cocinero.setUnidadDeVenta(unidadDeVenta);
            cocinero.setUsuario(usuario);
            cocinero.setCategoria(dto.getCategoria());

            cocineroRepository.save(cocinero);
        } else if ("CAJERO".equalsIgnoreCase(dto.getTipoEmpleado())) {
            Cajero cajero = new Cajero();
            cajero.setName(dto.getName());
            cajero.setApellido(dto.getApellido());
            cajero.setDni(dto.getDni());
            cajero.setFechaNac(dto.getFechaNac());
            cajero.setFechaIngreso(dto.getFechaIngreso());
            cajero.setActivo(true);
            cajero.setUnidadDeVenta(unidadDeVenta);
            cajero.setUsuario(usuario);
            cajero.setTurno(dto.getTurno());

            cajeroRepository.save(cajero);

        } else {
            throw new Exception("El tipo de empleado especificado no es válido.");
        }

        emailService.enviarCredenciales(dto.getEmail(), passwordPlana);
    }
}

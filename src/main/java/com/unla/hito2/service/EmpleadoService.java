package com.unla.hito2.service;

import com.unla.hito2.Enum.Rol;
import com.unla.hito2.entity.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.unla.hito2.dto.EmpleadoDto;
import com.unla.hito2.dto.HistorialEmpleadoDto;
import com.unla.hito2.dto.UnidadHistorialDto;
import com.unla.hito2.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;

import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

@Service
public class EmpleadoService {

    private final StaffRepository staffRepository;
    private final CajeroRepository cajeroRepository;
    private final CocineroRepository cocineroRepository;
    private final UserRepository userRepository;
    private final UsuarioRolRepository usuarioRolRepository;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private final HistorialUnidadVentaService historialUnidadVentaService;

    public EmpleadoService(StaffRepository staffRepository, CajeroRepository cajeroRepository,
            CocineroRepository cocineroRepository, UserRepository userRepository,
            UsuarioRolRepository usuarioRolRepository, EmailService emailService, PasswordEncoder passwordEncoder,
            HistorialUnidadVentaService historialUnidadVentaService) {
        this.staffRepository = staffRepository;
        this.cajeroRepository = cajeroRepository;
        this.cocineroRepository = cocineroRepository;
        this.userRepository = userRepository;
        this.usuarioRolRepository = usuarioRolRepository;
        this.emailService = emailService;
        this.passwordEncoder = passwordEncoder;
        this.historialUnidadVentaService = historialUnidadVentaService;
    }

    public EmpleadoDto buscarStaffPorId(Long id) {

        Staff staff = staffRepository.findById(id)
                .orElseThrow(() -> new RuntimeException(
                        "No se encontró el empleado."));
        return empleadoToDto(staff);
    }

    private void validarEmpleado(EmpleadoDto dto) throws Exception {

        if (dto.getDni() == null || !dto.getDni().matches("^[0-9]{7,8}$")) {
            throw new Exception("El DNI debe contener solo números y tener 7 u 8 dígitos");
        }
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

    @Transactional
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

        usuarioRolRepository.save(usuarioRol);

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
            historialUnidadVentaService.registrarAsignacion(cocinero, unidadDeVenta);

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
            historialUnidadVentaService.registrarAsignacion(cajero, unidadDeVenta);

        } else {
            throw new Exception("El tipo de empleado especificado no es válido.");
        }

        emailService.enviarCredenciales(dto.getEmail(), passwordPlana);
    }

    public List<EmpleadoDto> buscarEmpleadosPorUnidad(Long idUnidad) {
        List<Staff> empleados = staffRepository.findByUnidadDeVenta_Id(idUnidad);

        List<EmpleadoDto> dtos = new ArrayList<>();

        for (Staff staff : empleados) {
            dtos.add(empleadoToDto(staff));
        }

        return dtos;
    }

    private EmpleadoDto empleadoToDto(Staff staff) {
        EmpleadoDto dto = new EmpleadoDto();

        dto.setName(staff.getName());
        dto.setApellido(staff.getApellido());
        dto.setDni(staff.getDni());
        dto.setFechaNac(staff.getFechaNac());
        dto.setFechaIngreso(staff.getFechaIngreso());
        dto.setEmail(staff.getUsuario().getEmail());
        dto.setId(staff.getId());
        dto.setActivo(staff.isActivo());

        if (staff instanceof Cajero cajero) {
            dto.setTipoEmpleado("CAJERO");
            dto.setTurno(cajero.getTurno());
        } else if (staff instanceof Cocinero cocinero) {
            dto.setTipoEmpleado("COCINERO");
            dto.setCategoria(cocinero.getCategoria());
        }

        return dto;
    }

    @Transactional
    public HistorialEmpleadoDto buscarHistorialEmpleado(Long idStaff) {

        Staff staff = staffRepository.findById(idStaff)
                .orElseThrow(() -> new RuntimeException(
                        "No se encontró el empleado."));

        List<HistorialUnidadVenta> asignaciones = historialUnidadVentaService.buscarPorStaff(idStaff);

        HistorialEmpleadoDto dto = new HistorialEmpleadoDto();
        dto.setEmpleado(empleadoToDto(staff));

        List<UnidadHistorialDto> historial = new ArrayList<>();

        for (HistorialUnidadVenta asignacion : asignaciones) {
            UnidadHistorialDto unidadDto = new UnidadHistorialDto();

            unidadDto.setNombreUnidad(
                    asignacion.getUnidadDeVenta().getNombreComercial());

            unidadDto.setActual(
                    staff.getUnidadDeVenta() != null
                            && staff.getUnidadDeVenta().getId()
                                    .equals(asignacion.getUnidadDeVenta().getId()));
            Festival festival = asignacion.getUnidadDeVenta().getFestival();

            unidadDto.setNombreFestival(festival.getNombre());
            unidadDto.setFechaInicioFestival(festival.getFechaInicio());
            unidadDto.setFechaFinFestival(festival.getFechaFin());

            historial.add(unidadDto);
        }

        dto.setHistorial(historial);

        return dto;
    }

    @Transactional
    public Long verificarEmpleadoHistorial(String username) {
        Staff staff = staffRepository.findByUsuario_Username(username)
                .orElseThrow(() -> new RuntimeException(
                        "No se encontró el empleado autenticado."));

        return staff.getId();
    }

    @Transactional
    public void desactivarEmpleado(Long idEmpleado, Long idUnidad) {
        cambiarEstadoEmpleado(idEmpleado, idUnidad, false);
    }

    @Transactional
    public void activarEmpleado(Long idEmpleado, Long idUnidad) {
        cambiarEstadoEmpleado(idEmpleado, idUnidad, true);
    }

    private void cambiarEstadoEmpleado(
            Long idEmpleado,
            Long idUnidad,
            boolean estado) {

        Staff staff = staffRepository
                .findByIdAndUnidadDeVenta_Id(idEmpleado, idUnidad)
                .orElseThrow(() -> new IllegalArgumentException(
                        "El empleado no pertenece a esta unidad de venta."));

        staff.setActivo(estado);
        staff.setFechaBaja(estado ? null : LocalDate.now());

        staffRepository.save(staff);
    }
}

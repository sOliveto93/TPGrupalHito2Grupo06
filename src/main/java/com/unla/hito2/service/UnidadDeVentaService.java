package com.unla.hito2.service;

import com.unla.hito2.Enum.Rol;
import com.unla.hito2.dto.RegistroUnidadDto;
import com.unla.hito2.dto.ReporteMayoresCanonDTO;
import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.entity.*;
import com.unla.hito2.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
public class UnidadDeVentaService {

    private final UserRepository userRepository;
    private final UnidadDeVentaRepository unidadDeVentaRepository;
    private final FestivalRepository festivalRepository;
    private final UsuarioRolRepository usuarioRolRepository;
    private final StaffRepository staffRepository;
    private final PasswordEncoder passwordEncoder;

    public UnidadDeVentaService(UnidadDeVentaRepository unidadDeVentaRepository, UserRepository userRepository,
            FestivalRepository festivalRepository, UsuarioRolRepository usuarioRolRepository,
            StaffRepository staffRepository, PasswordEncoder passwordEncoder) {
        this.unidadDeVentaRepository = unidadDeVentaRepository;
        this.userRepository = userRepository;
        this.festivalRepository = festivalRepository;
        this.usuarioRolRepository = usuarioRolRepository;
        this.staffRepository = staffRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public UnidadDeVenta registrarUnidadConResponsable(RegistroUnidadDto dto) throws Exception {

        if (!dto.getDni().matches("^\\d{7,8}$")) {
            throw new Exception("El DNI debe contener entre 7 y 8 dígitos numericos");
        }
        if (staffRepository.existsByDni(dto.getDni())) {
            throw new Exception("Ya existe un usuario/responsable registrado con el DNI: " + dto.getDni());
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new Exception("Ya existe un usuario registrado con este email");
        }
        if (dto.getFechaIngreso() == null) {
            dto.setFechaIngreso(java.time.LocalDate.now());
        }
        int edad = Period.between(dto.getFechaNac(), LocalDate.now()).getYears();

        if (edad < 18) {
            throw new Exception("El Usuario debe ser mayor de edad");
        }
        if (dto.getFechaIngreso().isBefore(dto.getFechaNac())) {
            throw new Exception("La fecha de ingreso no puede ser anterior a la fecha de nacimiento.");
        }
        if (!festivalRepository.existsById(dto.getFestivalId())) {
            throw new Exception("El festival no existe");
        }

        if ("FOOD_TRUCK".equalsIgnoreCase(dto.getTipoUnidad())) {
            if (dto.getPatente() == null || dto.getPatente().trim().isEmpty()) {
                throw new Exception("La patente es obligatoria para las unidades de tipo Food Truck.");
            }
            String patenteClean = dto.getPatente().replaceAll("[\\s-]", "").toUpperCase();
            boolean tradicional = patenteClean.matches("^[A-Z]{3}\\d{3}$"); // ABC123
            boolean mercosur = patenteClean.matches("^[A-Z]{2}\\d{3}[A-Z]{2}$"); // AA123CD

            if (!tradicional && !mercosur) {
                throw new Exception("Formato inválido: la patente debe ser ABC123 (tradicional) o AA123CD (Mercosur).");
            }
            dto.setPatente(patenteClean);
        }

        Festival festival = festivalRepository.findById(dto.getFestivalId()).get();

        Usuario usuario = new Usuario();
        usuario.setUsername(dto.getEmail());
        usuario.setEmail(dto.getEmail());
        usuario.setPassword(passwordEncoder.encode(dto.getPassword()));
        usuario.setEnabled(true);
        userRepository.save(usuario);

        UsuarioRol usuarioRol = new UsuarioRol();
        usuarioRol.setUsuario(usuario);
        usuarioRol.setRol(Rol.ROLE_RESPONSABLE);
        usuarioRolRepository.save(usuarioRol);

        Staff responsable = new Staff();
        responsable.setName(dto.getNombre());
        responsable.setApellido(dto.getApellido());
        responsable.setDni(dto.getDni());
        responsable.setFechaNac(dto.getFechaNac());
        responsable.setFechaIngreso(dto.getFechaIngreso());
        responsable.setActivo(true);
        responsable.setUsuario(usuario);
        staffRepository.save(responsable);

        UnidadDeVenta unidad;

        if ("FOOD_TRUCK".equalsIgnoreCase(dto.getTipoUnidad())) {
            FoodTruck ft = new FoodTruck();
            ft.setPatente(dto.getPatente());
            ft.setRequiereElectricidad(dto.getRequiereElectricidad());
            unidad = ft;
        } else {
            PuestoDesarmable pd = new PuestoDesarmable();
            pd.setCantidadCarpas(dto.getCantidadCarpas());
            pd.setTiempoMontajeMinutos(dto.getTiempoMontajeMinutos());
            unidad = pd;
        }
        unidad.setNombreComercial(dto.getNombreComercial());
        if (dto.getFechaIngreso() == null) {
            dto.setFechaIngreso(java.time.LocalDate.now());
        }
        responsable.setFechaIngreso(dto.getFechaIngreso());
        String prefijo = "FOOD_TRUCK".equalsIgnoreCase(dto.getTipoUnidad()) ? "FT" : "PD";
        long maxFt = unidadDeVentaRepository.findAll().stream()
                .map(UnidadDeVenta::getCodigo)
                .filter(c -> c != null && c.toUpperCase().startsWith("FT"))
                .map(c -> {
                    try {
                        String num = c.substring(2);
                        return Long.parseLong(num.replaceAll("\\D", ""));
                    } catch (Exception e) {
                        return 0L;
                    }
                })
                .max(Long::compareTo)
                .orElse(0L);
        long maxPd = unidadDeVentaRepository.findAll().stream()
                .map(UnidadDeVenta::getCodigo)
                .filter(c -> c != null && c.toUpperCase().startsWith("PD"))
                .map(c -> {
                    try {
                        String num = c.substring(2);
                        return Long.parseLong(num.replaceAll("\\D", ""));
                    } catch (Exception e) {
                        return 0L;
                    }
                })
                .max(Long::compareTo)
                .orElse(0L);
        long next = "FOOD_TRUCK".equalsIgnoreCase(dto.getTipoUnidad()) ? maxFt + 1 : maxPd + 1;
        String codigoFinal = String.format(prefijo + "%08d", next);
        while (unidadDeVentaRepository.existsByCodigo(codigoFinal)) {
            next++;
            codigoFinal = String.format(prefijo + "%08d", next);
        }
        unidad.setCodigo(codigoFinal);
        unidad.setSuperficie(dto.getSuperficie());
        unidad.setResponsable(responsable);
        unidad.setFestival(festival);

        return unidadDeVentaRepository.save(unidad);

    }

    public UnidadDeVenta buscarPorResponsable(String identificador) throws Exception {
        return unidadDeVentaRepository.findByResponsable(identificador)
                .orElseThrow(() -> new Exception(
                        "No se encontró una Unidad de Venta asociada al usuario: " + identificador));
    }

    public UnidadDeVenta buscarPorEmpleado(String username) throws Exception {
        return unidadDeVentaRepository
                .findByEmpleados_Usuario_Username(username)
                .orElseThrow(() -> new Exception(
                        "No se encontró una unidad de venta para el empleado: " + username));
    }

    public List<UnidadDeVentaDto> buscarPorFestival(Long id) {
        List<UnidadDeVenta> lista = unidadDeVentaRepository.findByFestivalId(id);
        List<UnidadDeVentaDto> dtos = new ArrayList<>();

        if (!lista.isEmpty()) {
            for (UnidadDeVenta unidad : lista) {

                UnidadDeVentaDto dto = new UnidadDeVentaDto();
                dto.setId(unidad.getId());
                dto.setNombreComercial(unidad.getNombreComercial());
                dto.setCodigo(unidad.getCodigo());
                dto.setSuperficie(unidad.getSuperficie());
                dto.setResponsable(unidad.getResponsable());
                dto.setEmpleados(unidad.getEmpleados());
                dto.setCierresDeCaja(unidad.getCierresDeCaja());
                dto.setPlatos(unidad.getPlatos());
                dto.setPedidos(unidad.getPedidos());
                dtos.add(dto);
            }

        }
        return dtos;
    }

    private BigDecimal calcularCanon(UnidadDeVenta unidad) {

        if (unidad instanceof FoodTruck foodTruck) {
            BigDecimal canon = BigDecimal.valueOf(unidad.getSuperficie())
                    .multiply(BigDecimal.valueOf(500));

            if (foodTruck.isRequiereElectricidad()) {
                canon = canon.add(BigDecimal.valueOf(2000));
            }

            return canon;
        }

        if (unidad instanceof PuestoDesarmable puesto) {
            BigDecimal canonSuperficie = BigDecimal.valueOf(unidad.getSuperficie())
                    .multiply(BigDecimal.valueOf(500));

            BigDecimal costoMontaje = BigDecimal.valueOf(puesto.getTiempoMontajeMinutos())
                    .multiply(BigDecimal.valueOf(10));

            return canonSuperficie.subtract(costoMontaje);
        }

        throw new IllegalArgumentException("Tipo de unidad de venta no reconocido");
    }

    public List<ReporteMayoresCanonDTO> obtenerMayoresCanon(            Long idFestival, int cantidad) {

        if (cantidad <= 0) {
            throw new IllegalArgumentException(
                    "La cantidad debe ser mayor que cero");
        }

        List<UnidadDeVenta> unidades = unidadDeVentaRepository.findByFestivalId(idFestival);

        List<ReporteMayoresCanonDTO> reportes = new ArrayList<>();

        for (UnidadDeVenta unidad : unidades) {

            ReporteMayoresCanonDTO dto = new ReporteMayoresCanonDTO();

            dto.setNombreComercial(unidad.getNombreComercial());
            dto.setCodigo(unidad.getCodigo());

            if (unidad instanceof FoodTruck) {
                dto.setTipoDeUnidad("Food Truck");
            } else if (unidad instanceof PuestoDesarmable) {
                dto.setTipoDeUnidad("Puesto Desarmable");
            } else {
                throw new IllegalArgumentException(
                        "Tipo de unidad de venta no reconocido");
            }

            dto.setCanon(calcularCanon(unidad));

            reportes.add(dto);
        }

        Collections.sort(reportes, new Comparator<ReporteMayoresCanonDTO>() {
            @Override
            public int compare(
                    ReporteMayoresCanonDTO reporte1,
                    ReporteMayoresCanonDTO reporte2) {

                return reporte2.getCanon().compareTo(reporte1.getCanon());
            }
        });

        if (reportes.size() > cantidad) {
            return new ArrayList<>(reportes.subList(0, cantidad));
        }

        return reportes;
    }

}

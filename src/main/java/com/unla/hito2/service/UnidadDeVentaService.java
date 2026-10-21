package com.unla.hito2.service;

import com.unla.hito2.Enum.Rol;
import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.dto.RegistroUnidadDto;
import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.entity.*;
import com.unla.hito2.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.Period;
import java.util.ArrayList;
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
        if (dto.getCodigo().length() != 10) {
            throw new Exception("El codigo debe tener 10 digitos.");
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new Exception("Ya existe un usuario registrado con este email");
        }
        if (unidadDeVentaRepository.existsByCodigo(dto.getCodigo())) {
            throw new Exception("Ya existe una unidad registrada con este codigo");
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
        unidad.setCodigo(dto.getCodigo());
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
}

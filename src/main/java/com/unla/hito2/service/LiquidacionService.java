package com.unla.hito2.service;

import com.unla.hito2.entity.*;
import com.unla.hito2.repository.*;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayInputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Period;

@Service
public class LiquidacionService {

    private final LiquidacionRepository liquidacionRepository;
    private final StaffRepository staffRepository;
    private final FestivalRepository festivalRepository;
    private final PdfService pdfService;
    private final EmailService emailService;
    private UnidadDeVentaRepository unidadDeVentaRepository;

    public LiquidacionService(LiquidacionRepository liquidacionRepository,
            StaffRepository staffRepository,
            FestivalRepository festivalRepository,
            PdfService pdfService,
            EmailService emailService, UnidadDeVentaRepository unidadDeVentaRepository) {
        this.liquidacionRepository = liquidacionRepository;
        this.staffRepository = staffRepository;
        this.festivalRepository = festivalRepository;
        this.pdfService = pdfService;
        this.emailService = emailService;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
    }

    @Transactional
    public LiquidacionHaberes generarLiquidacion(Long staffId, Long festivalId) throws Exception {

        Staff empleado = staffRepository.findById(staffId)
                .orElseThrow(() -> new Exception("Empleado no encontrado"));

        Festival festival = festivalRepository.findById(festivalId)
                .orElseThrow(() -> new Exception("Festival no encontrado"));

        Costos costos = festival.getCostos();

        if (costos == null) {
            throw new IllegalStateException(
                    "El festival no tiene costos configurados");
        }

        LocalDate fechaInicioFestival = festival.getFechaInicio();
        LocalDate fechaFinFestival = festival.getFechaFin();

        if (fechaInicioFestival == null || fechaFinFestival == null
                || fechaFinFestival.isBefore(fechaInicioFestival)) {
            throw new IllegalStateException("Las fechas del festival no son válidas");
        }

        if (empleado.getFechaIngreso() == null) {
            throw new IllegalStateException("El empleado no tiene fecha de ingreso");
        }

        int diasFestival = (int) (fechaFinFestival.toEpochDay()
                - fechaInicioFestival.toEpochDay()) + 1;
        LocalDate fechaInicioTrabajo = empleado.getFechaIngreso().isAfter(fechaInicioFestival)
        ? empleado.getFechaIngreso()
        : fechaInicioFestival;
        LocalDate fechaFinTrabajo = LocalDate.now().isBefore(fechaFinFestival)
                ? LocalDate.now()
                : fechaFinFestival;

        int diasTrabajados = 0;

        if (!fechaInicioTrabajo.isAfter(fechaFinTrabajo)) {
            diasTrabajados = (int) (fechaFinTrabajo.toEpochDay()
                    - fechaInicioTrabajo.toEpochDay()) + 1;
        }
        BigDecimal sueldoBase = costos.getSueldoBase() != null
                ? costos.getSueldoBase()
                : new BigDecimal("100000");

        BigDecimal adicional = BigDecimal.ZERO;

        // Calcular adicionales según tipo de empleado
        if (empleado instanceof Cajero) {
            // en lugar de localdateNow considerar utilizar la fecha fin festival
            // fechaFinFestival
            int antiguedad = Period.between(
                    empleado.getFechaIngreso(),
                    LocalDate.now()).getYears();

            if (antiguedad > 0 && costos.getPlusAnualAntiguedad() != null) {
                adicional = costos.getPlusAnualAntiguedad()
                        .multiply(BigDecimal.valueOf(antiguedad));
            }

        } else if (empleado instanceof Cocinero cocinero) {

            if (cocinero.getCategoria() != null) {
                switch (cocinero.getCategoria()) {
                    case COCINERO ->
                        adicional = costos.getPlusCocinero() != null
                                ? costos.getPlusCocinero()
                                : new BigDecimal("150000");

                    case AYUDANTE_COCINA ->
                        adicional = costos.getPlusAyudanteCocina() != null
                                ? costos.getPlusAyudanteCocina()
                                : new BigDecimal("100000");

                    case LAVAPLATOS ->
                        adicional = costos.getPlusLavaplatos() != null
                                ? costos.getPlusLavaplatos()
                                : new BigDecimal("50000");

                    default -> adicional = BigDecimal.ZERO;
                }
            }
        }

        BigDecimal subtotal = sueldoBase.add(adicional);

        // Calcular factor según duración del festival
        BigDecimal factor;

        if (diasFestival <= 15) {
            factor = new BigDecimal("0.50");

        } else if (diasFestival <= 30) {
            factor = BigDecimal.ONE;

        } else {
            int multiplicador = (diasFestival / 15) + 1;
            factor = new BigDecimal("0.50")
                    .multiply(BigDecimal.valueOf(multiplicador));
        }

        BigDecimal proporcion = BigDecimal.valueOf(diasTrabajados)
                .divide(
                        BigDecimal.valueOf(diasFestival),
                        4,
                        RoundingMode.HALF_UP);

        BigDecimal total = subtotal
                .multiply(factor)
                .multiply(proporcion)
                .setScale(2, RoundingMode.HALF_UP);

        // Crear liquidación
        LiquidacionHaberes liquidacion = new LiquidacionHaberes();

        liquidacion.setEmpleado(empleado);
        liquidacion.setFestival(festival);
        liquidacion.setFecha(LocalDate.now());
        liquidacion.setDiasFestival(diasFestival);
        liquidacion.setDiasTrabajados(diasTrabajados);
        liquidacion.setSueldo(sueldoBase.setScale(2, RoundingMode.HALF_UP));
        liquidacion.setAdicionalAplicado(adicional.setScale(2, RoundingMode.HALF_UP));
        liquidacion.setFactorAplicado(factor.setScale(2, RoundingMode.HALF_UP));
        liquidacion.setTotal(total);

        return liquidacionRepository.save(liquidacion);
    }

    @Transactional(readOnly = true)
    public void enviarLiquidacionPorMail(Long liquidacionId, String usernameAutenticado) throws Exception {
        LiquidacionHaberes liquidacion = liquidacionRepository.findById(liquidacionId)
                .orElseThrow(() -> new Exception("Liquidación no encontrada"));

        if (liquidacion.getEmpleado() == null
                || liquidacion.getEmpleado().getUsuario() == null
                || !usernameAutenticado.equals(liquidacion.getEmpleado().getUsuario().getUsername())) {
            throw new AccessDeniedException("No tiene permisos para enviar esta liquidación por correo electrónico.");
        }

        ByteArrayInputStream pdfStream = pdfService.generarReciboLiquidacion(liquidacion);
        byte[] pdfBytes = pdfStream.readAllBytes();

        Staff empleado = liquidacion.getEmpleado();
        String nombreCompleto = ((empleado.getName() != null) ? empleado.getName() : "")
                + " "
                + ((empleado.getApellido() != null) ? empleado.getApellido() : "");
        nombreCompleto = nombreCompleto.trim();

        String emailDestino = empleado.getUsuario().getEmail();

        emailService.enviarLiquidacionPorMail(emailDestino, nombreCompleto, pdfBytes, liquidacion.getId());
    }

    @Transactional
    public int generarLiquidacionesPorUnidad(Long idUnidad) throws Exception {

        UnidadDeVenta unidad = unidadDeVentaRepository.findById(idUnidad)
                .orElseThrow(() -> new Exception("Unidad de venta no encontrada"));

        Festival festival = unidad.getFestival();

        /*
         * if (LocalDate.now().isBefore(festival.getFechaFin())) {
         * throw new IllegalStateException(
         * "Las liquidaciones solo pueden generarse cuando finaliza el festival");
         * }
         */

        int generadas = 0;

        for (Staff empleado : unidad.getEmpleados()) {

            if (!liquidacionRepository.existsByEmpleado_IdAndFestival_Id(
                    empleado.getId(), festival.getId())) {

                generarLiquidacion(empleado.getId(), festival.getId());
                generadas++;
            }
        }

        return generadas;
    }
}
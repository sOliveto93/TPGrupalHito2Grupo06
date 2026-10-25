package com.unla.hito2.service;

import com.unla.hito2.entity.*;
import com.unla.hito2.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.Period;

@Service
public class LiquidacionService {

    private final LiquidacionRepository liquidacionRepository;
    private final CostosRepository costosRepository;
    private final StaffRepository staffRepository;
    private final FestivalRepository festivalRepository;
    private final UnidadDeVentaRepository unidadDeVentaRepository;

    public LiquidacionService(LiquidacionRepository liquidacionRepository,
                              CostosRepository costosRepository,
                              StaffRepository staffRepository,
                              FestivalRepository festivalRepository,
                              UnidadDeVentaRepository unidadDeVentaRepository) {
        this.liquidacionRepository = liquidacionRepository;
        this.costosRepository = costosRepository;
        this.staffRepository = staffRepository;
        this.festivalRepository = festivalRepository;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
    }

    @Transactional
    public LiquidacionHaberes generarLiquidacion(Long staffId, Long festivalId) throws Exception {
        Staff empleado = staffRepository.findById(staffId)
                .orElseThrow(() -> new Exception("Empleado no encontrado"));
        Festival festival = festivalRepository.findById(festivalId)
                .orElseThrow(() -> new Exception("Festival no encontrado"));
        Costos costos = costosRepository.findAll().stream().findFirst()
                .orElseThrow(() -> new Exception("No hay costos configurados"));

        BigDecimal sueldoBase = costos.getSueldoBase() != null ? costos.getSueldoBase() : BigDecimal.ZERO;
        BigDecimal adicional = BigDecimal.ZERO;
        BigDecimal factor = BigDecimal.ONE;

        // Calcular adicional según categoría
        if (empleado instanceof Cajero) {
            // Para cajero según datos de ejemplo se suma un adicional
            adicional = costos.getPlusAnualAntiguedad() != null ? costos.getPlusAnualAntiguedad() : BigDecimal.ZERO;
        } else if (empleado instanceof Cocinero cocinero) {
            if (cocinero.getCategoria() != null) {
                switch (cocinero.getCategoria()) {
                    case COCINERO ->
                            adicional = costos.getPlusCocinero() != null ? costos.getPlusCocinero() : BigDecimal.ZERO;
                    case AYUDANTE_COCINA ->
                            adicional = costos.getPlusAyudanteCocina() != null ? costos.getPlusAyudanteCocina() : BigDecimal.ZERO;
                    case LAVAPLATOS ->
                            adicional = costos.getPlusLavaplatos() != null ? costos.getPlusLavaplatos() : BigDecimal.ZERO;
                    default -> adicional = BigDecimal.ZERO;
                }
            }
        } else {
            adicional = costos.getPlusAnualAntiguedad() != null ? costos.getPlusAnualAntiguedad() : BigDecimal.ZERO;
            factor = new BigDecimal("1.10");
        }
            // Antigüedad
            if (empleado.getFechaIngreso() != null) {
                int antiguedad = Period.between(empleado.getFechaIngreso(), LocalDate.now()).getYears();
                if (antiguedad > 0 && costos.getPlusAnualAntiguedad() != null) {
                    BigDecimal plusAntiguedad = costos.getPlusAnualAntiguedad().multiply(BigDecimal.valueOf(antiguedad));
                    // Agregar a adicional si no es cocinero con plus específico, o sumar
                    if (!(empleado instanceof Cocinero)) {
                        adicional = adicional.add(plusAntiguedad);
                    }
                }
            }

            // Días trabajados
            int diasFestival = 0;
            if (festival.getFechaInicio() != null && festival.getFechaFin() != null) {
                diasFestival = (int) (festival.getFechaFin().toEpochDay() - festival.getFechaInicio().toEpochDay()) + 1;
            }

            BigDecimal subtotal = sueldoBase.add(adicional);
            BigDecimal total = subtotal.multiply(factor).setScale(2, RoundingMode.HALF_UP);

            LiquidacionHaberes liquidacion = new LiquidacionHaberes();
            liquidacion.setEmpleado(empleado);
            liquidacion.setFestival(festival);
            liquidacion.setFecha(LocalDate.now());
            liquidacion.setDiasFestival(diasFestival);
            liquidacion.setSueldo(sueldoBase.setScale(2, RoundingMode.HALF_UP));
            liquidacion.setAdicionalAplicado(adicional.setScale(2, RoundingMode.HALF_UP));
            liquidacion.setFactorAplicado(factor.setScale(2, RoundingMode.HALF_UP));
            liquidacion.setTotal(total);

            return liquidacionRepository.save(liquidacion);
        }
    }

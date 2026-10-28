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

    public LiquidacionService(LiquidacionRepository liquidacionRepository,
                              CostosRepository costosRepository,
                              StaffRepository staffRepository,
                              FestivalRepository festivalRepository) {
        this.liquidacionRepository = liquidacionRepository;
        this.costosRepository = costosRepository;
        this.staffRepository = staffRepository;
        this.festivalRepository = festivalRepository;
    }

    @Transactional
    public LiquidacionHaberes generarLiquidacion(Long staffId, Long festivalId) throws Exception {
        Staff empleado = staffRepository.findById(staffId)
                .orElseThrow(() -> new Exception("Empleado no encontrado"));
        Festival festival = festivalRepository.findById(festivalId)
                .orElseThrow(() -> new Exception("Festival no encontrado"));

        Costos costos = costosRepository.findAll().stream().findFirst()
                .orElseThrow(() -> new Exception("No hay costos configurados"));

        BigDecimal sueldoBase = costos.getSueldoBase() != null ? costos.getSueldoBase() : new BigDecimal("100000");
        BigDecimal adicional = BigDecimal.ZERO;

        if (empleado instanceof Cajero) {
            if (empleado.getFechaIngreso() != null) {
                int antiguedad = Period.between(empleado.getFechaIngreso(), LocalDate.now()).getYears();
                if (antiguedad > 0 && costos.getPlusAnualAntiguedad() != null) {
                    adicional = costos.getPlusAnualAntiguedad().multiply(BigDecimal.valueOf(antiguedad));
                }
            }
        } else if (empleado instanceof Cocinero cocinero) {
            if (cocinero.getCategoria() != null) {
                switch (cocinero.getCategoria()) {
                    case COCINERO ->
                            adicional = costos.getPlusCocinero() != null ? costos.getPlusCocinero() : new BigDecimal("150000");
                    case AYUDANTE_COCINA ->
                            adicional = costos.getPlusAyudanteCocina() != null ? costos.getPlusAyudanteCocina() : new BigDecimal("100000");
                    case LAVAPLATOS ->
                            adicional = costos.getPlusLavaplatos() != null ? costos.getPlusLavaplatos() : new BigDecimal("50000");
                    default -> adicional = BigDecimal.ZERO;
                }
            }
        }

        BigDecimal subtotal = sueldoBase.add(adicional);

        int diasFestival = 0;
        BigDecimal factor = BigDecimal.ONE;

        if (festival.getFechaInicio() != null && festival.getFechaFin() != null) {
            diasFestival = (int) (festival.getFechaFin().toEpochDay() - festival.getFechaInicio().toEpochDay()) + 1;
        }

        if (diasFestival <= 15) {
            factor = new BigDecimal("0.50");
        } else if (diasFestival <= 30) {
            factor = new BigDecimal("1.00");
        } else {
            // formula (int(diasDurFest / 15) + 1) * 0.50
            int multiplicador = (diasFestival / 15) + 1;
            factor = new BigDecimal("0.50").multiply(BigDecimal.valueOf(multiplicador));
        }

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
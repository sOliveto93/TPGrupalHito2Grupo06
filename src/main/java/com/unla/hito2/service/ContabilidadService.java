package com.unla.hito2.service;

import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.repository.LiquidacionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ContabilidadService {

    private final LiquidacionRepository liquidacionRepository;

    public ContabilidadService(LiquidacionRepository liquidacionRepository) {
        this.liquidacionRepository = liquidacionRepository;
    }

    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerLiquidacionesPorEmpleado(String username) {
        return liquidacionRepository.findByEmpleadoIdentificador(username);
    }

    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerTodasLasLiquidaciones() {
        return liquidacionRepository.findAllConFetch();
    }
}
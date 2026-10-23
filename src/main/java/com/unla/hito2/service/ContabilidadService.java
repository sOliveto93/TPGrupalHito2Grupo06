package com.unla.hito2.service;

import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.dto.UnidadDeVentaRankingDto;
import com.unla.hito2.entity.DetallePedido;
import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.LiquidacionRepository;
import com.unla.hito2.repository.UnidadDeVentaRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class ContabilidadService {

    private final LiquidacionRepository liquidacionRepository;
    private UnidadDeVentaRepository unidadDeVentaRepository;

    public ContabilidadService(LiquidacionRepository liquidacionRepository,
            UnidadDeVentaRepository unidadDeVentaRepository) {
        this.liquidacionRepository = liquidacionRepository;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
    }

    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerLiquidacionesPorEmpleado(String username) {
        return liquidacionRepository.findByEmpleadoIdentificador(username);
    }

    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerTodasLasLiquidaciones() {
        return liquidacionRepository.findAllConFetch();
    }

    @Transactional(readOnly = true)
    public List<UnidadDeVentaRankingDto> rankingUnidadesVentaPorPedido(Long id) {
        List<UnidadDeVenta> unidadesVenta = unidadDeVentaRepository.findByFestivalId(id);
        List<UnidadDeVentaRankingDto> dtos=new ArrayList<>();

        for (UnidadDeVenta unidadActual : unidadesVenta) {
            
            BigDecimal ingresosPorUnidad = BigDecimal.ZERO;
            
            for (Pedido pedido : unidadActual.getPedidos()) {
            
                for (DetallePedido detalle : pedido.getDetalles()) {
            
                    ingresosPorUnidad = ingresosPorUnidad.add(detalle.getSubtotal());
                }
            }
            
            UnidadDeVentaRankingDto dto =new UnidadDeVentaRankingDto();
            
            dto.setId(unidadActual.getId());
            dto.setCodigo(unidadActual.getCodigo());
            dto.setNombreComercial(unidadActual.getNombreComercial());
            dto.setIngresos(ingresosPorUnidad);
            dtos.add(dto);
            
            ingresosPorUnidad = BigDecimal.ZERO;
        }
        dtos.sort((a, b) -> b.getIngresos().compareTo(a.getIngresos()));

        return dtos;
    }
}
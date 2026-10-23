package com.unla.hito2.service;

import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.dto.UnidadDeVentaRankingDto;
import com.unla.hito2.entity.DetallePedido;
import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.Staff;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.LiquidacionRepository;
import com.unla.hito2.repository.UnidadDeVentaRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

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
    public List<LiquidacionHaberes> obtenerLiquidacionesPorEmpleadoHistorico(String username) {
        return liquidacionRepository.buscarLiquidacionesPorEmpleadoHistorico(username);
    }

    @Transactional(readOnly = true)
    public LiquidacionHaberes obtenerLiquidacionesPorEmpleadoPorUnidad(String username, Long idUnidad,
            Long idFestival) {
        return liquidacionRepository.buscarLiquidacionPorEmpleadoYUnidadDeVenta(username, idUnidad, idFestival);
    }

    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerTodasLasLiquidaciones() {
        return liquidacionRepository.findAllConFetch();
    }

    @Transactional(readOnly = true)
    public List<UnidadDeVentaRankingDto> rankingUnidadesVentaPorPedido(Long id) {
        List<UnidadDeVenta> unidadesVenta = unidadDeVentaRepository.findByFestivalId(id);
        List<UnidadDeVentaRankingDto> dtos = new ArrayList<>();

        for (UnidadDeVenta unidadActual : unidadesVenta) {

            BigDecimal ingresosPorUnidad = BigDecimal.ZERO;

            for (Pedido pedido : unidadActual.getPedidos()) {

                for (DetallePedido detalle : pedido.getDetalles()) {

                    ingresosPorUnidad = ingresosPorUnidad.add(detalle.getSubtotal());
                }
            }

            UnidadDeVentaRankingDto dto = new UnidadDeVentaRankingDto();

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

    // asumimos una unidad de venta --> en un solo festival
    @Transactional(readOnly = true)
    public List<LiquidacionHaberes> obtenerLiquidacionesPorUnidadDeVenta(String username) {
        UnidadDeVenta unidadDeVenta = unidadDeVentaRepository.findByResponsable_Usuario_Username(username)
                .orElseThrow(() -> new RuntimeException(
                        "error no se encontro una unidad que tenga acargo el usuario -->" + username));
        List<LiquidacionHaberes> liquidaciones = new ArrayList<>();
        Long idFestival = unidadDeVenta.getFestival().getId();
        for (Staff staff : unidadDeVenta.getEmpleados()) {
            String currentUsername = staff.getUsuario().getUsername();

            LiquidacionHaberes liquidacion = obtenerLiquidacionesPorEmpleadoPorUnidad(currentUsername,
                    unidadDeVenta.getId(), idFestival);

            if (liquidacion != null) {
                liquidaciones.add(liquidacion);
            }
        }
        return liquidaciones;
    }
}
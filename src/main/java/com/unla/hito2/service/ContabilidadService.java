package com.unla.hito2.service;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.dto.ReporteVentaDto;
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

import java.util.List;

@Service
public class ContabilidadService {

    private final LiquidacionRepository liquidacionRepository;
    private UnidadDeVentaRepository unidadDeVentaRepository;
    private FestivalService festivalService;

    public ContabilidadService(LiquidacionRepository liquidacionRepository,
            UnidadDeVentaRepository unidadDeVentaRepository, FestivalService festivalService) {
        this.liquidacionRepository = liquidacionRepository;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
        this.festivalService = festivalService;
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
    public List<UnidadDeVentaRankingDto> calcularIngresoPorUnidadPorFestival(Long id) {
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
        return dtos;
    }

    @Transactional(readOnly = true)
    public List<UnidadDeVentaRankingDto> rankingUnidadesVentaPorPedido(Long id) {
        List<UnidadDeVentaRankingDto> dtos = calcularIngresoPorUnidadPorFestival(id);

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

    @Transactional(readOnly = true)
    public ReporteVentaDto generarReporteVentaPorFestival(Long id) {
        List<UnidadDeVentaRankingDto> lista = calcularIngresoPorUnidadPorFestival(id);

        BigDecimal recaudacionTotal = BigDecimal.ZERO;
        for (UnidadDeVentaRankingDto actual : lista) {
            recaudacionTotal = recaudacionTotal.add(actual.getIngresos());
        }
        ReporteVentaDto reporte = new ReporteVentaDto();
        reporte.setRecaudacionTotal(recaudacionTotal);
        FestivalDto festival = festivalService.traerFestivalPorId(id);

        reporte.setFestival(festival);

        return reporte;
    }
}
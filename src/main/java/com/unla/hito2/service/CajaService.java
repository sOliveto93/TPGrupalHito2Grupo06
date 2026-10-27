package com.unla.hito2.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unla.hito2.entity.Cajero;
import com.unla.hito2.entity.CierreDeCaja;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.CajeroRepository;
import com.unla.hito2.repository.CierreDeCajaRepository;
import com.unla.hito2.repository.PedidoRepository;
import com.unla.hito2.repository.UnidadDeVentaRepository;

@Service
public class CajaService {

    private final CajeroRepository cajeroRepository;
    private final CierreDeCajaRepository cierreDeCajaRepository;
    private final UnidadDeVentaRepository unidadDeVentaRepository;
    private final PedidoRepository pedidoRepository;

    public CajaService(
            CajeroRepository cajeroRepository,
            CierreDeCajaRepository cierreDeCajaRepository,
            UnidadDeVentaRepository unidadDeVentaRepository,
            PedidoRepository pedidoRepository) {
        this.cajeroRepository = cajeroRepository;
        this.cierreDeCajaRepository = cierreDeCajaRepository;
        this.unidadDeVentaRepository = unidadDeVentaRepository;
        this.pedidoRepository = pedidoRepository;
    }

    @Transactional
    public void abrirCaja(String username) {

        Cajero cajero = cajeroRepository.findByUsuario_Username(username)
                .orElseThrow(() -> new IllegalStateException("El usuario no es un cajero registrado."));

        if (!cajero.isActivo()) {
            throw new IllegalStateException("El cajero no está activo.");
        }

        UnidadDeVenta unidad = cajero.getUnidadDeVenta();

        if (unidad == null) {
            throw new IllegalStateException(
                    "El cajero no tiene una unidad de venta asignada.");
        }

        if (unidad.isCajaAbierta()) {
            throw new IllegalStateException("La caja ya está abierta.");
        }
        boolean existeCierrePendiente = cierreDeCajaRepository
                .buscarCierrePendiente(unidad.getId())
                .isPresent();
        if (existeCierrePendiente) {
            throw new IllegalStateException(
                    "La caja ya se encuentra pendiente de cierre.");
        }
        CierreDeCaja cierre = new CierreDeCaja();
        // se crea para pero se deja incompleta para luego cerrarla
        cierre.setCajero(cajero);
        cierre.setFestival(unidad.getFestival());
        cierre.setUnidadDeVenta(unidad);
        cierre.setFechaHoraApertura(LocalDateTime.now());

        cierreDeCajaRepository.save(cierre);

        unidad.setCajaAbierta(true);
        unidadDeVentaRepository.save(unidad);
    }

    @Transactional
    public void cerrarCaja(String username, BigDecimal totalDeclarado) {

        if (totalDeclarado == null || totalDeclarado.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    "El total declarado debe ser mayor o igual a cero.");
        }

        Cajero cajero = cajeroRepository.findByUsuario_Username(username)
                .orElseThrow(() -> new IllegalStateException("El usuario no es un cajero registrado."));

        if (!cajero.isActivo()) {
            throw new IllegalStateException("El cajero no está activo.");
        }

        UnidadDeVenta unidad = cajero.getUnidadDeVenta();

        if (unidad == null) {
            throw new IllegalStateException(
                    "El cajero no tiene una unidad de venta asignada.");
        }

        if (!unidad.isCajaAbierta()) {
            throw new IllegalStateException("La caja ya está cerrada.");
        }

        CierreDeCaja cierre = cierreDeCajaRepository
                .buscarCierrePendiente(unidad.getId())
                .orElseThrow(() -> new IllegalStateException(
                        "No existe un cierre pendiente para la unidad de venta "
                                + unidad.getId() + "."));
//no se pide pero es de sentido comun.. consultar!!
        if (!cierre.getCajero().getId().equals(cajero.getId())) {
            throw new IllegalStateException(
                    "Solo el cajero que abrió la caja puede cerrarla.");
        }

        LocalDateTime fechaHoraCierre = LocalDateTime.now();

        BigDecimal totalSistema = pedidoRepository.calcularTotalCaja(
                unidad.getId(),
                cierre.getFechaHoraApertura(),
                fechaHoraCierre);

        BigDecimal diferencia = totalDeclarado.subtract(totalSistema);

        cierre.setFechaHoraCierre(fechaHoraCierre);
        cierre.setTotalSistema(totalSistema);
        cierre.setTotalDeclarado(totalDeclarado);
        cierre.setDiferencia(diferencia);

        cierreDeCajaRepository.save(cierre);

        unidad.setCajaAbierta(false);
        unidadDeVentaRepository.save(unidad);
    }

    public boolean isCajero(String username){
        return cajeroRepository.existsByUsuario_Username(username);
    }
}

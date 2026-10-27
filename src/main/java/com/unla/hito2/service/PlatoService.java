package com.unla.hito2.service;

import com.unla.hito2.dto.AltaPlatoDto;
import com.unla.hito2.dto.PlatoEstrellaDto;
import com.unla.hito2.dto.pedido.PlatoPedidoDto;
import com.unla.hito2.entity.Plato;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.PlatoRepository;
import jakarta.transaction.Transactional;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class PlatoService {

    private final PlatoRepository platoRepository;

    public PlatoService(PlatoRepository platoRepository) {
        this.platoRepository = platoRepository;
    }

    @Transactional
    public Plato registrarPlato(AltaPlatoDto dto, UnidadDeVenta unidadDeVenta) {

        if (unidadDeVenta == null) {
            throw new IllegalArgumentException(
                    "El responsable no tiene una unidad de venta asignada");
        }

        if (dto.getPrecio().compareTo(dto.getCosto()) < 0) {
            throw new IllegalArgumentException(
                    "El precio de venta no puede ser menor que el costo");
        }

        Plato plato = new Plato();
        plato.setNombre(dto.getNombre().trim());
        plato.setPrecio(dto.getPrecio());
        plato.setCosto(dto.getCosto());
        plato.setActivo(true);
        plato.setUnidadDeVenta(unidadDeVenta);

        return platoRepository.save(plato);

    }

    @Transactional
    public List<PlatoEstrellaDto> traerPlatosEstrellaFestival(Long idFestival) {

        return platoRepository.buscarPlatosMasVendidosPorFestival(idFestival)
                .stream()
                .limit(3)
                .toList();
    }

    @Transactional
    public List<Plato> traerPlatosPorUnidad(Long idUnidadDeVenta) {
        return platoRepository.findByUnidadDeVenta_Id(idUnidadDeVenta);
    }

    @Transactional
    public void desactivarPlato(Long idPlato, Long idUnidadDeVenta) {
        cambiarEstadoPlato(idPlato, idUnidadDeVenta, false);
    }

    @Transactional
    public void activarPlato(Long idPlato, Long idUnidadDeVenta) {
        cambiarEstadoPlato(idPlato, idUnidadDeVenta, true);
    }
   

    private void cambiarEstadoPlato(
            Long idPlato,
            Long idUnidadDeVenta,
            boolean estado) {

        Plato plato = platoRepository
                .findByIdAndUnidadDeVenta_Id(idPlato, idUnidadDeVenta)
                .orElseThrow(() -> new IllegalArgumentException(
                        "El plato no existe en esta unidad de venta"));

        plato.setActivo(estado);
        platoRepository.save(plato);
    }
}

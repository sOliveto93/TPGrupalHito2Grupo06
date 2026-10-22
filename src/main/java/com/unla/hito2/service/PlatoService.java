package com.unla.hito2.service;

import com.unla.hito2.dto.AltaPlatoDto;
import com.unla.hito2.entity.Plato;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.PlatoRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class PlatoService {

    private final PlatoRepository platoRepository;

    public PlatoService(PlatoRepository platoRepository) {
        this.platoRepository = platoRepository;
    }

    @Transactional
    public Plato registrarPlato(AltaPlatoDto dto, UnidadDeVenta unidadDeVenta){

        if(unidadDeVenta == null){
            throw new IllegalArgumentException(
                    "El responsable no tiene una unidad de venta asignada");
        }

        Plato plato = new Plato();
        plato.setNombre(dto.getNombre().trim());
        plato.setPrecio(dto.getPrecio());
        plato.setCosto(dto.getCosto());
        plato.setActivo(true);
        plato.setUnidadDeVenta(unidadDeVenta);

        return platoRepository.save(plato);

    }


}

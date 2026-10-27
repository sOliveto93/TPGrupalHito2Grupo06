package com.unla.hito2.repository;

import com.unla.hito2.dto.PlatoEstrellaDto;
import com.unla.hito2.entity.Plato;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PlatoRepository extends JpaRepository<Plato, Long> {

    Optional<Plato> findByIdAndUnidadDeVenta_Id(Long id, Long idUnidadDeVenta);
    List<Plato> findByUnidadDeVenta_Id(Long idUnidadDeVenta);
    
    //devolvemos platos vendidos y agrupados por plato y ordenados de mayor a menor
    @Query("""
            SELECT NEW com.unla.hito2.dto.PlatoEstrellaDto(
                p.id,
                p.nombre,
                SUM(d.cantidad)
            )
            FROM DetallePedido d
            JOIN d.pedido pe
            JOIN pe.unidadDeVenta u
            JOIN u.festival f
            JOIN d.plato p
            WHERE f.id = :idFestival
            GROUP BY p.id, p.nombre
            ORDER BY SUM(d.cantidad) DESC
            """)
    List<PlatoEstrellaDto> buscarPlatosMasVendidosPorFestival(
            @Param("idFestival") Long idFestival);
}

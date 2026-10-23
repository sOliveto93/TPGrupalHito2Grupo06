package com.unla.hito2.repository;

import com.unla.hito2.entity.Festival;
import com.unla.hito2.entity.Pedido;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FestivalRepository extends JpaRepository<Festival, Long> {

    // festiva activo o inactivo entre fechas
    @Query("""
            SELECT f FROM Festival f
            WHERE (:fechaInicio IS NULL OR f.fechaFin >= :fechaInicio)
              AND (:fechaFin IS NULL OR f.fechaInicio <= :fechaFin)
            ORDER BY f.fechaInicio ASC
            """)
    List<Festival> buscarEntreFechas(@Param("fechaInicio") LocalDate fechaInicio,
            @Param("fechaFin") LocalDate fechaFin);

    // actuales activos y proximos
    List<Festival> findByFechaFinGreaterThanEqualOrderByFechaInicioAsc(LocalDate fecha);

    @Query("""
            SELECT f FROM Festival f
            WHERE (:nombre IS NULL OR LOWER(f.nombre) LIKE LOWER(CONCAT('%', :nombre, '%')))
              AND (:temporada IS NULL OR LOWER(f.temporada) LIKE LOWER(CONCAT('%', :temporada, '%')))
              AND (:fechaInicio IS NULL OR f.fechaFin >= :fechaInicio)
              AND (:fechaFin IS NULL OR f.fechaInicio <= :fechaFin)
            ORDER BY f.fechaInicio ASC
            """)
    List<Festival> filtrarFestivales(@Param("nombre") String nombre, @Param("temporada") String temporada,
            @Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);


}
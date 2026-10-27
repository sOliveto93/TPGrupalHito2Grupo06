package com.unla.hito2.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.unla.hito2.entity.CierreDeCaja;

public interface CierreDeCajaRepository extends JpaRepository<CierreDeCaja, Long> {

    @Query("""
            SELECT c
            FROM CierreDeCaja c
            WHERE c.unidadDeVenta.id = :unidadId
              AND c.fechaHoraCierre IS NULL
            ORDER BY c.fechaHoraApertura DESC
            """)
    Optional<CierreDeCaja> buscarCierrePendiente(
            @Param("unidadId") Long unidadId);
}

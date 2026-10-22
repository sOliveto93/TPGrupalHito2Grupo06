package com.unla.hito2.repository;


import com.unla.hito2.entity.Plato;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface PlatoRepository extends JpaRepository<Plato, Long> {

    Optional<Plato>findByIdAndUnidadDeVenta_Id(Long id, Long idUnidadDeVenta);
}

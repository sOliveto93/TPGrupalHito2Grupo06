package com.unla.hito2.repository;

import com.unla.hito2.entity.Cajero;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface CajeroRepository extends JpaRepository<Cajero, Long> {

    Optional<Cajero> findByUsuario_Username(String username);
    boolean existsByUsuario_Username(String username);
}

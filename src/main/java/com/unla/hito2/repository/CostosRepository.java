package com.unla.hito2.repository;

import com.unla.hito2.entity.Costos;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CostosRepository extends JpaRepository<Costos, Long> {
}

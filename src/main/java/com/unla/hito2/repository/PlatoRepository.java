package com.unla.hito2.repository;


import com.unla.hito2.entity.Plato;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface PlatoRepository extends JpaRepository<Plato, Long> {


}

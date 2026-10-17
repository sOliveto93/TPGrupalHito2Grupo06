package com.unla.hito2.repository;
import com.unla.hito2.entity.UnidadDeVenta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UnidadDeVentaRepository extends JpaRepository<UnidadDeVenta,Long> {

    boolean existsByCodigo(String codigo);
}

package com.unla.hito2.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.hito2.entity.HistorialUnidadVenta;

@Repository 
public interface HistorialUnidadVentaRepository extends JpaRepository<HistorialUnidadVenta,Long>{

    List<HistorialUnidadVenta> findByStaffId(Long staffId);
}

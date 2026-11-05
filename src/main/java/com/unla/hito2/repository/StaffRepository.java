package com.unla.hito2.repository;

import com.unla.hito2.entity.Staff;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {
    public boolean existsByDni(String dni);

    boolean existsByUsuario_UsernameAndActivoTrue(String username);

    Optional<Staff> findByUsuario_Username(String username);
    Optional<Staff> findByIdAndUnidadDeVenta_Id(Long id, Long idUnidad);
    List<Staff> findByUnidadDeVenta_Id(Long idUnidad);

    @Query("""
        SELECT s FROM Staff s
        WHERE s.unidadDeVenta.id = :idUnidad
          AND s.activo = true
          AND (:nombre = '' OR LOWER(s.name) LIKE LOWER(CONCAT('%', :nombre, '%')))
          AND (:apellido = '' OR LOWER(s.apellido) LIKE LOWER(CONCAT('%', :apellido, '%')))
          AND (:dni = '' OR s.dni LIKE CONCAT('%', :dni, '%'))
        ORDER BY s.apellido ASC, s.name ASC
        """)
    List<Staff> filtrarEmpleados(
            @Param("idUnidad") Long idUnidad,
            @Param("nombre") String nombre,
            @Param("apellido") String apellido,
            @Param("dni") String dni);

}

package com.unla.hito2.repository;
import com.unla.hito2.entity.UnidadDeVenta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UnidadDeVentaRepository extends JpaRepository<UnidadDeVenta,Long> {

  
    boolean existsByCodigo(String codigo);
    @Query("SELECT u FROM UnidadDeVenta u WHERE u.responsable.usuario.username = :identificador OR u.responsable.usuario.email = :identificador")
    Optional<UnidadDeVenta> findByResponsable(@Param("identificador") String identificador);
    Optional<UnidadDeVenta> findByResponsableUsuarioEmail(String email);
    @Query("SELECT u FROM UnidadDeVenta u WHERE u.festival.id = :id")
    List<UnidadDeVenta> findByFestivalId(@Param("id") Long id);
    Optional<UnidadDeVenta> findByEmpleados_Usuario_Username(String username);
    Optional<UnidadDeVenta> findByResponsable_Usuario_Username(String username);

  
}

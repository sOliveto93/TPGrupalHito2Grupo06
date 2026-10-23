package com.unla.hito2.repository;

import com.unla.hito2.entity.LiquidacionHaberes;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LiquidacionRepository extends JpaRepository<LiquidacionHaberes, Long> {

    @Query("SELECT DISTINCT l FROM LiquidacionHaberes l " +
            "LEFT JOIN FETCH l.festival " +
            "LEFT JOIN FETCH l.empleado e " +
            "LEFT JOIN FETCH e.usuario u " +
            "WHERE u.username = :identificador OR u.email = :identificador")
    List<LiquidacionHaberes> buscarLiquidacionesPorEmpleadoHistorico(@Param("identificador") String identificador);

    //asumiendo que es solo una liquidacion de empleado por unidad de venta
     @Query("""
        SELECT DISTINCT l FROM LiquidacionHaberes l 
            LEFT JOIN FETCH l.festival 
            LEFT JOIN FETCH l.empleado e 
        LEFT JOIN FETCH e.usuario u 
            WHERE (u.username = :username OR u.email = :username)
        AND e.unidadDeVenta.id = :idUnidad
        AND l.festival.id = :idFestival""")
    LiquidacionHaberes buscarLiquidacionPorEmpleadoYUnidadDeVenta(@Param("username") String username, @Param("idUnidad") Long idUnidad,@Param("idFestival") Long idFestival);

        

        



    @Query("SELECT DISTINCT l FROM LiquidacionHaberes l " +
            "LEFT JOIN FETCH l.festival " +
            "LEFT JOIN FETCH l.empleado e " +
            "LEFT JOIN FETCH e.usuario u")
    List<LiquidacionHaberes> findAllConFetch();
}
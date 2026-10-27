package com.unla.hito2.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.unla.hito2.entity.Pedido;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {

     List<Pedido> findAllByUnidadDeVenta_Id(Long id);

     Page<Pedido> findAllByUnidadDeVenta_Id(Long id, Pageable pageable);

     @Query("""
               SELECT COALESCE(SUM(d.subtotal), 0)
               FROM DetallePedido d
               WHERE d.pedido.unidadDeVenta.id = :unidadId
                 AND d.pedido.fechaHora >= :apertura
                 AND d.pedido.fechaHora <= :cierre
               """)
     BigDecimal calcularTotalCaja(@Param("unidadId") Long unidadId, @Param("apertura") LocalDateTime apertura,
               @Param("cierre") LocalDateTime cierre);
}

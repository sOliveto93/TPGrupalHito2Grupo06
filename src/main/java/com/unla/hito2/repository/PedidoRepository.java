package com.unla.hito2.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.hito2.entity.Pedido;

@Repository 
public interface PedidoRepository extends JpaRepository<Pedido,Long>{

     List<Pedido> findAllByUnidadDeVenta_Id(Long id);
}

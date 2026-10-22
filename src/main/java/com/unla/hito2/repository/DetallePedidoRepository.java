package com.unla.hito2.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.unla.hito2.entity.DetallePedido;

@Repository 
public interface DetallePedidoRepository extends JpaRepository<DetallePedido,Long>{

}

package com.unla.hito2.dto.pedido;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter  @Setter @AllArgsConstructor @NoArgsConstructor 
public class PedidoDtoRequest {

    private Long idUnidadDeVenta;
    private List<DetallePedidoDtoRequest> detalles;
}

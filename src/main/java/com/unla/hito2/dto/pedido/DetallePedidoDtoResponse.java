package com.unla.hito2.dto.pedido;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DetallePedidoDtoResponse {

    private Long platoId;
    private String nombrePlato;
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal;
}

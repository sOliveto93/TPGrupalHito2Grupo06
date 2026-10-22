package com.unla.hito2.dto.pedido;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PlatoPedidoDto {

    private Long id;
    private String nombre;
    private BigDecimal precio;
}

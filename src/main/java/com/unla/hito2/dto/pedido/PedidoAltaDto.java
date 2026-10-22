package com.unla.hito2.dto.pedido;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PedidoAltaDto {

    private Long idUnidadDeVenta;
    private String nombreUnidadDeVenta;
    private List<PlatoPedidoDto> platos;
}

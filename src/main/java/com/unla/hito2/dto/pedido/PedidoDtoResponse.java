package com.unla.hito2.dto.pedido;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;



import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter@AllArgsConstructor @NoArgsConstructor 
public class PedidoDtoResponse {

    
    private Long id;
    private LocalDateTime fechaHora;
    private Long idUnidadDeVenta;
    private  List<DetallePedidoDtoResponse> detalles=new ArrayList<>();
    private BigDecimal total;
}

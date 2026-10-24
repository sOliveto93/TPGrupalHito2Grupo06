package com.unla.hito2.dto;


import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @AllArgsConstructor @NoArgsConstructor 
public class ReporteVentaDto {

    private FestivalDto festival;
    private BigDecimal recaudacionTotal;

}

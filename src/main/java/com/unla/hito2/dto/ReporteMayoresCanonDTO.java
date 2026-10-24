package com.unla.hito2.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @AllArgsConstructor @NoArgsConstructor 
public class ReporteMayoresCanonDTO {

    private String nombreComercial;
      private String codigo;
      private String tipoDeUnidad; 
      private BigDecimal canon;
}

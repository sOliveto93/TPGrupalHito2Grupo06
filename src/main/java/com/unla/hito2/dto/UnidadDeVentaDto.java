package com.unla.hito2.dto;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.unla.hito2.entity.CierreDeCaja;
import com.unla.hito2.entity.Festival;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.Plato;
import com.unla.hito2.entity.Staff;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor 
@NoArgsConstructor 
@Getter 
@Setter 
public class UnidadDeVentaDto {

    private Long id;
    private String nombreComercial;
    private String codigo;
    private double superficie;
    
    private Staff responsable;

    private Set<Staff> empleados=new HashSet<>();

    private List<CierreDeCaja> cierresDeCaja=new ArrayList<>();

    private Set<Plato> platos=new HashSet<>();

    private Set<Pedido> pedidos= new HashSet<>();

    private FestivalDto festival;
}

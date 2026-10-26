package com.unla.hito2.entity;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor 
@Entity 
@Table (name = "unidad_de_venta")
@Inheritance (strategy = InheritanceType.JOINED)
public class UnidadDeVenta {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    private String nombreComercial;
    private String codigo;
    private double superficie;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "festival_id", nullable = false)
    private Festival festival;
    
  
    @ManyToOne (fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "responsable_id", nullable = false)
    private Staff responsable;

    @OneToMany(mappedBy = "unidadDeVenta")
    private Set<Staff> empleados=new HashSet<>();

    @OneToMany(mappedBy = "unidadDeVenta")
    private List<CierreDeCaja> cierresDeCaja=new ArrayList<>();

    @OneToMany(mappedBy = "unidadDeVenta")
    private Set<Plato> platos=new HashSet<>();

    @OneToMany(mappedBy = "unidadDeVenta")
    private Set<Pedido> pedidos= new HashSet<>();

}

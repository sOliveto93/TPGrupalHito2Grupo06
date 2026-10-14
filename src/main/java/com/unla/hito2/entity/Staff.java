package com.unla.hito2.entity;

import java.time.LocalDate;


import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter 
@Setter 
@NoArgsConstructor 
@AllArgsConstructor 
@Entity 
@Table (name = "staff")
@Inheritance (strategy = InheritanceType.JOINED)
public class Staff {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String apelido;
    private String dni;
    private LocalDate fechaNac;
    private LocalDate fechaIngreso;
    private LocalDate fechaBaja;
    private boolean activo;
    
    @OneToOne (fetch = FetchType.LAZY,optional = false)
    @JoinColumn (name = "usuario_id",nullable = false,unique = true)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unidad_venta_id")
    private UnidadDeVenta unidadDeVenta;
    
}

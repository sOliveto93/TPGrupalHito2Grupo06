
package com.unla.hito2.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.unla.hito2.entity.HistorialUnidadVenta;
import com.unla.hito2.entity.Staff;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.repository.HistorialUnidadVentaRepository;

@Service
public class HistorialUnidadVentaService {

    private final HistorialUnidadVentaRepository historialRepository;

    public HistorialUnidadVentaService(
            HistorialUnidadVentaRepository historialRepository) {
        this.historialRepository = historialRepository;
    }

    @Transactional
    public HistorialUnidadVenta registrarAsignacion(Staff staff, UnidadDeVenta unidadDeVenta) {

        HistorialUnidadVenta historial = new HistorialUnidadVenta();
        historial.setStaff(staff);
        historial.setUnidadDeVenta(unidadDeVenta);

        staff.getHistorialUnidades().add(historial);
        
        return historialRepository.save(historial);
    }

    @Transactional(readOnly = true)
    public List<HistorialUnidadVenta> buscarPorStaff(Long staffId) {
        return historialRepository.findByStaffId(staffId);
    }
}

package com.unla.hito2.service;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.entity.Festival;
import com.unla.hito2.repository.FestivalRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class FestivalService {

    private final FestivalRepository festivalRepository;

    public FestivalService(FestivalRepository festivalRepository) {
        this.festivalRepository = festivalRepository;
    }


    public List<FestivalDto> traerTodos() {
        List<Festival>lista=festivalRepository.findAll();
        List<FestivalDto>dtos=new ArrayList<>();
        if(!lista.isEmpty()){
            for(Festival f:lista){
                FestivalDto dto=new FestivalDto();
                dto.setId(f.getId());
                dto.setNombre(f.getNombre());
                dto.setTemporada(f.getTemporada());
                dto.setFechaInicio(f.getFechaInicio());
                dto.setFechaFin(f.getFechaFin());
                dtos.add(dto);
            }
            

        }
        return dtos;
    }
}
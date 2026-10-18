package com.unla.hito2.service;

import com.unla.hito2.entity.Festival;
import com.unla.hito2.repository.FestivalRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class FestivalService {

    private final FestivalRepository festivalRepository;

    public FestivalService(FestivalRepository festivalRepository) {
        this.festivalRepository = festivalRepository;
    }

    @Transactional(readOnly = true)
    public List<Festival> traerTodos() {
        return festivalRepository.findAll();
    }
}
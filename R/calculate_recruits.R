calculate_recruits <- function(pop,fish,num_patches,patch_habitat = 1, phase = 'burn'){

  if (patch_habitat == 1) {

    patch_habitat <- rep(patch_habitat, num_patches)

    prop_patch_habitat <- ((patch_habitat / sum(patch_habitat)))

  }

  r0s <- rep(fish$r0, num_patches) * ((patch_habitat / sum(patch_habitat)))

  ssb0s <- rep(fish$ssb0, num_patches) * ((patch_habitat / sum(patch_habitat)))


  if (phase == 'burn'){

    recruits <- rep(fish$r0, num_patches) * ((patch_habitat / sum(patch_habitat)))

  } else {

    if (fish$density_dependence_form == 1){
      #Density dependence occurs independently in each spatial area

      recruits <- pop %>%
        group_by(patch) %>%
        summarise(ssb = sum(ssb)) %>%
        mutate(recruits = (0.8 * r0s * fish$steepness * ssb) / (0.2 * ssb0s * (1 - fish$steepness) +
                                                                  (fish$steepness - 0.2) * ssb) ) %>% {
                                                                    .$recruits
                                                                  }

    }
    if (fish$density_dependence_form == 2){
      # Density dependence occurs at the regional level and recruits are distributed evenly across areas, or larvae are distributed evenly followed by local

      recruits <- pop %>%
        summarise(ssb = sum(ssb)) %>%
        mutate(recruits = (0.8 * fish$r0 * fish$steepness * ssb) / (0.2 * fish$ssb0 * (1 - fish$steepness) +
                                                                  (fish$steepness - 0.2) * ssb) ) %>% {
                                                                    .$recruits * prop_patch_habitat
                                                                  }
    }
    if (fish$density_dependence_form == 3){
      #Density dependence occurs within spatial areas, but recruits are spread evenly across areas

      recruits <- pop %>%
        group_by(patch) %>%
        summarise(ssb = sum(ssb)) %>%
        mutate(recruits = (0.8 * r0s * fish$steepness * ssb) / (0.2 * ssb0s * (1 - fish$steepness) +
                                                                  (fish$steepness - 0.2) * ssb) ) %>% {
                                                                    sum(.$recruits) * prop_patch_habitat
                                                                  }



    }
    if (fish$density_dependence_form == 4){
      #The pooled larvae from all areas are distributed evenly to each area, and then density dependence occurs based on the number of spawners in each area


      recruits <- pop %>%
        group_by(patch) %>%
        summarise(ssb = sum(ssb)) %>%
        mutate(recruits = ((0.8 * r0s * fish$steepness) / (0.2 * ssb0s * (1 - fish$steepness) +
                                                                  (fish$steepness - 0.2) * ssb)) * mean(ssb)) %>% {
                                                                    .$recruits
                                                                  }

    }
    if (fish$density_dependence_form == 5){


    }


  }

  return(recruits)

}
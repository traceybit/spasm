#' \code{catch_target} finds the right effort to produce a target level of catch
#'
#' @param total_effort
#' @param target_catch
#' @param pop
#' @param num_patches
#' @param mpa
#' @param fleet
#'
#' @return a total effort to be distributed by the fleet model
#' @export
#'
catch_target <- function(total_effort,
                         target_catch,
                         pop,
                         num_patches,
                         mpa,
                         fleet,
                         use = 'opt',
                         fish) {

  efforts <- distribute_fleet(
    pop = pop,
    effort = total_effort,
    fleet = fleet,
    num_patches = num_patches,
    mpa = mpa
  )

  fs <- efforts * fleet$q

  pop$f <- fs

  caught <- pop %>%
    group_by(patch) %>%
    mutate(biomass_caught = grow_and_die(
      numbers = numbers,
      f = f,
      mpa = mpa,
      fish = fish,
      fleet = fleet
    )$caught * weight_at_age) %>%
    ungroup() %>%
    {
      .$biomass_caught
    }

  alive <- pop %>%
    group_by(patch) %>%
    mutate(survivors = grow_and_die(
      numbers = numbers,
      f = f,
      mpa = mpa,
      fish = fish,
      fleet = fleet
    )$survivors) %>%
    ungroup() %>%
    {
      .$survivors
    }


  catch <- caught %>% sum()

  ss <- (catch - target_catch) ^ 2

  if (use == 'opt') {
    out <- ss
  } else {
    out <- alive

  }

  return(out)


}
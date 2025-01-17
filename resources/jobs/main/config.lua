--[[
  Config entry point for all jobs

  @author Astymeus
  @date 2019-07-28
  @version 1.0
--]]

JobsConfig = {}

JobsConfig.jobs = {}
JobsConfig.isMenuOpen = false
JobsConfig.inService = false
JobsConfig.jobsNotification = {
  title = "Boulot",
  logo = "https://img.icons8.com/nolan/96/000000/briefcase.png"
}
JobsConfig.SalaryInterval = 24 * 60 * 1000 -- 24min
JobsConfig.PrimeConnection = 50

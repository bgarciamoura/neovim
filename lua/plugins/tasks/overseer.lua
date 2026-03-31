return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen" },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 10,
      max_height = 25,
      default_detail = 1,
    },
    templates = { "builtin" },
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        "on_complete_dispose",
      },
    },
    task_icons = {
      CANCELED = " ",
      FAILURE = " ",
      RUNNING = " ",
      SUCCESS = " ",
    },
  },
}

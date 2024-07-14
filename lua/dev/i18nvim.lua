-- experiment with i18n in neovim

local I18Nvim = {}
local H = {}
H.CONFIG_FILE = '.i18nvim.json'
function I18Nvim.config_file_path(buf)
  local current_buffer_path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf or 0))
  local configfile = vim.fs.find(H.CONFIG_FILE, {
    path = current_buffer_path,
    upward = true,
  })[1]
  return configfile
end

function I18Nvim.load_config(buf)
  local configfile = I18Nvim.config_file_path(buf)
  if not configfile then
    return {}
  end
  local config = vim.fn.json_decode(vim.fn.readfile(configfile))
  return config
end

return I18Nvim

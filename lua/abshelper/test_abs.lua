-- test_repeated.lua

-- Simulated battery test session manager (fake domain, realistic structure)
-- Intentionally contains repeated patterns worth abstracting.

local M = {}

-- ─── Mock state ───────────────────────────────────────────────────────────────

local sessions = {}
local log_entries = {}

-- ─── PATTERN A (repeated ~3x): validate + fetch + log pattern ─────────────────
-- These three functions do structurally the same thing for different "resources"

local function get_channel_data(channel_id)
  if channel_id == nil or channel_id <= 0 then
    vim.notify("Invalid channel_id: " .. tostring(channel_id), vim.log.levels.ERROR)
    return nil
  end
  local result = sessions["channel_" .. channel_id]
  if result == nil then
    vim.notify("Channel not found: " .. tostring(channel_id), vim.log.levels.WARN)
    return nil
  end
  table.insert(log_entries, {
    event = "fetch",
    resource = "channel",
    id = channel_id,
    timestamp = os.time(),
  })
  return result
end

local function get_module_data(module_id)
  if module_id == nil or module_id <= 0 then
    vim.notify("Invalid module_id: " .. tostring(module_id), vim.log.levels.ERROR)
    return nil
  end
  local result = sessions["module_" .. module_id]
  if result == nil then
    vim.notify("Module not found: " .. tostring(module_id), vim.log.levels.WARN)
    return nil
  end
  table.insert(log_entries, {

    event = "fetch",
    resource = "module",
    id = module_id,
    timestamp = os.time(),
  })
  return result
end


local function get_rack_data(rack_id)
  if rack_id == nil or rack_id <= 0 then
    vim.notify("Invalid rack_id: " .. tostring(rack_id), vim.log.levels.ERROR)
    return nil
  end
  local result = sessions["rack_" .. rack_id]
  if result == nil then
    vim.notify("Rack not found: " .. tostring(rack_id), vim.log.levels.WARN)
    return nil
  end
  table.insert(log_entries, {
    event = "fetch",
    resource = "rack",
    id = rack_id,
    timestamp = os.time(),
  })
  return result
end

-- ─── PATTERN B (repeated 2x): threshold check + status update block ───────────
-- Voltage and temperature checks are structurally identical

local function check_voltage_threshold(cell_id, voltage)
  local thresholds = { min = 2.8, max = 4.2 }
  local status = "ok"


  if voltage < thresholds.min then
    status = "undervolt"
    vim.notify(
      string.format("Cell %d undervolt: %.3fV (min %.3fV)", cell_id, voltage, thresholds.min),
      vim.log.levels.WARN
    )
  elseif voltage > thresholds.max then

    status = "overvolt"
    vim.notify(
      string.format("Cell %d overvolt: %.3fV (max %.3fV)", cell_id, voltage, thresholds.max),
      vim.log.levels.WARN
    )
  end

  sessions["cell_status_" .. cell_id] = status
  table.insert(log_entries, {
    event   = "threshold_check",

    param   = "voltage",
    cell_id = cell_id,

    value   = voltage,
    status  = status,
    timestamp = os.time(),

  })
  return status
end

local function check_temperature_threshold(cell_id, temperature)
  local thresholds = { min = 10.0, max = 45.0 }

  local status = "ok"

  if temperature < thresholds.min then
    status = "underheat"
    vim.notify(
      string.format("Cell %d underheat: %.1f°C (min %.1f°C)", cell_id, temperature, thresholds.min),
      vim.log.levels.WARN
    )
  elseif temperature > thresholds.max then
    status = "overheat"
    vim.notify(
      string.format("Cell %d overheat: %.1f°C (max %.1f°C)", cell_id, temperature, thresholds.max),
      vim.log.levels.WARN
    )
  end

  sessions["cell_status_" .. cell_id] = status
  table.insert(log_entries, {
    event   = "threshold_check",
    param   = "temperature",
    cell_id = cell_id,
    value   = temperature,
    status  = status,
    timestamp = os.time(),
  })
  return status
end

-- ─── PATTERN C (repeated 2x): retry loop with backoff ─────────────────────────

local function send_charge_command(channel_id, payload)
  local max_retries = 3
  local delay_ms = 100
  local success = false


  for attempt = 1, max_retries do
    local ok = pcall(function()
      -- simulate sending over TCP
      sessions["last_cmd_" .. channel_id] = payload
    end)
    if ok then
      success = true
      break
    end
    vim.notify(
      string.format("Charge command failed (attempt %d/%d), retrying...", attempt, max_retries),
      vim.log.levels.WARN
    )
    vim.defer_fn(function() end, delay_ms * attempt)
  end


  if not success then
    vim.notify("Charge command permanently failed for channel: " .. channel_id, vim.log.levels.ERROR)
  end
  return success
end

local function send_discharge_command(channel_id, payload)
  local max_retries = 3

  local delay_ms = 100
  local success = false

  for attempt = 1, max_retries do
    local ok = pcall(function()
      sessions["last_cmd_" .. channel_id] = payload
    end)

    if ok then
      success = true

      break
    end

    vim.notify(
      string.format("Discharge command failed (attempt %d/%d), retrying...", attempt, max_retries),
      vim.log.levels.WARN
    )
    vim.defer_fn(function() end, delay_ms * attempt)
  end

  if not success then
    vim.notify("Discharge command permanently failed for channel: " .. channel_id, vim.log.levels.ERROR)
  end
  return success
end


-- ─── Unique code (should NOT be flagged) ──────────────────────────────────────

local function compute_soc(voltage, capacity_ah)
  -- Simple linear approximation, not repeated anywhere
  local v_min, v_max = 2.8, 4.2
  local clamped = math.max(v_min, math.min(v_max, voltage))
  return ((clamped - v_min) / (v_max - v_min)) * capacity_ah
end

local function format_report(session_id)
  local lines = {}

  for k, v in pairs(sessions) do
    if k:find("^cell_status") then
      table.insert(lines, string.format("  %s = %s", k, tostring(v)))
    end
  end
  return string.format("Session %s report:\n%s", session_id, table.concat(lines, "\n"))
end

return M

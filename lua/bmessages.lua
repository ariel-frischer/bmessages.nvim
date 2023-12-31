-- Author: Ariel Frischer
-- email: arielfrischer@gmail.com

local M = {}
M.current_split_type = nil

local function with_defaults(options)
	options = options or {}

	local defaults = {
		timer_interval = 1000,
		split_type = "vsplit",
		buffer_name = "bmessages_buffer",
		split_size_vsplit = nil,
		split_size_split = nil,
		autoscroll = true,
		use_timer = true,
		disable_create_user_commands = false,
	}

	for key, default_value in pairs(defaults) do
		if options[key] == nil then
			options[key] = default_value
		end
	end

	return options
end

local function is_bmessages_buffer_open(options)
	local bufnr = vim.fn.bufnr(options.buffer_name)
	return vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr)
end

local function update_messages_buffer(options)
	return function()
		local new_messages = vim.api.nvim_cmd({ cmd = "messages" }, { output = true })
		if new_messages == "" then
			return
		end

		local bufnr = vim.fn.bufnr(options.buffer_name)
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		local lines = vim.split(new_messages, "\n")

		vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		if options.use_timer then
			vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
		end

		if options.autoscroll and vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) ~= options.buffer_name then
			local winnr = vim.fn.bufwinnr(bufnr)
			if winnr ~= -1 then
				local winid = vim.fn.win_getid(winnr)
				vim.api.nvim_win_set_cursor(winid, { #lines, 0 })
			end
		end
	end
end

local function merge_options(defaults, new_options)
	if not new_options then
		return defaults
	end
	return vim.tbl_deep_extend("force", {}, defaults, new_options)
end

local function create_raw_buffer(options)
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_name(bufnr, options.buffer_name)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
	vim.api.nvim_set_option_value("bl", false, { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
end

local function run_vim_cmd(options)
	local cmd = options.split_type

	if cmd == "vsplit" and options.split_size_vsplit ~= nil then
		cmd = cmd .. " | vertical resize " .. options.split_size_vsplit
	elseif cmd == "split" and options.split_size_split ~= nil then
		cmd = cmd .. " | resize " .. options.split_size_split
	end

	vim.cmd(cmd .. " | enew")
end

local function create_messages_buffer(new_options)
	local options = merge_options(M.options, new_options)

	if is_bmessages_buffer_open(options) then
		if M.current_split_type == options.split_type then
			vim.api.nvim_buf_delete(vim.fn.bufnr(options.buffer_name), { force = true })
			return nil
		else
			vim.api.nvim_buf_delete(vim.fn.bufnr(options.buffer_name), { force = true })
		end
	end

	M.current_split_type = options.split_type

	run_vim_cmd(options)
	create_raw_buffer(options)

	local update_fn = update_messages_buffer(options)
	update_fn()

	local timer = vim.loop.new_timer()
	local function close_timer()
		timer:stop()
		timer:close()
		timer = nil
	end

	if not options.use_timer then
		if timer then
			close_timer()
		end
		return nil
	end

	if options.use_timer and timer then
		timer:start(options.timer_interval, options.timer_interval, vim.schedule_wrap(update_fn))
	end

	vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
		pattern = options.buffer_name,
		callback = function()
			if timer then
				close_timer()
			end
		end,
	})
end

-- This function is supposed to be called explicitly by users to configure this plugin
function M.setup(options)
	M.options = with_defaults(options)

	if M.options.disable_create_user_commands then
		return
	end

	vim.api.nvim_create_user_command("Bmessages", function()
		create_messages_buffer(M.options)
	end, {})

	vim.api.nvim_create_user_command("Bmessagesvs", function()
		create_messages_buffer(vim.tbl_deep_extend("force", {}, M.options, { split_type = "vsplit" }))
	end, {})

	vim.api.nvim_create_user_command("Bmessagessp", function()
		create_messages_buffer(vim.tbl_deep_extend("force", {}, M.options, { split_type = "split" }))
	end, {})

	vim.api.nvim_create_user_command("BmessagesEdit", function()
		create_messages_buffer(vim.tbl_deep_extend("force", {}, M.options, { use_timer = false }))
	end, {})
end

function M.is_configured()
	return M.options ~= nil
end

-- Users can call this function directly in lua with: require("bmesssages").toggle()
M.toggle = create_messages_buffer

M.options = nil
return M

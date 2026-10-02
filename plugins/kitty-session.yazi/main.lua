--- @since 25.4.8
-- Preview *.kitty-session via `bat` with bash highlighting (closest match to
-- kitty session syntax: comments with `#`, `cd`, quoted strings, etc.).

local M = {}

function M:peek(job)
	local limit = job.area.h
	local output, _ = Command("bat"):arg({
		"--paging=never",
		"--color=always",
		"--style=plain",
		"--language=bash",
		"--line-range",
		string.format("%d:%d", job.skip + 1, job.skip + limit),
		tostring(job.file.url),
	}):stdout(Command.PIPED):output()

	if output then
		ya.preview_widget(job, ui.Text.parse(output.stdout):area(job.area))
	end
end

function M:seek(job)
	local h = cx.active.preview.area.h
	if h and job.units ~= 0 then
		ya.emit("peek", {
			math.max(0, cx.active.preview.skip + job.units * h),
			only_if = tostring(job.file.url),
		})
	end
end

return M

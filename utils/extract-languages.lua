local ls = io.popen("ls -1")

if ls == nil then
  print("Could not list files in current directory.")
  os.exit()
end

local stdout = ls:read("*a")

ls:close()

local languages = "";

for lang in stdout:gmatch("language_([%w_]+)%.lua") do
  languages = languages .. '"' .. lang .. '" '
end

print(languages)

-- Copy paste the output into supportedLanguages


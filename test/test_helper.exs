ExUnit.start()
files = Path.wildcard("./test/support/*.ex")

Enum.each(files, fn file ->
  Code.require_file(file)
end)

#!/usr/bin/lua

yaml = require("yaml")

url_prefix="http://wiki.alpinelinux.org/cgi-bin/dl.cgi"
t = { list={} }

for i = 1,#arg do
	local f = assert(io.open(arg[i]))

	for _,v in pairs(yaml.load(f:read("*a"))) do
		local y,m,d = v.date:match("(%d+)-(%d+)-(%d+)")
		v.datestr = os.date("%b %d, %Y", os.time{year=y, month=m, day=d})
		v.iso_url = ("%s/%s/releases/%s/%s"):format(url_prefix,
			v.branch, v.arch, v.iso)
		v.sha256_url = ("%s.sha256"):format(v.iso_url)
		v.sha1_url = ("%s.sha256"):format(v.iso_url)
		v.size_mb=math.floor(v.size/(1024*1024))


		local flavor = t[v.flavor]
		if flavor == nil then
			flavor = { archs = {}}
		end
		flavor[v.arch] = v
		table.insert(flavor.archs, v)
		t[v.flavor] = flavor

		table.insert(t.list, v)
	end
end

-- default release
t.default = t.alpine.x86_64

io.write(yaml.dump(t))

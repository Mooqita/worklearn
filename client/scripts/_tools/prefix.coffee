pfx = ["webkit", "moz", "ms", "o", ""];
@RunPrefixMethod = (obj, method) ->
	p = m = t = 0
	while (p < pfx.length && !obj[m])
		m = method
		if (pfx[p] == "")
			m = m.substr(0,1).toLowerCase() + m.substr(1)

		m = pfx[p] + m;
		t = typeof obj[m];
		if (t != "undefined")
			pfx = [pfx[p]];
			return if t == "function" then obj[m]() else obj[m]
		p=p+1
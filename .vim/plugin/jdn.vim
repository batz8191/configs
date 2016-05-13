
function! jdn#jdn(year, month, day)
	let a = (14 - a:month) / 12
	let y = a:year + 4800 - a
	let m = a:month + 12 * a - 3
	return a:day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y/400 - 32045
endfunction

function! jdn#month_length(year, month)
	if a:month > 12 || a:month < 1
		return -1
	endif
	if a:month == 2 && jdn#is_leap_year(year)
		return 29
	else
		let lst = [31, 28, 31,30,31,30,31,31,30,31,30,31]
		return lst[a:month]
	endif
endfunction

function! jdn#is_leap_year(year)
	return a:year % 4 == 0 && (a:year % 100 != 0 || a:year % 400 == 0)
endfunction

function! jdn#now()
	let now = split(strftime("%Y-%m-%d"), '-')
	call map(now, 'str2nr(v:val)')
	return jdn#jdn(now[0], now[1], now[2])
endfunction

" 0->6 0 is SUN
function! jdn#day_of_week(jdn)
	return (a:jdn + 1) % 7
endfunction

function! jdn#add_days(jdn, days)
	return jdn + a:days
endfunction

function! jdn#add_month(jdn, month)
	" TODO convert to y,m,d and add a:month adjusting y and m and d as needed
	let [y,m,d] = jdn#to_gregorian(a:jdn)
	let m = m + a:month % 12
	let y = y + a:month / 12
	if m > 12
		let m = 1
		let y = y + 1
	endif
	if d > jdn#month_length(y, m)
		let d = jdn#month_length(y, m)
	endif
	return jdn#jdn(y, m, d)
endfunction

function! jdn#add_year(jdn, year)
	let [y,m,d] = jdn#to_gregorian(a:jdn)
	let y = y + a:year
	return jdn#jdn(y, m, d)
endfunction

function! jdn#to_gregorian(jdn)
	let j = a:jdn + 32044
	let g = j / 146097
	let dg = j % 146097
	let c = (dg / 36524 + 1) * 3 / 4
	let dc = dg - c * 36524
	let b = dc / 1461
	let db = dc % 1461
	let a = (db / 365 + 1) * 3 / 4
	let da = db - a * 365
	let y = g * 400 + c * 100 + b * 4 + a " note: this is the integer number of full years elapsed since March 1, 4801 BC at 00:00 UTC
	let m = (da * 5 + 308) / 153 - 2 " note: this is the integer number of full months elapsed since the last March 1 at 00:00 UTC
	let d = da - (m + 4) * 153 / 5 + 122 " note: this is the number of days elapsed since day 1 of the month at 00:00 UTC, including fractions of one day
	let Y = y - 4800 + (m + 2) / 12
	let M = (m + 2) % 12 + 1
	let D = d + 1
	return [Y, M, D]
endfunction

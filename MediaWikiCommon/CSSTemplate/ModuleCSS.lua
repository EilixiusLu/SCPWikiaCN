local p = {}
local allowedNS = {
	[2] = true, -- User:
	[8] = true, -- MediaWiki:
	[10] = true -- Template:
}

function p.import_css(frame)
	local content = frame:getParent().args.content or frame.args.content
	if content ~= nil then
		return tostring(mw.html.create("span")
			:addClass("import-css")
			:attr("data-css", content)
			:attr("data-css-hash", mw.hash.hashValue("sha256", content)))
	end
	
	local title = frame:getParent().args[1] or frame.args[1]
	local titleObj = mw.title.new(title or "")
	local errorMsg
	
	if title == nil then errorMsg = "错误：没有向<code>{{[[T:CSS|CSS]]}}</code>模板提供参数。"
	elseif titleObj == nil then errorMsg = "错误：提供给<code>{{[[T:CSS|CSS]]}}</code>模板的参数“" .. frame:extensionTag("nowiki", title) .. "”不是一个有效的页面名。"
	elseif not titleObj.exists then errorMsg = "错误：提供给<code>{{[[T:CSS|CSS]]}}</code>模板的参数“[[" .. title .. "]]”对应的页面不存在。"
	elseif not allowedNS[titleObj.namespace] then errorMsg = "错误：提供给<code>{{[[T:CSS|CSS]]}}</code>模板的页面名“[[" .. title .. "]]”不属于User、MediaWiki或Template中的任何一个命名空间。"
	elseif titleObj.contentModel ~= "css" then errorMsg = "错误：提供给<code>{{[[T:CSS|CSS]]}}</code>模板的参数“[[" .. title .. "]]”对应页面的[[mw:Content handlers/zh|内容模型]]不是CSS。" end
	
	if errorMsg ~= nil then return
		tostring(mw.html.create("strong"):addClass("error"):wikitext(errorMsg)) ..
		"[[分类:引入CSS出错的页面]]"
	else
		content = titleObj:getContent()
		return tostring(mw.html.create("span")
			:addClass("import-css")
			:attr("data-css", content)
			:attr("data-css-hash", mw.hash.hashValue("sha256", content)))
	end
end

return p

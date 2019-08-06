Settings:setCompareDimension(true, 540)
Settings:setScriptDimension(true, 540)

battleStartRegion = Region(0, 830, 540, 130)
battleResultRegion = Region(180,280, 200, 300)

function battle()	

	alert('battle')
	if not rematch() then
		return false
	end	
	
	snapshot(true)
	while not battleResultRegion:exists(Pattern("battle/victory.png"):similar(0.8)) 
	and not battleResultRegion:exists(Pattern("battle/defeat.png"):similar(0.8)) do	
		useSpell()	
		wait(2)		
		snapshot(true)
	end	
	
	return true
end

function rematch()	

	alert('rematch')

	snapshot(true)	
	if not battleStartRegion:existsClick(Pattern("battle/rematch.png"),30) then 
		return false
	end
	
	snapshot(true)	
	while not exists(Pattern("battle/cancel.png"):similar(0.8)) do
		alert('cancel not exist')
		wait(1)
		snapshot(true)
	end
	
	return true;
end

function useSpell()
	alert('casting spell')
	existsClick(Pattern("battle/fulmination.png"), 5)
end

function alert(message)
	--toast(message)
end

iterationsAllowed = 5000
iterationCount = 1

while iterationCount < iterationsAllowed do
	
	alert('Iteration'..iterationCount)
	battle()	
	iterationCount = iterationCount + 1
end 



print('Completed '..iterationCount..' iterations');
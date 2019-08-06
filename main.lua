Settings:setCompareDimension(true, 540)
Settings:setScriptDimension(true, 540)

clickableBattleRegion = Region(0, 200, 540, 540)
battleStartRegion = Region(0, 830, 540, 130)
battleResultRegion = Region(180,280, 200, 300)

iterationsAllowed = 999500099
iterationCount = 1
fightsWithoutHeal = 0
hourCounter = 0
startTime = os.time()

function battleFirstMonsterFound(tier, monsterImages)

	alert('snapshotting')
	snapshot(true)

	for key, value in pairs(monsterImages) 
	do	
		alert('monsters/'..tier..'/'..value)
		if clickMonster('monsters/'..tier..'/'..value) then
			
			usePreviousSnap(false)
			fightUntillWinOrLose()
			fightsWithoutHeal = fightsWithoutHeal + 1

			if fightsWithoutHeal > 4 then
				heal()
				fightsWithoutHeal = 0
			end 
		
			sleep(1)
			snapshot(true)
		end
	end
	
	usePreviousSnap(false)
	
	if amIDead() then	
		heal()
	end
end

function clickMonster(monster)
	return clickableBattleRegion:existsClick(Pattern(monster):similar(0.7))
end

function fightUntillWinOrLose()	

	if not clickBattle() then
		return false
	end	
	
	alert('clickBattleComplete')
	snapshot(true)
	spellCount = 0
	while not battleResultRegion:exists(Pattern("battle/victory.png"):similar(0.8)) 
	and not battleResultRegion:exists(Pattern("battle/defeat.png"):similar(0.8)) do	
		useSpell()	
		spellCount = spellCount + 1
		wait(2)		
		snapshot(true)
		clearScreen()
		
		if spellCount > 10 then
			usePreviousSnap(false)
			flee()
			wait(2)
			heal()
			return false
		end
	end	
	
	if exists(Pattern("battle/defeat.png"):similar(0.8)) then
		click(Location(200,890)) -- click continue		
		wait(1)
		usePreviousSnap(false)
		heal()
	else
		click(Location(200,890))
		wait(1)
	end
	
	usePreviousSnap(false)
end

function clickBattle()	

	if not battleStartRegion:existsClick(Pattern("battle/start_battle.png"),30) then 
		return false
	end
	
	snapshot(true)
	while not exists(Pattern("battle/wait.png"):similar(0.8)) 
	and not exists(Pattern("battle/cancel.png"):similar(0.8)) do
		alert('waiting for click battle result')
		wait(1)
		snapshot(true)
		clearScreen()
	end
	
	if exists(Pattern("battle/wait.png"):similar(0.8)) then
		usePreviousSnap(false)
		existsClick(Pattern("battle/leave.png"):similar(0.8), 30)
		wait(1)
		return false;
	end
	
	usePreviousSnap(false)
	
	return true;
end

function useSpell()
	alert('casting spell')
	existsClick(Pattern("battle/fulmination.png"):similar(0.8), 5)
end

function flee()
	delayExistsClick(Pattern("actions/cancel.png"):similar(0.8), 30, 1)	
	if exists(Pattern("actions/flee.png"):similar(0.8), 30) then
		longClick(Pattern("actions/flee.png"):similar(0.8), 5)
	end
end

function heal()
	delayExistsClick(Pattern("actions/items.png"):similar(0.8), 30, 1)
	delayExistsClick(Pattern("actions/auto_heal.png"):similar(0.8), 30, 1)
	delayExistsClick(Pattern("actions/close.png"):similar(0.8), 30, 1)
	wait(1)
	fightsWithoutHeal = 0
end

function buffUp()
	delayExistsClick(Pattern("actions/items.png"):similar(0.9), 30, 1)
	delayExistsClick(Pattern("actions/lucky_coin_icon.png"):similar(0.9), 30, 1)
	delayExistsClick(Pattern("actions/lucky_silver_coin_icon.png"):similar(0.9), 30, 1)
	delayExistsClick(Pattern("actions/torch_icon.png"):similar(0.9), 30, 1)
	delayExistsClick(Pattern("actions/exp_potion_icon.png"):similar(0.9), 30, 1)
	--delayExistsClick(Pattern("actions/dowsing_rod_icon.png"):similar(0.9), 30, 1)
	delayExistsClick(Pattern("actions/close.png"):similar(0.9), 30, 1)
	wait(1) -- alow close to clear
end

function clickWar()
	click(Pattern("monsters/actions/war.png"):similar(0.8))
end 

function amIDead()
	return exists(Pattern('battle/dead.png'):similar(0.8))
end

function alert(message)
	--toast(message)
end

function scandir(directory)

	local listFile = scriptPath() .. "__list"
	local command = "ls " .. directory .. " > " .. listFile
	
	os.execute(command)

	local lines = {}
	local i = 1
	for line in io.lines(listFile) do
		lines[#lines + 1] = line
	end

	os.execute("rm " .. listFile)
	
	return lines
end

function delayExistsClick(pattern, timeout, delay)
	if exists(pattern, timeout) then
		wait(delay)
		existsClick(pattern, timeout)
	end
end

function clearScreen()
	existsClick(Pattern("actions/continue.png"):similar(0.8), 1)
	existsClick(Pattern("actions/close.png"):similar(0.8), 1)
end

function configureBot()
	dialogInit()
	addTextView("Enemies to Fight")
	newRow()
	addRadioGroup("enemyType", 1)
	addRadioButton("all", 1)
	addRadioButton("high level only", 2)
	newRow()
	addTextView("Buff at start")
	newRow()
	addRadioGroup("buffAtStart", 1)
	addRadioButton("yes", 1)
	addRadioButton("no", 2)
	dialogShowFullScreen("Ornator Settings")
end

function theLoop()
	
	while iterationCount < iterationsAllowed do
		alert('Iteration'..iterationCount)
		
		timePassed = os.time() - startTime
		
		divided = math.floor(timePassed / 3600) 
		
		toast(timePassed)
		toast(divided)		
		
		if divided > hourCounter then
			hourCounter = divided
			buffUp()
		end
		
		battleFirstMonsterFound('t8', t8)
		battleFirstMonsterFound('t7', t7)
		
		if enemyType == 1 then
			battleFirstMonsterFound('t6', t6)
			battleFirstMonsterFound('t5', t5)
			battleFirstMonsterFound('t4', t4)
			battleFirstMonsterFound('t3', t3)
			battleFirstMonsterFound('t2', t2)
			battleFirstMonsterFound('t1', t1)
		end
		
		clearScreen()

		iterationCount = iterationCount + 1
	end
end

t1 = scandir(scriptPath()..'/image/monsters/t1')
t2 = scandir(scriptPath()..'/image/monsters/t2')
t3 = scandir(scriptPath()..'/image/monsters/t3')
t4 = scandir(scriptPath()..'/image/monsters/t4')
t5 = scandir(scriptPath()..'/image/monsters/t5')
t6 = scandir(scriptPath()..'/image/monsters/t6')
t7 = scandir(scriptPath()..'/image/monsters/t7')
t8 = scandir(scriptPath()..'/image/monsters/t8')

configureBot()

if buffAtStart then
	buffUp()
end

theLoop()

print('Completed '..iterationCount..' iterations');
local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()local module={}
module.__index=module

local function floord(num,digits)
return math.floor(num*10^digits)/10^digits
end

local function gettime()
return floord(time(),2)
end

function module:init(settings)
writefile(settings.output,"[LOG INIT] Initialized logger "..gettime())
return setmetatable({settings=settings},module)
end

function module:log(...)
local out="[LOG] "
if self.settings.time then
out=gettime().." - "..out
end
for _,value in pairs({...})do
if type(value)~="string"then
value=dump(value)
end
out=out..value.." "
end
if self.settings.print then
print(out)
end
appendfile(self.settings.output,out.."\n")
end

return module-- local LOG_FILE_OUTPUT = "pubmain.pcd.log"-- local PRINT_LOGS = true-- local LOG_TIME = true-- writefile(LOG_FILE_OUTPUT, "[LOG INIT] Initialized logger " .. gettime())-- local function Log(text)--     local out = "[LOG] " .. text--     if LOG_TIME then--         out = gettime() .. " " .. out--     end--     if PRINT_LOGS then print(out) end--     appendfile(LOG_FILE_OUTPUT, "\n" .. out)-- end
end function __DARKLUA_BUNDLE_MODULES.b()














return function(Title,Text)
game:GetService("StarterGui"):SetCore("SendNotification",{
Title=Title,
Text=Text,
Duration=5,
})
end end function __DARKLUA_BUNDLE_MODULES.c()

return{
States={
TPDestination="Teleportowanie",
SpawningCar="Respienie auta",
EnteringCar="Wchodzenie do auta",
Waiting="Czekam na zadanie",
WaitingRespawn="Czekam aż gracz sie odrodzi",
TPPackage="Teleportowanie po paczki",
GettingPackages="ide po paczki (nwm)",
},
PlaceId=4299508195,
SupportedPlaceVersion={44843},
ScriptVersion="0.4 beta 1.2",
UpdateLog={
"Naprawiono odbieranie paczek",
"Dodano troll tab i jumpscare",
"Naprawiono nieskończone paliwo",
},
}end function __DARKLUA_BUNDLE_MODULES.d()

local Metadata=loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/metadata/main/main.lua"))()
return setmetatable({
discord=Metadata.discord:gsub("https://",""):gsub("\n","")
},{
__index=function(_,k)
return Metadata[k]
end,
})end function __DARKLUA_BUNDLE_MODULES.e()---------------------------------------------------------------------------------! json library--! cryptography library




local a=4294967296
local b=a-1
local function c(d,e)
local f,g=0,1
while d~=0 or e~=0 do
local h,i=d%2,e%2
local j=(h+i)%2
f=f+j*g
d=math.floor(d/2)
e=math.floor(e/2)
g=g*2
end
return f%a
end
local function k(d,e,l,...)
local m
if e then
d=d%a
e=e%a
m=c(d,e)
if l then
m=k(m,l,...)
end
return m
elseif d then
return d%a
else
return 0
end
end
local function n(d,e,l,...)
local m
if e then
d=d%a
e=e%a
m=(d+e-c(d,e))/2
if l then
m=n(m,l,...)
end
return m
elseif d then
return d%a
else
return b
end
end
local function o(p)
return b-p
end
local function q(d,r)
if r<0 then
return lshift(d,-r)
end
return math.floor(d%4294967296/2^r)
end
local function s(p,r)
if r>31 or r<-31 then
return 0
end
return q(p%a,r)
end
local function lshift(d,r)
if r<0 then
return s(d,-r)
end
return d*2^r%4294967296
end
local function t(p,r)
p=p%a
r=r%32
local u=n(p,2^r-1)
return s(p,r)+lshift(u,32-r)
end
local v={
0x428a2f98,
0x71374491,
0xb5c0fbcf,
0xe9b5dba5,
0x3956c25b,
0x59f111f1,
0x923f82a4,
0xab1c5ed5,
0xd807aa98,
0x12835b01,
0x243185be,
0x550c7dc3,
0x72be5d74,
0x80deb1fe,
0x9bdc06a7,
0xc19bf174,
0xe49b69c1,
0xefbe4786,
0x0fc19dc6,
0x240ca1cc,
0x2de92c6f,
0x4a7484aa,
0x5cb0a9dc,
0x76f988da,
0x983e5152,
0xa831c66d,
0xb00327c8,
0xbf597fc7,
0xc6e00bf3,
0xd5a79147,
0x06ca6351,
0x14292967,
0x27b70a85,
0x2e1b2138,
0x4d2c6dfc,
0x53380d13,
0x650a7354,
0x766a0abb,
0x81c2c92e,
0x92722c85,
0xa2bfe8a1,
0xa81a664b,
0xc24b8b70,
0xc76c51a3,
0xd192e819,
0xd6990624,
0xf40e3585,
0x106aa070,
0x19a4c116,
0x1e376c08,
0x2748774c,
0x34b0bcb5,
0x391c0cb3,
0x4ed8aa4a,
0x5b9cca4f,
0x682e6ff3,
0x748f82ee,
0x78a5636f,
0x84c87814,
0x8cc70208,
0x90befffa,
0xa4506ceb,
0xbef9a3f7,
0xc67178f2,
}
local function w(x)
return string.gsub(x,".",function(l)
return string.format("%02x",string.byte(l))
end)
end
local function y(z,A)
local x=""
for B=1,A do
local C=z%256
x=string.char(C)..x
z=(z-C)/256
end
return x
end
local function D(x,B)
local A=0
for B=B,B+3 do
A=A*256+string.byte(x,B)
end
return A
end
local function E(F,G)
local H=64-(G+9)%64
G=y(8*G,8)
F=F.."\128"..string.rep("\0",H)..G
assert(#F%64==0)
return F
end
local function I(J)
J[1]=0x6a09e667
J[2]=0xbb67ae85
J[3]=0x3c6ef372
J[4]=0xa54ff53a
J[5]=0x510e527f
J[6]=0x9b05688c
J[7]=0x1f83d9ab
J[8]=0x5be0cd19
return J
end
local function K(F,B,J)
local L={}
for M=1,16 do
L[M]=D(F,B+(M-1)*4)
end
for M=17,64 do
local N=L[M-15]
local O=k(t(N,7),t(N,18),s(N,3))
N=L[M-2]
L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a
end
local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]
for B=1,64 do
local O=k(t(d,2),t(d,13),t(d,22))
local U=k(n(d,e),n(d,l),n(e,l))
local V=(O+U)%a
local W=k(t(Q,6),t(Q,11),t(Q,25))
local X=k(n(Q,R),n(o(Q),S))
local Y=(T+W+X+v[B]+L[B])%a
T=S
S=R
R=Q
Q=(P+Y)%a
P=l
l=e
e=d
d=(Y+V)%a
end
J[1]=(J[1]+d)%a
J[2]=(J[2]+e)%a
J[3]=(J[3]+l)%a
J[4]=(J[4]+P)%a
J[5]=(J[5]+Q)%a
J[6]=(J[6]+R)%a
J[7]=(J[7]+S)%a
J[8]=(J[8]+T)%a
end
local function Z(F)
F=E(F,#F)
local J=I({})
for B=1,#F,64 do
K(F,B,J)
end
return w(
y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4)
)
end
local e
local l={
["\\"]="\\",
['"']='"',
["\b"]="b",
["\f"]="f",
["\n"]="n",
["\r"]="r",
["\t"]="t",
}
local P={["/"]="/"}
for Q,R in pairs(l)do
P[R]=Q
end
local S=function(T)
return"\\"..(l[T]or string.format("u%04x",T:byte()))
end
local B=function(M)
return"null"
end
local v=function(M,z)
local _={}
z=z or{}
if z[M]then
error("circular reference")
end
z[M]=true
if rawget(M,1)~=nil or next(M)==nil then
local A=0
for Q in pairs(M)do
if type(Q)~="number"then
error("invalid table: mixed or invalid key types")
end
A=A+1
end
if A~=#M then
error("invalid table: sparse array")
end
for a0,R in ipairs(M)do
table.insert(_,e(R,z))
end
z[M]=nil
return"["..table.concat(_,",").."]"
else
for Q,R in pairs(M)do
if type(Q)~="string"then
error("invalid table: mixed or invalid key types")
end
table.insert(_,e(Q,z)..":"..e(R,z))
end
z[M]=nil
return"{"..table.concat(_,",").."}"
end
end
local g=function(M)
return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'
end
local a1=function(M)
if M~=M or M<=-math.huge or M>=math.huge then
error("unexpected number value '"..tostring(M).."'")
end
return string.format("%.14g",M)
end
local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}
e=function(M,z)
local x=type(M)
local a2=j[x]
if a2 then
return a2(M,z)
end
error("unexpected type '"..x.."'")
end
local a3=function(M)
return e(M)
end
local a4
local N=function(...)
local _={}
for a0=1,select("#",...)do
_[select(a0,...)]=true
end
return _
end
local L=N(" ","\t","\r","\n")
local p=N(" ","\t","\r","\n","]","}",",")
local a5=N("\\","/",'"',"b","f","n","r","t","u")
local m=N("true","false","null")
local a6={["true"]=true,["false"]=false,["null"]=nil}
local a7=function(a8,a9,aa,ab)
for a0=a9,#a8 do
if aa[a8:sub(a0,a0)]~=ab then
return a0
end
end
return#a8+1
end
local ac=function(a8,a9,J)
local ad=1
local ae=1
for a0=1,a9-1 do
ae=ae+1
if a8:sub(a0,a0)=="\n"then
ad=ad+1
ae=1
end
end
error(string.format("%s at line %d col %d",J,ad,ae))
end
local af=function(A)
local a2=math.floor
if A<=0x7f then
return string.char(A)
elseif A<=0x7ff then
return string.char(a2(A/64)+192,A%64+128)
elseif A<=0xffff then
return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)
elseif A<=0x10ffff then
return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)
end
error(string.format("invalid unicode codepoint '%x'",A))
end
local ag=function(ah)
local ai=tonumber(ah:sub(1,4),16)
local aj=tonumber(ah:sub(7,10),16)
if aj then
return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)
else
return af(ai)
end
end
local ak=function(a8,a0)
local _=""
local al=a0+1
local Q=al
while al<=#a8 do
local am=a8:byte(al)
if am<32 then
ac(a8,al,"control character in string")
elseif am==92 then
_=_..a8:sub(Q,al-1)
al=al+1
local T=a8:sub(al,al)
if T=="u"then
local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)
or a8:match("^%x%x%x%x",al+1)
or ac(a8,al-1,"invalid unicode escape in string")
_=_..ag(an)
al=al+#an
else
if not a5[T]then
ac(a8,al-1,"invalid escape char '"..T.."' in string")
end
_=_..P[T]
end
Q=al+1
elseif am==34 then
_=_..a8:sub(Q,al-1)
return _,al+1
end
al=al+1
end
ac(a8,a0,"expected closing quote for string")
end
local ao=function(a8,a0)
local am=a7(a8,a0,p)
local ah=a8:sub(a0,am-1)
local A=tonumber(ah)
if not A then
ac(a8,a0,"invalid number '"..ah.."'")
end
return A,am
end
local ap=function(a8,a0)
local am=a7(a8,a0,p)
local aq=a8:sub(a0,am-1)
if not m[aq]then
ac(a8,a0,"invalid literal '"..aq.."'")
end
return a6[aq],am
end
local ar=function(a8,a0)
local _={}
local A=1
a0=a0+1
while 1 do
local am
a0=a7(a8,a0,L,true)
if a8:sub(a0,a0)=="]"then
a0=a0+1
break
end
am,a0=a4(a8,a0)
_[A]=am
A=A+1
a0=a7(a8,a0,L,true)
local as=a8:sub(a0,a0)
a0=a0+1
if as=="]"then
break
end
if as~=","then
ac(a8,a0,"expected ']' or ','")
end
end
return _,a0
end
local at=function(a8,a0)
local _={}
a0=a0+1
while 1 do
local au,M
a0=a7(a8,a0,L,true)
if a8:sub(a0,a0)=="}"then
a0=a0+1
break
end
if a8:sub(a0,a0)~='"'then
ac(a8,a0,"expected string for key")
end
au,a0=a4(a8,a0)
a0=a7(a8,a0,L,true)
if a8:sub(a0,a0)~=":"then
ac(a8,a0,"expected ':' after key")
end
a0=a7(a8,a0+1,L,true)
M,a0=a4(a8,a0)
_[au]=M
a0=a7(a8,a0,L,true)
local as=a8:sub(a0,a0)
a0=a0+1
if as=="}"then
break
end
if as~=","then
ac(a8,a0,"expected '}' or ','")
end
end
return _,a0
end
local av={
['"']=ak,
["0"]=ao,
["1"]=ao,
["2"]=ao,
["3"]=ao,
["4"]=ao,
["5"]=ao,
["6"]=ao,
["7"]=ao,
["8"]=ao,
["9"]=ao,
["-"]=ao,
["t"]=ap,
["f"]=ap,
["n"]=ap,
["["]=ar,
["{"]=at,
}
a4=function(a8,a9)
local as=a8:sub(a9,a9)
local a2=av[as]
if a2 then
return a2(a8,a9)
end
ac(a8,a9,"unexpected character '"..as.."'")
end
local aw=function(a8)
if type(a8)~="string"then
error("expected argument of type string, got "..type(a8))
end
local _,a9=a4(a8,a7(a8,1,L,true))
a9=a7(a8,a9,L,true)
if a9<=#a8 then
ac(a8,a9,"trailing garbage")
end
return _
end
local lEncode,lDecode,lDigest=a3,aw,Z----------------------------------------------------------------------------------------------------------------------------------------------------------------! platoboost library--! configuration






local service=2393-- your service id, this is used to identify your service.
local secret="b6bbb0db-612a-4fef-80e1-369603e9c92e"-- make sure to obfuscate this if you want to ensure security.
local useNonce=true-- use a nonce to prevent replay attacks and request tampering.--! callbacks


local onMessage=function(message)end--! wait for game to load


repeat
task.wait(1)
until game:IsLoaded()--! functions


local requestSending=false
local fSetClipboard,fRequest,fStringChar,fToString,fStringSub,fOsTime,fMathRandom,fMathFloor,fGetHwid=
setclipboard or toclipboard,
request or http_request or syn_request,
string.char,
tostring,
string.sub,
os.time,
math.random,
math.floor,
gethwid or function()
return game:GetService("Players").LocalPlayer.UserId
end
local cachedLink,cachedTime="",0--! pick host


local host="https://api.platoboost.com"
local hostResponse=fRequest({
Url=host.."/public/connectivity",
Method="GET",
})
if hostResponse.StatusCode~=200 or hostResponse.StatusCode~=429 then
host="https://api.platoboost.net"
end--!optimize 2


local function cacheLink()
if cachedTime+(600)<fOsTime()then
local response=fRequest({
Url=host.."/public/start",
Method="POST",
Body=lEncode({
service=service,
identifier=lDigest(fGetHwid()),
}),
Headers={
["Content-Type"]="application/json",
},
})

if response.StatusCode==200 then
local decoded=lDecode(response.Body)

if decoded.success==true then
cachedLink=decoded.data.url
cachedTime=fOsTime()
return true,cachedLink
else
onMessage(decoded.message)
return false,decoded.message
end
elseif response.StatusCode==429 then
local msg="you are being rate limited, please wait 20 seconds and try again."
onMessage(msg)
return false,msg
end

local msg="Failed to cache link."
onMessage(msg)
return false,msg
else
return true,cachedLink
end
end

cacheLink()--!optimize 2


local generateNonce=function()
local str=""
for _=1,16 do
str=str..fStringChar(fMathFloor(fMathRandom()*(26))+97)
end
return str
end--!optimize 1


for _=1,5 do
local oNonce=generateNonce()
task.wait(0.2)
if generateNonce()==oNonce then
local msg="platoboost nonce error."
onMessage(msg)
error(msg)
end
end--!optimize 2


local copyLink=function()
local success,link=cacheLink()

if success then
fSetClipboard(link)
end
end--!optimize 2


local redeemKey=function(key)
local nonce=generateNonce()
local endpoint=host.."/public/redeem/"..fToString(service)

local body={
identifier=lDigest(fGetHwid()),
key=key,
}

if useNonce then
body.nonce=nonce
end

local response=fRequest({
Url=endpoint,
Method="POST",
Body=lEncode(body),
Headers={
["Content-Type"]="application/json",
},
})

if response.StatusCode==200 then
local decoded=lDecode(response.Body)

if decoded.success==true then
if decoded.data.valid==true then
if useNonce then
if decoded.data.hash==lDigest("true".."-"..nonce.."-"..secret)then
return true
else
onMessage("failed to verify integrity.")
return false
end
else
return true
end
else
onMessage("key is invalid.")
return false
end
else
if fStringSub(decoded.message,1,27)=="unique constraint violation"then
onMessage("you already have an active key, please wait for it to expire before redeeming it.")
return false
else
onMessage(decoded.message)
return false
end
end
elseif response.StatusCode==429 then
onMessage("you are being rate limited, please wait 20 seconds and try again.")
return false
else
onMessage("server returned an invalid status code, please try again later.")
return false
end
end--!optimize 2


local verifyKey=function(key)
if requestSending==true then
onMessage("a request is already being sent, please slow down.")
return false
else
requestSending=true
end

local nonce=generateNonce()
local endpoint=host
.."/public/whitelist/"
..fToString(service)
.."?identifier="
..lDigest(fGetHwid())
.."&key="
..key

if useNonce then
endpoint=endpoint.."&nonce="..nonce
end

local response=fRequest({
Url=endpoint,
Method="GET",
})

requestSending=false

if response.StatusCode==200 then
local decoded=lDecode(response.Body)

if decoded.success==true then
if decoded.data.valid==true then
if useNonce then
if decoded.data.hash==lDigest("true".."-"..nonce.."-"..secret)then
return true
else
onMessage("failed to verify integrity.")
return false
end
else
return true
end
else
if fStringSub(key,1,4)=="KEY_"then
return redeemKey(key)
else
onMessage("key is invalid.")
return false
end
end
else
onMessage(decoded.message)
return false
end
elseif response.StatusCode==429 then
onMessage("you are being rate limited, please wait 20 seconds and try again.")
return false
else
onMessage("server returned an invalid status code, please try again later.")
return false
end
end--!optimize 2


local getFlag=function(name)
local nonce=generateNonce()
local endpoint=host.."/public/flag/"..fToString(service).."?name="..name

if useNonce then
endpoint=endpoint.."&nonce="..nonce
end

local response=fRequest({
Url=endpoint,
Method="GET",
})

if response.StatusCode==200 then
local decoded=lDecode(response.Body)

if decoded.success==true then
if useNonce then
if decoded.data.hash==lDigest(fToString(decoded.data.value).."-"..nonce.."-"..secret)then
return decoded.data.value
else
onMessage("failed to verify integrity.")
return nil
end
else
return decoded.data.value
end
else
onMessage(decoded.message)
return nil
end
else
return nil
end
end

return{
copyLink=copyLink,
verifyKey=verifyKey,
getFlag=getFlag,
onMessage=onMessage,
}----------------------------------------------------------------------------------------------------------------------------------------------------------------! platoboost usage documentation-- copyLink() -> string-- verifyKey(key: string) -> boolean-- getFlag(name: string) -> boolean, string | boolean | number-- use copyLink() to copy a link to the clipboard, in which the user will paste it into their browser and complete the keysystem.-- use verifyKey(key) to verify a key, this will return a boolean value, true means the key was valid, false means it is invalid.-- use getFlag(name) to get a flag from the server, this will return nil if an error occurs, if no error occurs, the value configured in the platoboost dashboard will be returned.-- IMPORTANT: onMessage is a callback, it will be called upon status update, use it to provide information to user.-- EXAMPLE:--[[
onMessage = function(message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Platoboost status",
        Text = message
    })
end
]]---- NOTE: PLACE THIS ENTIRE SCRIPT AT THE TOP OF YOUR SCRIPT, ADD THE LOGIC, THEN OBFUSCATE YOUR SCRIPT.--! example usage--[[
copyButton.MouseButton1Click:Connect(function()
    copyLink();
end)

verifyButton.MouseButton1Click:Connect(function()
    local key = keyBox.Text;
    local success = verifyKey(key);

    if success then
        print("key is valid.");
    else
        print("key is invalid.");
    end
end)

local flag = getFlag("example_flag");
if flag ~= nil then
    print("flag value: " .. flag);
else
    print("failed to get flag.");
end
]]---------------------------------------------------------------------------------
end function __DARKLUA_BUNDLE_MODULES.f()
























local Logger
local function isrbxclosure(func)
local source=debug.info(func,"s")
if source and source:sub(1,7)=="CoreGui"then
return true
end
return iscclosure(func)
end

local function disableconn(conn)
pcall(conn.Disable,conn)
pcall(conn.Disconnect,conn)
end
local function BlockAntiCheatRequests()
game["Script Context"]:SetTimeout(1)-- https://github.com/pubmain/bin/blob/993c7134c8a06ec94d157b3a1dbb819276b99f7e/pcd_anti_cheat.lua

local function isBlocked(remote)
if remote:IsDescendantOf(game:GetService("ReplicatedStorage").StreamingAssets)then
return true
end
if remote:IsDescendantOf(workspace.Expansions)then
return true
end
return remote.Name=="DeItaRemote"
end
local origFireServer
origFireServer=hookfunction(
Instance.new("RemoteEvent").FireServer,
newcclosure(function(self,...)
local argv={...}
if typeof(self)=="Instance"and isBlocked(self)and self.ClassName=="RemoteEvent"then
if not(#argv==1 and argv[1]==1)then
Logger:log("Blocked remote",self,"from firing",...)
return task.wait(9e9)
end-- print("blocked", self:GetFullName(), ...)-- self = Instance.new("RemoteEvent")


end
return origFireServer(self,...)
end)
)-- -- note: maybe its usless idk

local __namecall-- local CoreGui = game:GetService("CoreGui")

local origPreloadAsync
local ContentProvider=game:GetService("ContentProvider")-- local BlacklistedInstances = { CoreGui, game }

origPreloadAsync=hookfunction(
ContentProvider.PreloadAsync,
newcclosure(function(...)
if false then
Logger:log(".PreloadAsync was called",...)
return error()
end
return origPreloadAsync(...)-- error()

end)-- newcclosure(function(self, list, callback)-- 	-- if checkcaller() then-- 	-- 	list = {}-- 	-- 	-- for _, elem in pairs(BlacklistedInstances) do-- 	-- 	--     for i, value in pairs(list) do-- 	-- 	--         if value == elem or value.Name == elem.Name then-- 	-- 	--             list[i] = game.Players.LocalPlayer.PlayerGui-- 	-- 	--         end-- 	-- 	--     end-- 	-- 	-- end-- 	-- end-- 	-- task.wait(9e9)-- 	return origPreloadAsync(self, {}, callback)-- end)














)
__namecall=hookmetamethod(game,"__namecall",function(self,...)
local method=getnamecallmethod()
if self==ContentProvider and method=="PreloadAsync"and not checkcaller()then
if false then
Logger:log("redirecting :PreloadAsync to .PreloadAsync",getcallingscript():GetFullName())
end
return ContentProvider.PreloadAsync(self,...)
end-- if method == "FireServer" and self.ClassName == "RemoteEvent" and isBlocked(self) and not checkcaller() then-- 	if DEBUG then-- 		Logger:log("Blocked event", self, "from firing", getcallingscript():GetFullName(), ...)-- 	end-- 	return-- end






if method=="FindFirstChild"and not checkcaller()then
local name,recursive=...
if name=="F3X"then-- note: too spammy-- if DEBUG then-- 	Logger:log("Bypassed check for F3X", getcallingscript():GetFullName())-- end




return nil
end
end
return __namecall(self,...)
end)
if false then
Logger:log("Disabling LogService.MessageOut")
end
for _,conn in getconnections(game:GetService("LogService").MessageOut)do
if conn.Function and not isrbxclosure(conn.Function)then
disableconn(conn)
end
end
if false then
Logger:log("Disabling ScriptContext.Error")
end
for _,conn in getconnections(game:GetService("ScriptContext").Error)do
if conn.Function and not isrbxclosure(conn.Function)then
disableconn(conn)
end
end-- Logger:log("Disabled client anti cheat")

end

local function UnprotectAll()-- https://github.com/pubmain/bin/blob/993c7134c8a06ec94d157b3a1dbb819276b99f7e/pcd_anti_cheat.lua-- note: unprotects every protected instance protected by a nil script (Check getnilinstances() for scripts that use ContextProvider service)-- note: this function is bugged rn (issue is getconnections)



local function Unprotect(part)do

return end-- Logger:log(part:GetFullName(), "has been unprotected")-- print(part:GetFullName(), "has been unprotected")














end
for _,v in workspace.Railway.Crossings:GetDescendants()do
Unprotect(v)
end
local Radars=workspace.radary
Unprotect(Radars.Malechowo.Sensor)
Unprotect(Radars.Rzyszczewo.Sensor)
Unprotect(Radars["S\196\153czkowo"].Sensor)
Unprotect(Radars["S\197\130awno"].Sensor)
if false then
Logger:log("Unprotected all protected instances")
end
end

return function(logger)
Logger=logger
if false then
Logger:log("Disabling anticheat")
end
BlockAntiCheatRequests()
pcall(UnprotectAll)
end end function __DARKLUA_BUNDLE_MODULES.g()

loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/scripts/main/dump.lua"))();

return{
dump=dump,
printdump=printdump
}end function __DARKLUA_BUNDLE_MODULES.h()

local module={}
module.__index=module

local HttpService=game:GetService("HttpService")

local function validate_table(input_table,default_table)-- Check if the input_table is nil or not a table

if type(input_table)~="table"then
return default_table
end-- Iterate over the default_table to check for matching types and fields


for key,default_value in pairs(default_table)do
local input_value=input_table[key]-- If the key is not present in the input_table or the types don't match, set it to the default value


if input_value==nil or type(input_value)~=type(default_value)then
input_table[key]=default_value
elseif type(default_value)=="table"then-- If the value is a table, recursively validate it

validate_table(input_value,default_value)
end
end-- Return the validated input_table


return input_table
end

local config={}
config.__index=config
function module:new(name,default_cfg,onMessage)
name=tostring(name)
onMessage=onMessage or print
local exists=isfile(name)
local parsed
if not exists then
print("nie znaleziono pliku configuracyjnego",name)
writefile(name,HttpService:JSONEncode(default_cfg))
parsed=default_cfg
else
local contents=readfile(name)
local success
success,parsed=pcall(HttpService.JSONDecode,HttpService,contents)
if not success then
return onMessage('Failed to load config "'..name..'", reason: '..parsed)
end
end
local validated=validate_table(parsed,default_cfg)
validated.__CFG_NAME=name
writefile(name,HttpService:JSONEncode(default_cfg))
return setmetatable(validated,config)
end

function config:save()
writefile(self.__CFG_NAME,HttpService:JSONEncode(self))
end

function config:createHandler(field)
return function(value)
self[field]=value
pcall(self.save,self)
end
end

function config:create(field)
return self[field],self:createHandler(field)
end

return module end function __DARKLUA_BUNDLE_MODULES.i()

local Utils={}
local LocalPlayer=game.Players.LocalPlayer

function Utils.GetPlayerVehicle(player)
player=player or LocalPlayer
return workspace.Cars:FindFirstChild(player.Name)
end

function Utils.PlayerHasVehicle(player)
player=player or LocalPlayer
return workspace.Cars:FindFirstChild(player.Name)~=nil
end

function Utils.PlayerInsideVehicle(player)
player=player or LocalPlayer
if not player.Character then
return false
end
if not player.Character.Humanoid.SeatPart then
return false
end
return player.Character.Humanoid.SeatPart:IsDescendantOf(workspace.Cars)
end

function Utils.PlayerInsideHisOwnVehicle(player)
player=player or LocalPlayer
if not player.Character then
return false
end
local Vehicle=Utils.GetPlayerVehicle(player)
if not Vehicle then
return false
end
if not player.Character.Humanoid.SeatPart then
return false
end
return player.Character.Humanoid.SeatPart:IsDescendantOf(Vehicle)
end

function Utils.GetCurrentDestination()
local Character=LocalPlayer.Character
if not Character or not Character.PrimaryPart then
return
end
local DirectionBeam=Character.HumanoidRootPart.DirectionAttachment:FindFirstChild("DirectionBeam")
if not DirectionBeam or not DirectionBeam.Enabled then
return
end
local Attachment1=DirectionBeam.Attachment1
if not Attachment1 then
return
end
return Attachment1.Parent
end

function Utils.GenerateColor()
return Color3.new(math.random(),math.random(),math.random())
end

function Utils.NoiseifyColor(color,mod)
mod=1E-2
return Color3.new(color.R+math.random()*mod,color.G+math.random()*mod,color.B+math.random()*mod)
end

function Utils.ModelTween(model,targetCFrame,tweenInfo,handler,completed)
handler=handler or function()end
completed=completed or function()end
local pivotCFrameValue=Instance.new("CFrameValue")
pivotCFrameValue.Value=model:GetPivot()
local tween=game:GetService("TweenService"):Create(pivotCFrameValue,tweenInfo,{Value=targetCFrame})
local Heartbeat
local Completed=tween.Completed:Connect(function()
Heartbeat:Disconnect()
model:PivotTo(targetCFrame)
completed()
end)
Heartbeat=game:GetService("RunService").Heartbeat:Connect(function(dt)
if tween.PlaybackState==Enum.PlaybackState.Cancelled then
Heartbeat:Disconnect()
Completed:Disconnect()
return
end
model:PivotTo(pivotCFrameValue.Value)
handler(dt)
end)
tween:Play()
return tween,Heartbeat,Completed
end

function Utils.CreateInvertedBox(pos)
local size=Vector3.new(100,100,100)
local thickness=2
local Parent=Instance.new("Model",workspace)-- Function to create a wall


local function createWall(position,rotation,wallSize)
local wall=Instance.new("Part",Parent)
wall.Size=wallSize
wall.Position=position
wall.Rotation=rotation
wall.Anchored=true
wall.Transparency=1
return wall
end

createWall(pos+Vector3.new(0,size.Y/2,0),Vector3.new(0,0,0),Vector3.new(size.X,thickness,size.Z))
createWall(pos-Vector3.new(0,size.Y/2,0),Vector3.new(0,0,0),Vector3.new(size.X,thickness,size.Z))

createWall(pos+Vector3.new(size.X/2,0,0),Vector3.new(0,0,0),Vector3.new(thickness,size.Y,size.Z))
createWall(pos-Vector3.new(size.X/2,0,0),Vector3.new(0,0,0),Vector3.new(thickness,size.Y,size.Z))

createWall(pos+Vector3.new(0,0,size.Z/2),Vector3.new(0,0,0),Vector3.new(size.X,size.Y,thickness))
createWall(pos-Vector3.new(0,0,size.Z/2),Vector3.new(0,0,0),Vector3.new(size.X,size.Y,thickness))
return Parent
end

return Utils end function __DARKLUA_BUNDLE_MODULES.j()

local module={}
module.__index=module

function module:new(CurrentState,ErrorHandler,Logger,MachineName)
return setmetatable({
CurrentState=CurrentState,
ErrorHandler=ErrorHandler,
RegisteredStates={},
Logger=Logger,
MachineName=MachineName,
onChange=function()end,
},module)
end

function module:registerState(State,Handler)
self.RegisteredStates[State]=Handler
if false then
self.Logger:log('Registered new state: "'..tostring(State)..'" with handler: '..tostring(Handler))
end
end

function module:updateState(State)
if not self.RegisteredStates[State]then
return self:error('Tried to update the state to unknown, got: "'..tostring(State)..'"')
end
self.onChange(State)
self.CurrentState=State
end

function module:handle()
if not self.CurrentState then
return self:error("CurrentState is not set")
end
local Handler=self.RegisteredStates[self.CurrentState]
if not Handler then
return self:error(self.CurrentState.." is not registered")
end
Handler()-- local success, err = pcall(Handler)-- if not success then-- 	if not self.ErrorHandler then-- 		self:error(self.CurrentState .. " failed, reason is: " .. err)-- 	else-- 		self.ErrorHandler(err)-- 	end-- 	return false-- end-- return true










end

function module:error(Message)
Message="["..self.MachineName.."] failed, reason is: "..Message-- self.Logger:Log(Message)

error(Message)
return Message
end

return module end function __DARKLUA_BUNDLE_MODULES.k()

local VirtualUser=game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)

return nil end function __DARKLUA_BUNDLE_MODULES.l()

return{
PhoneHandler=(function()
local signal=game.Players.LocalPlayer.PlayerGui.Telefonix.UberTaxi.Frame.Accept.Activated
local ret={}
for _,conn in getconnections(signal)do
if conn.Function then-- local source = debug.info(conn.Function, "s")

for _,upv in debug.getupvalues(conn.Function)do
if
type(upv)=="table"
and type(upv.b)=="function"
and upv.c
and type(upv.c.Connect)=="function"
then
return upv-- table.insert(ret, upv)

end
end
end
end
if ret[1]and false then
print("Succesfully found PhoneHandler ByteUtil module!")
end
return ret[1]
end)(),
}end end

local RunService=game:GetService("RunService")
local PlayersService=game:GetService("Players")
local LocalPlayer=PlayersService.LocalPlayer
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local HttpService=game:GetService("HttpService")
local LoggerModule=__DARKLUA_BUNDLE_MODULES.load('a')
local SendNotification=__DARKLUA_BUNDLE_MODULES.load('b')
local Constants=__DARKLUA_BUNDLE_MODULES.load('c')
if game.PlaceId~=Constants.PlaceId then
return SendNotification("Zła gra","Wejdz do polish car driving")
end
local Metadata=__DARKLUA_BUNDLE_MODULES.load('d')
local platoboost=__DARKLUA_BUNDLE_MODULES.load('e')
local copyLink,verifyKey,getFlag=platoboost.copyLink,platoboost.verifyKey,platoboost.getFlag

if getthreadidentity()<8 then
setclipboard(Metadata.discord)
return SendNotification("Za słaby executor! - "..identifyexecutor(),"Użyj executorów podanych w #tutorial")
end
local AntiCheatDisable=__DARKLUA_BUNDLE_MODULES.load('f')__DARKLUA_BUNDLE_MODULES.load('g')

local ConfigManager=__DARKLUA_BUNDLE_MODULES.load('h')
local PlayersService=game:GetService("Players")
local LocalPlayer=PlayersService.LocalPlayer
local IsServerSupported=table.find(Constants.SupportedPlaceVersion,game.PlaceVersion)~=nil
local Utils=__DARKLUA_BUNDLE_MODULES.load('i')
if getFlag("KillSwitch")then
setclipboard(Metadata.discord)
return SendNotification("Skrypt został zatrzymany","Sprawdź discorda (skopiowano link)")
end
if not IsServerSupported then
SendNotification("Skrypt przestarzały","Skrypt może nie działac albo możesz dostać bana")
end
local StateMachineLib=__DARKLUA_BUNDLE_MODULES.load('j')__DARKLUA_BUNDLE_MODULES.load('k')


local ByteUtilModules=__DARKLUA_BUNDLE_MODULES.load('l')
local Logger=LoggerModule:init({
output="pubmain.pcd.log",
time=true,
print=not not false,
})
AntiCheatDisable(Logger)
local AutoFarmMachine=StateMachineLib:new(Constants.States.Waiting,nil,Logger,"AutoFarm")

local Library=
loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/bin/refs/heads/main/xsx_fix_library.lua"))()
local Config=ConfigManager:new("pubmain.pcd.json",{
InfFuel=false,
ServerSortOrder="Malejąca",
TweenSpeed=120,
TweenHeight=0,
DisableAutoFarmOnStartup=true,
Key=nil,
})
local base64decode=crypt.base64decode
if Config.DisableAutoFarmOnStartup then
Config.AutoFarm=false
end-- printdump(Config)

local NotificationLib=Library:InitNotifications()

local function WrapCall(callback,name)
return function(...)
local success,err=pcall(callback,...)
if not success then
Logger:log("Function",name,"stopped working",err)
return NotificationLib:Notify("Funkcja "..name.." przestała działac! "..tostring(err),10,"error")
end
end
end

local function SkipLoadingScreen()
local LoadingHandler=game:GetService("ReplicatedFirst").LoadingHandler
if LoadingHandler.Enabled then
getsenv(LoadingHandler)._G.LoadingCompleted=true
end
LoadingHandler.Enabled=false
local LoadingScreen=LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen")
if LoadingScreen then
LoadingScreen.Enabled=false
end
LocalPlayer.PlayerGui.InterfaceMain.Enabled=true
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,true)
workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
NotificationLib:Notify("Usunięto ekran ładowania",3,"success")
end-- local function SendWebhookRaw(data)-- 	if not Config.WebhookEnabled then-- 		return-- 	end-- 	local res = request({-- 		Url = Config.WebhookUrl,-- 		Method = "POST",-- 		Body = HttpService:JSONEncode({-- 			username = "Pubmain PCD Webhook",-- 			avatar_url = "https://cdn.discordapp.com/attachments/1333960931419492353/1349779031087644672/OjUHcfo.png?ex=67d4572e&is=67d305ae&hm=9cdab077c623f5c4ee9995c051f45e8342fbfc7be312d733d85d499e92943070&",-- 			content = "```" .. Library.title .. "```",-- 			embeds = {-- 				avatar = {-- 					url = "https://www.roblox.com/users/" .. tostring(LocalPlayer.UserId),-- 					icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(-- 						LocalPlayer.UserId-- 					) .. "&width=420&height=420&format=png",-- 					name = LocalPlayer.Name,-- 				},-- 				title = Constants.ScriptVersion,-- 				url = Metadata.discord,-- 				fields = data,-- 				description = "Najlepszy skrypt do pcd @pubmain " .. Metadata.discord,-- 			},-- 		}),-- 		Headers = { ["Content-Type"] = "application/json" },-- 	})-- 	res = HttpService:JSONDecode(res.Body)-- 	if res.code ~= 200 then-- 		for k, v in res do-- 			print(k, v)-- 		end-- 		NotificationLib:Notify("Webhook error: " .. res.message, 3, "error")-- 	end-- end





































Library.title="Pubmain PCD | v"..tostring(Constants.ScriptVersion).." | "..Metadata.discord
Library:Watermark(Library.title)-- Library:Introduction()


local Window=Library:Init()-- local LicenseTab = Window:NewTab("Licensja")-- local KeyIsValid = false-- LicenseTab:NewButton("Zdobądź klucz", function()-- 	copyLink()-- 	NotificationLib:Notify("Skopiowano link (otwórz w przeglądarce)", 3, "success")-- end)-- local function VerifyKeyCallback(key)-- 	KeyIsValid = verifyKey(key)-- 	Config.Key = key-- 	Config:save()-- 	if KeyIsValid then-- 		NotificationLib:Notify("Klucz jest prawidłowy, włączanie skryptu", 3, "success")-- 	else-- 		NotificationLib:Notify("Klucz nie jest poprawny", 3, "error")-- 	end-- end-- LicenseTab:NewTextbox("Klucz", "", "", "all", "medium", true, false, VerifyKeyCallback)-- if Config.Key then-- 	VerifyKeyCallback(Config.Key)-- end-- repeat-- 	task.wait()-- until KeyIsValid-- LicenseTab:Remove()





























local MainTab=Window:NewTab("Main")
MainTab:Open()-- MainTab:NewButton("test webhook", function()-- 	SendWebhookRaw({ {-- 		name = "test",-- 		value = "halo",-- 		inline = true,-- 	} })-- end)








MainTab:NewSection("Zmiany")

table.foreach(Constants.UpdateLog,function(_,value)
MainTab:NewLabel(" - "..value)
end)

MainTab:NewSection("")

MainTab:NewButton("Dołącz do naszego serwera "..Metadata.discord,function()
NotificationLib:Notify("Skopiowano link",1,"success")
setclipboard(Metadata.discord)
end)

MainTab:NewButton("Skipnij ładowanie",WrapCall(SkipLoadingScreen,"SkipLoadingScreen"))-- MainTab:NewButton("Zoptymalizuj gre", function() end)


MainTab:NewButton(
"Zamknij skrypt",
WrapCall(function()
Window:Remove()
Config:save()
Config.AutoFarm=false
end,"CloseScript")
)

MainTab:NewKeybind(
"Interfejs toggle",
Enum.KeyCode.RightAlt,
WrapCall(function()
Library:UpdateKeybind(Enum.KeyCode[key])
end,"ChangeKeybind")
)-- MainTab:NewTextbox("Webhook", Config.WebhookUrl, "", "all", "medium", true, false, Config:createHandler("WebhookUrl"))-- MainTab:NewToggle("Webhook włączony", Config:create("WebhookEnabled"))




local AutoFarmTab=Window:NewTab("Auto farm")

local StateLabel=AutoFarmTab:NewLabel("Stan auto farmy: "..AutoFarmMachine.CurrentState)
AutoFarmMachine.onChange=function(state)
StateLabel:Text("Stan auto farmy: "..state)
end

local OwnedCars={}-- note: rewrite this

local function UpdateCars()
for _,option in OwnedCars do
AutoFarmSelectCar:RemoveOption(option)
end
OwnedCars={}
for _,instance in LocalPlayer.Cars:GetChildren()do
table.insert(OwnedCars,instance.Name)-- AutoFarmSelectCaron(instance.Name)

end-- AutoFarmSelectCar:Text(OwnedCars[1] or "Nie masz aut 🤯")

end-- note: keysystem check-- if-- 	-- note: check if the current key is invalid-- 	not require("../lib/platoboost")[base64decode("dmVyaWZ5S2V5")](Config[base64decode("S2V5")])-- 	-- note: check if verifyKey is hooked to return true always-- 	or require("../lib/platoboost")[base64decode("dmVyaWZ5S2V5")]("KEY_a")-- then-- 	local exp_localplayer =-- 		getfenv()[base64decode("Z2FtZQ==")][base64decode("UGxheWVycw==")][base64decode("TG9jYWxQbGF5ZXI=")]-- 	-- local _banremote = ReplicatedStorage[base64decode("UmVtb3Rlcw==")]["RGVJdGFSZW1vdGU="]-- 	-- local _fireserver = _banremote[base64decode("RmlyZVNlcnZlcg==")]-- 	exp_localplayer[base64decode("a2ljaw==")](-- 		exp_localplayer,-- 		base64decode("bHViaWUgcGllbmlhxbxraSB3aWVjIG5pZSBieXBhc3N1aiBsaWNlbnNqaQ==")-- 	)-- 	-- while not KeyIsValid do-- 	-- 	_fireserver(-- 	-- 		_banremote,-- 	-- 		base64decode("VEhJUyBVU0VSIFRSSUVEIFRPIFBVQk1BSU4gUENEIFNDUklQVCBodHRwczovL2Rpc2NvcmQuZ2cvYzZQN3VnR25uRw==")-- 	-- 	)-- 	-- end-- end

























LocalPlayer.Cars.ChildAdded:Connect(UpdateCars)
UpdateCars()-- local AutoFarmSelectCar = AutoFarmTab:NewSelector("Auto do zrespawnowania", "Wybierz auto", OwnedCars, function() end)


do
local Nodes=workspace.PCDMap.Roads:GetChildren()
AutoFarmMachine:registerState(Constants.States.TPDestination,function()
local Vehicle=Utils.GetPlayerVehicle()
if not Vehicle then
return AutoFarmMachine:updateState(Constants.States.SpawningCar)
end
if not Utils.PlayerInsideHisOwnVehicle()then
return AutoFarmMachine:updateState(Constants.States.EnteringCar)
end
local Destination=Utils.GetCurrentDestination()
if not Destination then
return AutoFarmMachine:updateState(Constants.States.Waiting)
end

local Tween=Utils.ModelTween(
Vehicle,
Vehicle:GetPivot()+Vector3.new(0,Config.TweenHeight,0),
TweenInfo.new(1),
nil,
nil
)
Tween.Completed:Wait()-- Function to calculate the distance between two positions


local function calculateDistance(position1,position2)
return(position1-position2).Magnitude
end-- Function to find the closest node to the current position


local function findClosestNode(currentPosition,targetPosition,nodes)
local closestNode
local shortestDistance=math.huge

for _,node in ipairs(nodes)do-- Calculate distance from current position to the node

local distanceToNode=calculateDistance(currentPosition,node.Position)-- Calculate distance from the node to the target

local distanceToTarget=calculateDistance(node.Position,targetPosition)-- Ensure the node is closer to the target than the current position


if distanceToTarget<calculateDistance(currentPosition,targetPosition)then-- Check if this node is the closest so far

if distanceToNode<shortestDistance and distanceToNode>20 then
closestNode=node
shortestDistance=distanceToNode
end
end
end

return closestNode
end

Vehicle:PivotTo(Vehicle:GetPivot()+Vector3.new(0,Config.TweenHeight,0))
while calculateDistance(Vehicle.PrimaryPart.Position,Destination.Position)>5 do-- Find the closest node

local closestNode=findClosestNode(Vehicle.PrimaryPart.Position,Destination.Position,Nodes)
or Destination
local IsCompleted=false
local Tween,Heartbeat,Completed
Tween,Heartbeat,Completed=Utils.ModelTween(
Vehicle,
closestNode.CFrame+Vector3.new(0,Config.TweenHeight,0),
TweenInfo.new(
(closestNode.Position-Vehicle.PrimaryPart.Position).Magnitude/Config.TweenSpeed,
Enum.EasingStyle.Linear,
Enum.EasingDirection.Out
),
function()
if not Vehicle.PrimaryPart then
Heartbeat:Disconnect()
Completed:Disconnect()
return Tween:Cancel()
end
Vehicle.PrimaryPart.AssemblyLinearVelocity=Vector3.new(0,0,0)
Vehicle.PrimaryPart.AssemblyAngularVelocity=Vector3.new(0,0,0)
end,
function()
IsCompleted=true
end
)
repeat
if not Utils.PlayerInsideHisOwnVehicle()then
return error("Gracz wyszedł z auta")
end
task.wait(0)
until IsCompleted
or not Config.AutoFarm
or Tween.PlaybackState==Enum.PlaybackState.Cancelled
or not Utils.GetCurrentDestination()
Heartbeat:Disconnect()
Completed:Disconnect()
if not IsCompleted then
return
end
if closestNode==Destination then
break
end
end

local Tween=Utils.ModelTween(Vehicle,Destination.CFrame,TweenInfo.new(1),nil,nil)
Tween.Completed:Wait()
task.wait(0.5)
local Root=LocalPlayer.Character.HumanoidRootPart
firetouchinterest(Root,Destination,0)
task.wait(0.5)
firetouchinterest(Root,Destination,1)
end)

AutoFarmMachine:registerState(Constants.States.SpawningCar,function()
local Vehicle=Utils.GetPlayerVehicle()
if Vehicle then
return AutoFarmMachine:updateState(Constants.States.Waiting)
end
ReplicatedStorage.spawn_car:FireServer(
OwnedCars[1],
Utils.NoiseifyColor(Config.CarColor or Utils.GenerateColor())
)
task.wait(1)
AutoFarmMachine:updateState(Constants.States.EnteringCar)-- ReplicatedStorage.spawn_car:FireServer("Maluch", Utils.NoiseifyColor(Color3.new()))

end)

AutoFarmMachine:registerState(Constants.States.EnteringCar,function()
local Character=LocalPlayer.Character
if not Character then
return AutoFarmMachine:updateState(Constants.States.WaitingRespawn)
end
local Vehicle=Utils.GetPlayerVehicle()
if not Vehicle then
return AutoFarmMachine:updateState(Constants.States.SpawningCar)
end
if Utils.PlayerInsideHisOwnVehicle()then
return AutoFarmMachine:updateState(Constants.States.Waiting)
end
fireproximityprompt(Vehicle.DriveSeat.DPX)
task.wait(0.5)
AutoFarmMachine:updateState(Constants.States.Waiting)
end)

AutoFarmMachine:registerState(Constants.States.Waiting,function()
local Character=LocalPlayer.Character
if not Character then
return AutoFarmMachine:updateState(Constants.States.WaitingRespawn)
end
if Utils.GetCurrentDestination()then
return AutoFarmMachine:updateState(Constants.States.TPDestination)
else
return
end
end)

AutoFarmMachine:registerState(Constants.States.WaitingRespawn,function()
local Character=LocalPlayer.Character
if Character then
return AutoFarmMachine:updateState(Constants.States.Waiting)
end
LocalPlayer.CharacterAdded:Wait()
end)
end

local AutoFarmToggle
AutoFarmToggle=AutoFarmTab:NewToggle(
"Auto farm",
false,
WrapCall(function(value)
if#OwnedCars==0 and value then
AutoFarmToggle:Set(false)
return NotificationLib:Notify("Nie masz żadnego auta!",3,"error")
end
Config.AutoFarm=value
while Config.AutoFarm do
local succeded,err=pcall(AutoFarmMachine.handle,AutoFarmMachine)
if not succeded then
Config.AutoFarm=false
NotificationLib:Notify("Auto farma sie zepsula! "..err,10,"error")
AutoFarmToggle:Set(false)
return
end
task.wait(0.5)
end
end,"AutoFarmToggle")
)

ByteUtilModules.PhoneHandler.c:Connect(WrapCall(function(delivery_type,info)
if false then
Logger:log("Received Delivery update",delivery_type,info)
end
if not Config.AutoFarm then
return
end-- note: type=2 - uber eats, type=3 - taxi

if delivery_type~=2 and delivery_type~=3 then
return--Logger:log("Returned from DeliveryClient (type ~= 2 and 3)")
end
task.wait(math.random()/2)
ByteUtilModules.PhoneHandler:b(1)
Logger:log("Accepted delivery",delivery_type)
end,"DeliveryClient"))

AutoFarmTab:NewSection("Ustawienia")

AutoFarmTab:NewSlider(
"Szybkość teleportacji",
" u/s",
true,
"/",
{min=20,max=250,default=Config.TweenSpeed},
Config:createHandler("TweenSpeed")
)

AutoFarmTab:NewSlider(
"Wysokość teleportacji",
" units",
false,
"/",
{min=-30,max=100,default=Config.TweenHeight},
Config:createHandler("TweenHeight")
)-- AutoFarmTab:NewSelector("Typy zadań do zaakceptowania", "Blisko", { "Blisko", "Daleko", "Wszystkie" }, Config:createHandler("AutoFarmJobType"))



local MiscTab=Window:NewTab("Misc")-- MiscTab:NewButton("Radio spawn", function()--     if LocalPlayer.Backpack:FindFirstChild("Radio") or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Radio") then--         return NotificationLib:Notify("Już masz radio!", 3, "information")--     end--     for _, player in PlayersService:GetPlayers() do--         local RadioTool = player.Backpack:FindFirstChild("Radio")--         if RadioTool then--             RadioTool:Clone().Parent = LocalPlayer.Backpack--             NotificationLib:Notify("Udało sie zespawnować radio!", 3, "success")--             return--         end--     end--     NotificationLib:Notify("Nie udało sie zespawnować radia!", 3, "error")-- end)















MiscTab:NewSlider(
"Zmień swoją kase kase",
"",
false,
"/",
{min=500,max=1E7,default=1000},
function(value)-- fireconnection(workspace.TheW.TheMN.OnClientEvent, value)

LocalPlayer.leaderstats.Money.Value=value
end
)-- note: velocity hookmetamethod is bugged



MiscTab:NewButton(
"Napraw interfejs aut",
WrapCall(function()
for _,ui in LocalPlayer.PlayerGui:GetChildren()do
if ui.Name=="A-Chassis Interface"then
local CarValue=ui.Car.Value
if CarValue==nil or CarValue.Parent~=workspace.Cars then
ui:Destroy()
end
end
end
end,"FixVehicleInterface")
)-- MiscTab:NewSection("ESP")-- MiscTab:NewToggle("ESP włączone", Config:create("Esp"))-- MiscTab:NewToggle("Vehicle ESP", Config:create("VehicleESP"))-- MiscTab:NewToggle("Player ESP", Config:create("PlayerESP"))-- MiscTab:NewButton("Load ESP", function()-- 	-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()-- 	-- ExunysDeveloperESP.Load()-- end)










local GameplayTab=Window:NewTab("Gameplay")
GameplayTab:NewToggle("Nieskończone paliwo",Config:create("InfFuel"))
local fuelHook
fuelHook=hookmetamethod(game,"__namecall",function(self,...)
local args={...}
local method=getnamecallmethod()
WrapCall(function()
if self.Name:lower():find("fuel")and method=="FireServer"then
if Config.InfFuel then
args[1]=1e-9*math.random()
end
end
end,"InfFuelHook")()

return fuelHook(self,table.unpack(args))
end)

GameplayTab:NewButton(
"Wyłącz wszystkie radary",
WrapCall(function()
for _,v in workspace:FindFirstChild("radary"):GetDescendants()do
if v:IsA("BasePart")then
v.CFrame=CFrame.new()
end
end
NotificationLib:Notify("Wyłączono wszystkie radary",3,"success")
end,"DisableRadars")
)

local ServersTab=Window:NewTab("Serwery")
local ServersFound={}
local ServerLabelList={}

ServersTab:NewButton(
"Dołącz do tego samego serwera",
WrapCall(function()
game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer)
end,"RejoinServer")
)

local OrderMap={
["Malejąca"]="Desc",
["Rosnąca"]="Asc",
}

ServersTab:NewSelector(
"Kolejność serwerów",
Config.ServerSortOrder,
{"Malejąca","Rosnąca"},
Config:createHandler("ServerSortOrder")
)

ServersTab:NewButton(
"Skanuj serwery",
WrapCall(function()
NotificationLib:Notify("Skanuje serwery...",3,"notification")
local Response=request({
Url=string.format(
"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true",
game.PlaceId,
OrderMap[Config.ServerSortOrder]
),
})
local Body=HttpService:JSONDecode(Response.Body)

if Body and Body.data then
local j=0
for i,v in next,Body.data do
if
type(v)=="table"
and tonumber(v.playing)
and tonumber(v.maxPlayers)
and v.playing<v.maxPlayers
and v.id~=JobId
then
j=j+1-- table.insert(ServersFound, 1, v.id)

ServersFound[j]=v.id
if ServerLabelList[j]~=nil then
ServerLabelList[j]:Text(
string.format("Dołącz do serwera %d/%d osób",v.playing,v.maxPlayers)
)-- ServerLabelList[j]:Text(string.format("Dołącz %d/%d osób", v.playing, v.maxPlayers))

else
table.insert(
ServerLabelList,
1,
ServersTab:NewButton(
string.format("Dołącz do serwera %d/%d osób",v.playing,v.maxPlayers),
function()
queue_on_teleport("loadfile('pcd.bundle.lua')()")
game:GetService("TeleportService")
:TeleportToPlaceInstance(game.PlaceId,ServersFound[i],LocalPlayer)
end
)
)
end
end
end
else
return NotificationLib:Notify("Nie udało sie znależć serwerów",3,"error")
end

NotificationLib:Notify("Zaktualizowano liste serwerów",3,"notification")
end,"ScanServers")
)

ServersTab:NewSection("Znalezione serwery")

local TrollTab=Window:NewTab("Trollowanie")
local PlayerTextbox=TrollTab:NewTextbox(
"Nazwa graczka",
"",
Config.TrollSelectedPlayer,
"all",
"small",
true,
false,
Config:createHandler("TrollSelectedPlayer")
)

TrollTab:NewButton(
"Znajdź najbliższego gracza",
WrapCall(function()
local LowestDistance=math.huge
local CurrPlayer
for _,player in PlayersService:GetPlayers()do
if player.Character and player~=LocalPlayer then
local Distance=(player.Character.PrimaryPart.Position-LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Distance<LowestDistance then
CurrPlayer=player
LowestDistance=Distance
end
end
end
if not CurrPlayer then
return NotificationLib:Notify("Jesteś sam na tym serwerze!",3,"notification")
end
PlayerTextbox:Input(CurrPlayer.DisplayName)
NotificationLib:Notify("Znaleziono "..CurrPlayer.DisplayName,3,"notification")-- PlayerTextbox:Input(CurrPlayer.DisplayName)-- PlayerTextbox:Fire(CurrPlayer.DisplayName)


end,"FindNearestPlayer")
)

TrollTab:NewButton(
"Znajdź najbliższego gracza w aucie",
WrapCall(function()
local LowestDistance=math.huge
local CurrPlayer
for _,player in PlayersService:GetPlayers()do
if player.Character and player~=LocalPlayer then
local Distance=(player.Character.PrimaryPart.Position-LocalPlayer.Character.PrimaryPart.Position).Magnitude
if Distance<LowestDistance and player.Character.Humanoid.Sit then
CurrPlayer=player
LowestDistance=Distance
end
end
end
if not CurrPlayer then
return NotificationLib:Notify("Jesteś sam na tym serwerze!",3,"notification")
end
PlayerTextbox:Input(CurrPlayer.DisplayName)-- Config.TrollSelectedPlayer = CurrPlayer.DisplayName

NotificationLib:Notify("Znaleziono "..CurrPlayer.DisplayName,3,"notification")-- PlayerTextbox:Fire(CurrPlayer.DisplayName)

end,"FindNearestPlayerInVehicle")
)

local IsViewingPlayer=false
local ConnectionDied
TrollTab:NewButton(
"Zmień kamere na gracza",
WrapCall(function()
local CurrentCamera=workspace.CurrentCamera
IsViewingPlayer=not IsViewingPlayer
if IsViewingPlayer==false then
CurrentCamera.CameraSubject=LocalPlayer.Character.Humanoid
if ConnectionDied then
ConnectionDied:Disconnect()
end
return
end
local TargetName=Config.TrollSelectedPlayer:lower()
if not TargetName then
return NotificationLib:Notify("Nie wpisałeś nicku gracza",3,"error")
end
local Target
for _,value in PlayersService:GetPlayers()do
if value.Name:lower():find(TargetName)~=nil or value.DisplayName:lower():find(TargetName)~=nil then
Target=value
break
end
end
if not Target then
return NotificationLib:Notify("Taki gracz nie istnieje",3,"error")
end
if not Target.Character then
return NotificationLib:Notify("Ten gracz nie zyje",3,"error")
end
CurrentCamera.CameraSubject=Target.Character.Humanoid
ConnectionDied=Target.Character.Humanoid.Died:Connect(function()
CurrentCamera.CameraSubject=LocalPlayer.Character.Humanoid
ConnectionDied:Disconnect()
end)
end,"ChangeCamera")
)

TrollTab:NewSection("Trollowanie")-- TrollTab:NewButton("Wywal auto gracza", SafeCall(function()--     local TargetName = Config.TrollSelectedPlayer--     if not TargetName then--         return NotificationLib:Notify("Nie wpisałeś nicku gracza", 3, "error")--     end--     TargetName = TargetName:lower()--     local Target = nil--     for _, value in PlayersService:GetPlayers() do--         if value.Name:lower():find(TargetName) ~= nil or value.DisplayName:lower():find(TargetName) ~= nil then--             Target = value--             break--         end--     end--     if not Target then--         return NotificationLib:Notify("Taki gracz nie istnieje", 3, "error")--     end--     if not Target.Character then--         return NotificationLib:Notify("Ten gracz nie zyje", 3, "error")--     end--     local TargetVehicle = workspace.Cars:FindFirstChild(Target.Name)--     if not TargetVehicle then--         return NotificationLib:Notify(Target.DisplayName .. " nie ma auta", 3, "error")--     end--     local PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)--     if not PlayerVehicle then--         NotificationLib:Notify("Respie auto...", 3, "notification")--         ReplicatedStorage.spawn_car:FireServer("Maluch", Color3.new(math.random(), math.random(), math.random()))--         task.wait(2.5)--         PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)--         if not PlayerVehicle then--             return NotificationLib:Notify("Nie udało sie zrespawnować malucha!", 3, "error")--         end--         fireproximityprompt(PlayerVehicle.DriveSeat.DPX)--         task.wait(0.5)--     end--     if not LocalPlayer.Character.Humanoid.Sit then--         fireproximityprompt(PlayerVehicle.DriveSeat.DPX)--         task.wait(0.5)--     end--     NotificationLib:Notify("Wypierdalanie auta gracza " .. Target.Name, 3, "notification")--     local OriginalPivot = PlayerVehicle:GetPivot()--     local RunService = game:GetService("RunService")--     local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")--     local flinging = true--     if humanoid then--         humanoid.Died:Connect(function()--             flinging = false--         end)--     end--     -- for _, part in PlayerVehicle:GetDescendants() do--     --     if part:IsA("BasePart") then--     --         part.CanCollide = false--     --     end--     -- end--     repeat--         RunService.Heartbeat:Wait()--         PlayerVehicle:PivotTo(TargetVehicle:GetPivot() ---             Vector3.new(6 * (math.random() - 0.5), 6 * (math.random() - 0.5), 6 * (math.random() - 0.5)))--         local character = LocalPlayer.Character--         if not humanoid.Sit then--             flinging = false--             break--         end--         local root = character.HumanoidRootPart--         local vel, movel = nil, 0.1--         while not (character and character.Parent and root and root.Parent) do--             RunService.Heartbeat:Wait()--             character = LocalPlayer.Character--             root = character.HumanoidRootPart--         end--         vel = root.Velocity--         root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)--         RunService.RenderStepped:Wait()--         if character and character.Parent and root and root.Parent then--             root.Velocity = vel--         end--         RunService.Stepped:Wait()--         if character and character.Parent and root and root.Parent then--             root.Velocity = vel + Vector3.new(0, movel, 0)--             movel = movel * -1--         end--     until flinging == false--     PlayerVehicle:PivotTo(OriginalPivot)--     -- task.wait(0.5)--     -- PlayerVehicle:PivotTo(LocalPlayer.Character:GetPivot())-- end, "Wywal auto gracza"))































































































TrollTab:NewButton(
"Jumpscare",
WrapCall(function()
local TargetName=Config.TrollSelectedPlayer
if not TargetName then
return NotificationLib:Notify("Nie wpisałeś nicku gracza",3,"error")
end
TargetName=TargetName:lower()
local Target
for _,value in PlayersService:GetPlayers()do
if value.Name:lower():find(TargetName)~=nil or value.DisplayName:lower():find(TargetName)~=nil then
Target=value
break
end
end
if not Target then
return NotificationLib:Notify("Taki gracz nie istnieje",3,"error")
end
if not Target.Character then
return NotificationLib:Notify("Ten gracz nie zyje",3,"error")
end
local PlayerVehicle=workspace.Cars:FindFirstChild(LocalPlayer.Name)
if not PlayerVehicle then
NotificationLib:Notify("Respie auto...",3,"notification")
ReplicatedStorage.spawn_car:FireServer("Maluch",Color3.new(math.random(),math.random(),math.random()))
task.wait(2.5)
PlayerVehicle=workspace.Cars:FindFirstChild(LocalPlayer.Name)
if not PlayerVehicle then
return NotificationLib:Notify("Nie udało sie zrespawnować malucha!",3,"error")
end
fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
end
if not LocalPlayer.Character.Humanoid.Sit then
fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
task.wait(0.1)
end
NotificationLib:Notify("Jumpscaruje gracza "..Target.DisplayName,3,"notification")
if not LocalPlayer.Character.Humanoid.Sit then
fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
task.wait(0.1)
end
local OriginalPivot=PlayerVehicle:GetPivot()
PlayerVehicle:PivotTo(Target.Character:GetPivot())-- PlayerVehicle:PivotTo(CFrame.lookAt(--     (Target.Character:GetPivot() - Target.Character:GetPivot().LookVector * 5).Position,--     Target.Character:GetPivot()))



task.wait(2)
if PlayerVehicle.Parent==nil then
NotificationLib:Notify("Twój pojazd został usunięty!",3,"notification")
LocalPlayer.Character:PivotTo(OriginalPivot)
else
PlayerVehicle:PivotTo(OriginalPivot)
end
end,"JumpscarePlayer")
)
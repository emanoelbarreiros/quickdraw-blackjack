local constants = require 'src/constants'

Sound = {}

function Sound:new(filename, cacheSize)
  local o = {};
  o.sources = {};
  o.cacheSize = cacheSize or 2;
  o.sources[1] = love.audio.newSource(filename, "static");
  o.index = 1;
  o.volume = 1;
  for i = 2, o.cacheSize do
    o.sources[i] = o.sources[1]:clone();
  end
  
  self.__index = self;
  setmetatable(o, self);
  return o;
end

function Sound:play()
  if not constants.MUTE_ALL_SOUNDS then
    self.sources[self.index]:play();
    self.index = (self.index % self.cacheSize) + 1;
  end
end

function Sound:stop()
  for i = 1, self.cacheSize do
    self.sources[i]:stop();
  end
end

function Sound:setVolume(vlm)
  for i = 1, self.cacheSize do
    self.sources[i]:setVolume(vlm);
  end
end

function Sound:playWithPitch(pitch)
  self.sources[self.index]:setPitch(pitch)
  self:play()
end

function Sound:setLooping(shouldLoop)
  for i = 1, self.cacheSize do
    self.sources[i]:setLooping(shouldLoop);
  end
end

return Sound;
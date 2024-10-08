math.randomseed(os.time())

M = {}

M.center = function(str, targetWidth)
  if str == nil or str == '' then
    return string.rep(' ', targetWidth)
  end

  local lines = {}
  if type(str) == 'table' then
    lines = str
  else
    for line in string.gmatch(str, '[^\r\n]+') do
      table.insert(lines, line)
    end
  end

  local maxLineLength = 0
  for _, line in ipairs(lines) do
    maxLineLength = math.max(maxLineLength, vim.fn.strdisplaywidth(line))
  end
  local leftPadding = math.floor((targetWidth - maxLineLength) / 2)

  local result = {}
  for _, line in ipairs(lines) do
    local rightPadding = string.rep(' ', targetWidth - leftPadding - vim.fn.strdisplaywidth(line))
    table.insert(result, string.rep(' ', leftPadding) .. line .. rightPadding)
  end

  return table.concat(result, '\n')
end

M.art = {
  neovim = function()
    return [[
      ,l;             c,
   .:ooool'           loo:.
 .,oooooooo:.         looooc,
l:,loooooooool,       looooool
llll,;ooooooooc.      looooooo
lllllc,coooooooo;     looooooo
lllllll;,loooooool'   looooooo
lllllllc .:oooooooo:. looooooo
lllllllc   'loooooool,:ooooooo
lllllllc     ;ooooooooc,cooooo
lllllllc      .coooooooo;;looo
lllllllc        ,loooooool,:ol
 'cllllc         .:oooooooo;.
   .;llc           .loooo:.
      ,;             ;l;
    ]]
  end,
  fish = function()
    return '<°)))><'
  end,
  shark = function()
    return [[
                                 ,-
                               ,'::|
                              /::::|
                            ,'::::o\                                      _..
         ____........-------,..::?88b                                  ,-' /
 _.--"""". . . .      .   .  .  .  ""`-._                           ,-' .;'
<. - :::::o......  ...   . . .. . .  .  .""--._                  ,-'. .;'
 `-._  ` `":`:`:`::||||:::::::::::::::::.:. .  ""--._ ,'|     ,-'.  .;'
     """_=--       //'doo.. ````:`:`::::::::::.:.:.:. .`-`._-'.   .;'
         ""--.__     P(       \               ` ``:`:``:::: .   .;'
                "\""--.:-.     `.                             .:/
                  \. /    `-._   `.""-----.,-..::(--"".\""`.  `:\
                   `P         `-._ \          `-:\          `. `:\
                                   ""            "            `-._)
      ]]
  end,
}

M.single_line = function()
  local lib = {
    '¯\\_(ツ)_/¯',
    'ᕙ(⇀‸↼‶)ᕗ',
    '(╯°□°）╯︵ ┻━┻',
    '┻━┻︵ \\(°□°)/ ︵ ┻━┻',
    '(⋟﹏⋞)',
    '(☞ﾟ∀ﾟ)☞',
    '[¬º-°]¬',
    '(>ლ)',
    '(╥﹏╥)',
    '(♥_♥)',
    '(っ◕‿◕)っ',
    'c[_]',
    '(ง •̀_•́)ง',
    '(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧',
    'ლ( `Д’ ლ)',
    'ᕕ(⌐■_■)ᕗ ♪♬',
    'O=(-Q)',
    '‿( ́ ̵ _-`)‿',
    '^(*(oo)*)^',
    '/X\\(-)/X\\',
    '@(_)@',
    '( •_•)>⌐■-■ (⌐■_■)',
    '@( * O * )@',
    'ˁ˚ᴥ˚ˀ',
    '┏━┓ ︵ /(^.^/)',
    '\\m/_(>_<)_\\m/',
    'ᒡ◯ᵔ◯ᒢ',
    '=^..^=',
    '@xxxx[{::::::::::::::>',
    '( _)0*´¯`·.¸.·´¯`°Q(_ )',
    '✈',
    '[●▪▪●-]',
    'ᗧ···ᗣ···ᗣ··',
    '❚█══█❚',
    '(///_ ;)',
    '~(‾▿‾)~',
    'ヽ(￣(ｴ)￣)ﾉ',
    '[: :|:::]',
    'd(^o^)b¸¸♬',
    '~~~~~~\\o/~~~~~/\\~~~~~',
    'c====(=#O| )',
    '=^..^=',
    '︻デ┳═ー',
    '(∩╹□╹∩)',
    '(╭ರ_•́)',
    '(∩◕(oo)◕∩)',
    '><((((`>',
    '»»---------------►',
    '~~~~╘══╛~~~~',
    '(Ͼ˳Ͽ)..!!!',
    '┬┴┬┴┤･ω･)ﾉ├┬┴┬┴',
    '(づ ￣ ³￣)づ',
    '(⌐■_■)--︻╦╤─ - - -',
    '@--`--,---',
    '( ͡° ͜ʖ ͡°)',
    "@_''''-''''",
    'ˁ(OᴥO)ˀ',
    '[::] [::]',
    '✲´*。.❄¨¯`*✲。❄。*。',
    '^(;,;)^',
    '|-o-|',
    '-=iii=<()',
    '(∩ ͡° ͜ʖ ͡°)⊃━☆ﾟ. *',
    'ಠ_ಠ',
    'ᕕ( ᐛ )ᕗ',
    'ლ(ಠ益ಠ)ლ',
    '( ͜。 ͡ʖ ͜。)',
    'ō͡≡o˞̶',
    'ˁ(⦿ᴥ⦿)ˀ',
    '(´ε｀ )',
    'ʕ·͡ᴥ·ʔ',
    '(‾⌣‾)♉',
    'ლ(ಠ益ಠ)ლ',
    '❚█══█❚',
    '๑۩۩๑',
    '\\m/ (>.<) \\m/',
    '(ಠ_ಠ)┌∩┐',
    't(-_-t)',
    '(-(-_(-_-)_-)-)',
    '-^^,--,~',
    '█▬█ █ ▀█▀',
    '┣▇▇▇═─',
    '║▌║█║▌│║▌║▌█',
    "(◕_◕)=ε/̵͇̿̿/''''̿''''̿ ̿",
    'n_n',
    '(╯°_°）╯︵ ━━━',
    'd[o_0]b',
    '(づ ￣ ³￣)づ ⓈⓂⓄⓄⓉⒽ',
    '╭∩╮（︶︿︶）╭∩╮',
    'ϟƘƦƖןןΣx﻿',
    'ヽ(·̿̿Ĺ̯̿̿·̿✿)ﾉ',
    '(╯°□°）╯︵ ┻━┻',
    '( ^-^)_旦',
    '(¡ ¡)',
    '<\\\\> ~~~~',
    '(\\\\\\| ~~~',
    '▬▬ι═══════>',
    '[::]',
    '┌∩┐(◣ _ ◢)┌∩┐',
    'd[-_-]b',
    'Ƹ̵̡Ӝ̵̨̄Ʒ',
    '(╯︵╰,)',
    'ᕕ( ᐛ )ᕗ',
    '‹’’›(Ͼ˳Ͽ)‹’’›',
    '┻━┻ ︵ ლ(⌒-⌒ლ)',
    'ʕノ•ᴥ•ʔノ ︵ ┻━┻',
    'owo',
    'ɯ-(ꞋʊꞋ)-ɯ',
    '/¯\\_/°^_^°\\_/¯\\',
    'ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!',
    '( ^​_^）o自自o（^_​^ )',
    'ʕつ•ᴥ•ʔつ',
    'ʕつಠᴥಠʔつ ︵ ┻━┻',
    'ʕつ ͡°ᴥ ͡°ʔつ',
    'ᶘ ◕ᴥ◕ᶅ',
    'ʕ⌐■ᴥ■ʔ',
    'ʕつ•ᴥ•ʔつ⌐■-■',
    '┬─┬ ノʕ•ᴥ•ノʔ',
    'ʕಠಿᴥಠʔ',
    'ʕಠᴥಠʔ ಠ_ಠ ᶘಠᴥಠᶅ',
    'ʕಠಿᴥಠʔ ಠಿ_ಠ ᶘಠಿᴥಠᶅ',
    '／人 ⌒ ‿‿ ⌒ 人＼',
    '(ง’-‘)ง',
    '┌ಠ_ಠ)┌∩┐ ᶠᶸᶜᵏ♥ᵧₒᵤ',
    'ᵛᵉᵧₒᵤᶫᵒᵛᵉᵧₒᵤ ᶫᵒᵛᵉᵧₒᵤ',
    '█▬█ █▄█ █▬█ █▄█',
    '@( * O * )@',
    "(◕('''' 人 '''') ◕)",
    '(/◕ヮ◕)/ (^o^) (✿◠‿◠)',
    '＼＼\\٩(๑`^´๑)۶//／／',
    'ೕ(Ò⺫ Ó )೨',
    'o(_ _)o',
    'ヾ(_ _。）',
    'ヽ༼ ʘ̚ل͜ʘ̚༼◕_◕༽◉_◔ ༽ﾉ',
    'Σ(‘◉⌓◉’)',
    ': ◉ ∧ ◉ : ╏',
    '٩(๏̯๏)۶',
    'ಠ_ರೃ',
    '(｢๑•₃•)｢ ʷʱʸ?',
    '¿ⓧ_ⓧﮌ',
    'X‿X',
    '↑_(ΦwΦ;)Ψ',
    '!!(　’ ‘)ﾉﾉ⌒●~*',
    '( -_-)旦~',
    '( ⌒o⌒)人(⌒-⌒ )v',
    '＼(◑д◐)＞∠(◑д◐)',
    'o(╥﹏╥)o',
    '(つ◉益◉)つ',
    '༼ つ ▀_▀ ༽つ',
    'Σ_(꒪ཀ꒪」∠)_',
    'ヘ（。□°）ヘ',
    '人人人ヾ( ;×o×)〃 人人人',
    '╰╏ ◉ 〜 ◉ ╏╯',
    '∠(･`_´･ )',
    '(n˘v˘•)¬',
    '{zzz}°°°( -_-)>c[_]',
    '(ヘ･_･)ヘ┳━┳',
    '(๑˃̵ᴗ˂̵)و',
    '＼ ٩( ᐛ )و /／',
    'ヾ(◎o◎,,；)ﾉ',
    '~(^._.)',
    ',(u°)>',
    'ლ(ಠ_ಠლ)',
    'h(o x o )m',
    'くコ:彡',
    '>°))))彡',
    '¯\\_| ಠ ∧ ಠ |_/¯',
    '/╲/\\༼ *ಠ 益 ಠ* ༽/\\╱\\',
    '༼ ºل͟º༼ ºل͟º ༽ºل͟º ༽',
    '╰( ⁰ ਊ ⁰ )━☆ﾟ.*･｡ﾟ',
    'ヽ(⌐■_■)ノ♪♬',
    'mmmyyyyy<⦿⽘⦿>aaaannn',
    '༼ つ ◕_◕ ༽つ',
    '♥♥ˁ(⦿ᴥ⦿)ˀ♥♥',
    '▄︻┻═━一',
    '(╯^□^)╯︵ ❄☃❄',
    '︻デ┳═ー',
    '(•_•)>⌐■-■ (⌐■_■)',
    '8)~~~~~ *',
    '┌∩┐(◣_◢)┌∩┐',
    '',
    'V(-.o)V',
    '┌∩┐(◣ _ ◢)┌∩┐',
    'ヽ༼ຈʖ̯ຈ༽ﾉ',
    '( ͡° ʖ̯ ͡°)',
    '୧༼ಠ益ಠ༽୨',
    '(☞ﾟヮﾟ)☞',
    '༼つಠ益ಠ༽つ ─=≡ΣO))',
    '∩( ・ω・)∩',
    '(　ﾟ Дﾟ)',
    '(＾▽＾)',
    'ヽ（´ー｀）┌',
    'つ ◕_◕ ༽つ つ ◕_◕ ༽つ',
    '♪└(￣◇￣)┐♪',
    '(╯°□°)╯︵ ɹoɹɹƎ',
    '-----------<----(@',
    'ಠ_ಠ',
    '<´(• ﻌ •)`>',
    '(っ °Д °;)っ',
    '.·´¯`(>▂<)´¯`·.',
    '(UwU)',
    '＼（〇_ｏ）／',
  }
  return lib[math.random(#lib)]
end

M.random_single_line_every = function(seconds)
  local current_ascii_art = ''

  local timer = vim.uv.new_timer()
  timer:start(0, seconds * 1000, function()
    current_ascii_art = M.single_line()
  end)

  return function()
    return current_ascii_art
  end
end

return M

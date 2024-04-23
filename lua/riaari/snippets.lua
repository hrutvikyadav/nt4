local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local my_snippet_1 = s("tmysnippet", --text to trigger snippet
    {
        --simple text node, inserts text as is
        t('Txt from '), t '`t` node',
        t({ ':: Look below!', 'Table of strings!', 'i.e => `t({"", "", ""})`', 'Will be multiline!', }),
    } --nodes
)
--Txt from `t` node

local my_snippet_2 = s("tmysnippet-ins",
    {
        -- insert node enables user to insert text in multiple positions in snippets based on a jump_index (starts at 1 ends at 0)
        i(1, 'First pos'), t '___', i(2, 'second pos'), t '___', i(0, 'last pos')
    }
)

local function fnode_func(
    args,     -- text from i(2) in this example i.e. { { "456" } }
    parent,   -- parent snippet or parent node
    user_args -- user_args from opts.user_args
)
    return 'F[' .. args[1][1] .. user_args .. ']F' .. 'Time ⏰' .. parent.env.TM_FILENAME
end

local my_snippet_3 = s('tmysnippet-fn',
    {
        t({ 'Multi', 'Line', 'Baby' }),
        i(1, 'Put in ehre'), t({ '', '--', '' }),
        -- fn node runs a function and inserts text based on other nodes jump_index for eg.
        f(fnode_func,
            { 2 },                                       --node references using jump_index for now
            {
                user_args = { '||my custom arg value' }, -- gets passed to callback fn
                user_args2 = { '||another arg value' },  -- this too
            }
        ),
        t({ '', '--', '' }),
        i(2, 'Now see magic'), t({ '', '--', '' }),
        t({ 'Baby', 'we never stop', 'Do we??' }),
        i(0, 'Ok now that youve seen'),
    }
)

local function fnode_fname(
    args,     -- text from i(2) in this example i.e. { { "456" } }
    parent,   -- parent snippet or parent node
    user_args -- user_args from opts.user_args
)
    return ' ' .. parent.env.TM_FILENAME .. ' (' .. user_args .. ')'
end

local my_snippet_4 = s("choice", {
    c(1, {
        t 'c 1',
        t 'c 2',
        t 'c 3',
        i(0, 'TEXT choice'),
        f(function(_) return "func choice" end, {}, {}),
    }),
})

ls.add_snippets("all", {
    s("ternary", {
        -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
        i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
    }),
    s("auth", {
        t(" Author : Hrutvik Yadav "), i(1, "time?"),
    }),
    s("filename", {
        t("Filename => "),
        f(fnode_fname,
            { nil },
            { user_args = { 'Lua File' } }
        ),
        --i(1)
    }),
    my_snippet_1,
    my_snippet_2,
    my_snippet_3,
    my_snippet_4,
    s("funcmyfunc", {
        f(
            function(args, _, _)
                return '-- ' .. args[1][1] .. ' ||Params: ' .. args[2][1]
            end,
            { 1, 2 },
            {}
        ),
        t({ '', 'local function ' }),
        i(1, 'fname'),
        t '(',
        i(2, 'params'),
        t({ ')', '   ' }),
        i(3, '--body'),
        t({ '', 'end' })
    })
})


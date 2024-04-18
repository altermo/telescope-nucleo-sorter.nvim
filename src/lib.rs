use mlua::prelude::*;

struct Matcher {
    matcher: nucleo_matcher::Matcher,
    pattern: Option<nucleo_matcher::pattern::Pattern>,
}

impl mlua::UserData for Matcher {
    fn add_methods<'lua, M: LuaUserDataMethods<'lua, Self>>(methods: &mut M) {
        methods.add_method_mut(
            "set_pattern",
            |_, this: &mut Matcher, (patt,): (LuaString,)| {
                this.pattern = Some(nucleo_matcher::pattern::Pattern::parse(
                    patt.to_str()?,
                    nucleo_matcher::pattern::CaseMatching::Ignore,
                    nucleo_matcher::pattern::Normalization::Smart,
                ));
                return Ok(());
            },
        );
        methods.add_method_mut("match", |_, this: &mut Matcher, (str,): (LuaString,)| {
            if this.pattern.as_ref().unwrap().atoms.len() == 0 {
                return Ok((1, vec![]));
            };
            let b = str.as_bytes();
            let u = nucleo_matcher::Utf32Str::Ascii(b);
            let mut v = vec![];
            if let Some(score) =
                this.pattern
                    .as_ref()
                    .unwrap()
                    .indices(u, &mut this.matcher, &mut v)
            {
                return Ok((score, v.iter().map(|x| x + 1).collect()));
            } else {
                return Ok((0, v));
            };
        });
    }
}

#[mlua::lua_module]
fn nucleo_nvim(lua: &Lua) -> LuaResult<LuaTable> {
    let exports = lua.create_table()?;
    exports.set(
        "create_matcher",
        lua.create_function(|_, ()| {
            let m = Matcher {
                matcher: nucleo_matcher::Matcher::new(
                    nucleo_matcher::Config::DEFAULT.match_paths(),
                ),
                pattern: None,
            };
            Ok((m,))
        })?,
    )?;
    return Ok(exports);
}

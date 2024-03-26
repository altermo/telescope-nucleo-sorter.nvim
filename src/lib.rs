#[no_mangle]
pub extern "C" fn r#match(
    out: *mut u32,
    str1: *const u8,
    len1: usize,
    str2: *const u8,
    len2: usize,
) -> u32 {
    let patt: &str =
        unsafe { std::str::from_utf8(std::slice::from_raw_parts(str1, len1)).unwrap() };
    let item: &str =
        unsafe { std::str::from_utf8(std::slice::from_raw_parts(str2, len2)).unwrap() };
    let u = nucleo_matcher::Utf32Str::Ascii(item.as_ref());
    let mut matcher = nucleo_matcher::Matcher::new(nucleo_matcher::Config::DEFAULT.match_paths());
    let pattern = nucleo_matcher::pattern::Pattern::parse(
        patt,
        nucleo_matcher::pattern::CaseMatching::Ignore,
        nucleo_matcher::pattern::Normalization::Smart,
    );

    let mut v = vec![];
    if let Some(score) = pattern.indices(u, &mut matcher, &mut v) {
        for (i, &j) in v.iter().enumerate() {
            unsafe { *out.add(i) = j };
        }
        score
    } else {
        0
    }
}

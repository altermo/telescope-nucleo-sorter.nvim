## Install

### Lazy

```lua
{
  'altermo/telescope-nucleo-sorter.nvim',
  build = 'cargo --release'
  -- on macos, you may need below to make build work
  -- build = 'cargo rustc --release -- -C link-arg=-undefined -C link-arg=dynamic_lookup',
},
```

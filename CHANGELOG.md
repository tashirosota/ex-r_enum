<!-- @format -->

# Changelog

## v0.6.1 (2022-1-28)

### Breaking changes

- `RMap.atomlize_keys/1` is deprecated. Use atomize_keys/1 instead.
- `RMap.deep_atomlize_keys/1` is deprecated. Use deep_atomize_keys/1 instead.

## v0.6.0 (2022-2-x)

### Features

- RMap.Ruby
- RMap.ActiveSupport
- Update readme

## v0.5.0 (2022-1-26)

### Features

- RList.ActiveSupport

## v0.4.0 (2022-1-24)

### Features

- RList.Ruby
- RList, Range, RMap and Stream has all REnum functions without duplicate native functions.
- Add zip, values_at, fill, union, unshift, shift, rindex, rotate and rassoc (by [@mnishiguchi](https://github.com/mnishiguchi))
- Add RList.Ruby.combination (by [@TORIFUKUKaiou](https://github.com/mnishiguchi))

### Breaking changes

- Removes deprecated native functions.

## v0.3.2 (2022-1-20)

### Features

- Add `REnum.each_slice/2` that returns Stream.
- Add alias `REnum.to_l` of `REnum.to_lilst`.
- Add `mix dialyzer` to test.

### Breaking changes

- `REnum.each_slice/3` returns :ok.
- `REnum.to_a` uses Enum.to_list/1
- `REnum.first` returns tuple when given map.

### Other

- Fix hex version badge.

## v0.3.1 (2022-1-17)

### Readme

- Use ✅ in the Progress table. (by [@mnishiguchi](https://github.com/mnishiguchi))
- Fix API reference link. (by [@mnishiguchi](https://github.com/mnishiguchi))
- Loosen the library version. (by [@mnishiguchi](https://github.com/mnishiguchi))

### Refactors

- REnum.Support.truthy_count. (by [@TORIFUKUKaiou](https://github.com/TORIFUKUKaiou))
- REnum.Ruby.tally. (by [@TORIFUKUKaiou](https://github.com/TORIFUKUKaiou))

## v0.3.0 (2022-1-16)

### Breaking changes

Rename some modules to without Renum prefix.

| From                           | To                    |
| ------------------------------ | --------------------- |
| REnum.Enumerable.ActiveSupport | REnum.ActiveSupport   |
| REnum.Enumerable.Ruby          | REnum.Ruby            |
| REnum.Enumerable.Support       | REnum.Support         |
| REnum.List.Native              | RList.Native          |
| REnum.List.ActiveSupport       | RList.ActiveSupport   |
| REnum.List.Ruby                | RList.Ruby            |
| REnum.List.Support             | RList.Support         |
| REnum.Map.Native               | RMap.Native           |
| REnum.Map.ActiveSupport        | RMap.ActiveSupport    |
| REnum.Map.Ruby                 | RMap.Ruby             |
| REnum.Map.Support              | RMap.Support          |
| REnum.Range.Native             | RRange.Native         |
| REnum.Range.ActiveSupport      | RRange.ActiveSupport  |
| REnum.Range.Ruby               | RRange.Ruby           |
| REnum.Range.Support            | RRange.Support        |
| REnum.Stream.Native            | RStream.Native        |
| REnum.Stream.ActiveSupport     | RStream.ActiveSupport |
| REnum.Stream.Ruby              | RStream.Ruby          |
| REnum.Stream.Support           | RStream.Support       |
| REnum.Utils                    | RUtils                |

## v0.2.1 (2022-1-16)

- Changes description and some docs.

## v0.2.0 (2022-1-15)

- REnum.ActiveSupport

## v0.1.0 (2022-1-14)

- Initial release.
- Support all native enumerable functions.
- REnum.Ruby
- REnum.Support

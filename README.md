# erb-hiera

## About

Generate documents from a scope, ERB template(s) and Hiera Data

## Install

```
gem install erb-hiera
```

## Usage

```
$ ./bin/erb-hiera --help
Options:
  --config=<s>          specify config file
  --hiera-config=<s>    specify hiera config file
  --dry-run             don't write out files
  --verbose             print compiled template(s)
  --debug               print backtrace on error
```

## Example

```
cd example
erb-hiera --config config.yaml --hiera-config hiera.yaml --verbose
```

## References

* [erb](http://www.stuartellis.name/articles/erb/#writing-templates)
* [hiera](https://docs.puppet.com/hiera/)

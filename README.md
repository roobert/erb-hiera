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
  --template=<s>        specify a single template instead of a config
  --environment=<s>     specify the environment
  --verbose             print compiled templates
  --debug               print backtrace on error
  --dry-run             don't write out files
```

## Example

```
cd example
erb-hiera --config config.yaml --hiera-config hiera.yaml --verbose

# render a specific template using injected erb scope (outputs only to stdout)
erb-hiera --template=templates/template.txt --hiera-config=hiera.yaml environment=dev another=value
```

## References

* [erb](http://www.stuartellis.name/articles/erb/#writing-templates)
* [hiera](https://docs.puppet.com/hiera/)

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
  -m, --mapping-config=<s>    specify mapping config file
  -c, --hiera-config=<s>      specify hiera config file
                               
  -i, --input=<s>             override input config options
  -o, --output=<s>            override output config options
                               
  -s, --scope=<s>             override the lookup scope
  -v, --variables=<s>         override facts
                               
  --dry-run                   don't write out files
                               
  --verbose                   print compiled templates
  --debug                     enable hiera logging and print backtrace on error
                               
```

## Example

```
cd example
erb-hiera --mapping-config mapping.yaml --hiera-config hiera.yaml --verbose

# render a specific template using injected erb scope (outputs only to stdout)
erb-hiera --mapping-config mapping.yaml --hiera-config hiera.yaml --scope '{ "environment": "prod" }' -o -

# use normal lookup path but override a fact at the top level
erb-hiera --mapping-config mapping.yaml --hiera-config hiera.yaml --variables '{ "environment::description": "override description" }' -o -
```

## References

* [erb](http://www.stuartellis.name/articles/erb/#writing-templates)
* [hiera](https://docs.puppet.com/hiera/)

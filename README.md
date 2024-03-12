GChat Reader
============

## About

This is a parser and printer for Google's Chat data export. Useful to read history.

## Usage

```
$ gchat-reader messages.json
```

## Development

This is a standard [Dune](https://github.com/ocaml/dune) project, you
can compile and run the program while developing using

```
$ dune exec -- gchat-reader $file.json
```

### Ocamlformat

We use `ocamlformat` to format the code.

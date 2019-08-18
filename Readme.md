# Trivia.jl

[![Build Status](https://travis-ci.org/rdeits/Trivia.jl.svg?branch=master)](https://travis-ci.org/rdeits/Trivia.jl)
[![codecov.io](https://codecov.io/github/rdeits/Trivia.jl/coverage.svg?branch=master)](https://codecov.io/github/rdeits/Trivia.jl?branch=master)

This package provides a very simple interface to the [Open Trivia Database](https://opentdb.com/) API in [Julia](https://julialang.org). It consists of some helpful methods to retrieve and display trivia questions as well as a simple interactive mode to make it easy to play through a round of questions in a given category. 

## Installation

### Getting Julia

If you don't have Julia installed, you will need to download it from <https://julialang.org/downloads/>. This package was written using Julia v1.1.1, but any v1.x.y version should be fine. 

### Installing this package

You can install this package through Julia's built-in package manager, `Pkg`. 

First, start up Julia. You should see the normal Julia prompt: 

```julia
julia>
```

Press `]` to activate `Pkg` mode. Your prompt should switch to:

```julia
pkg> 
```

Run the following to install this package:

```julia
pkg> add https://github.com/rdeits/Trivia.jl
```

## Usage

Start Julia. If you have the `pkg>` prompt, press `backspace` to get back to the normal `julia>` prompt. 

Load this package by running:

```julia
julia> using Trivia
```

And start a round of trivia with:

```julia
julia> play_round()
```

## Hacking on this Package

If you want to make changes to this package, the easiest way to do that is to use the Julia package manager to "develop" the package. Start Julia, and press `]` to switch to `pkg>` mode. Then run:

```julia
pkg> develop Trivia
```

This will clone the repository to `~/.julia/dev/Trivia/`. You can edit the files there and make commits just like you would with any other git/github project.

Note that by default your changes will not take effect until you restart Julia. To enable automatically updating your code as you edit it, without restarting Julia, check out [Revise.jl](https://github.com/timholy/Revise.jl).


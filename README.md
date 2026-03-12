# buildtime
simple tests for build time of basic c/c++ io functions - optionally using PCH

to use:

```bash 
./buildtime.sh

```


sample output:
```
puts: 0.06s => 16K
printf: 0.06s => 16K
iostream: 1.18s => 24K
format: 1.77s => 236K
print: 1.81s => 236K
```

or for use with Pre-Compiled-Headers

```bash
./buildtime.sh --pch

```

sample output

```
building iostream.h.gch: 1.70
building format.h.gch: 1.70
building print.h.gch: 1.63
puts: 0.06s => 16K
printf: 0.05s => 16K
iostream: 0.52s => 24K
format: 1.16s => 236K
print: 1.20s => 236K
```

right now this is configured to default to `g++-14 --std=c++23`

you can customize that with, eg:

```bash 
CXX=g++-15 CXXFLAGS=--std=c++26 ./buildtime.sh

```


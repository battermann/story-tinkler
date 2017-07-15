module TestData exposing (..)

continuations : String
continuations = """- continue:
    - prompt: Do you want to go to A?
      next: a
    - prompt: Or do you want to go to B?
      next: b
"""

section : String
section = """***
- id: root    

# Introduction

bla bla bla

- continue:
    - prompt: Do you want to go to A?
      next: a
    - prompt: Or do you want to go to B?
      next: b
***      
""" 

input : String
input = """***
- id: root    

# Introduction

bla bla bla

- continue:
    - prompt: Do you want to go to A?
      next: a
    - prompt: Or do you want to go to B?
      next: b

***
- id: a    

### Section A

bla bla bla

- continue:
    - prompt: Do you want to go to C?
      next: c
    - prompt: Or do you want to go to D?
      next: d

"""
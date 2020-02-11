# VerificaSoftware_Parte1
Project 17 -- REC language Interpreter (call by name)
## Syntax
### Meaning of the meta-variables
1. n \- positive and negative integers
2. x \- variables
3. f<sub>i</sub> \- function variable
4. a<sub>i</sub> \- **arity** of f<sub>i</sub>
5. 0=true; n=false if n \neq 0 \- boolean variables
   1. \* \- disjunction
   2. if b then 1 else 0 \- negation 


### REC Terms
t ::= n | x | t<sub>1</sub> + t<sub>2</sub> | t<sub>1</sub> * t<sub>2</sub> | if t<sub>0</sub> then t<sub>1</sub> else t<sub>2</sub> | f<sub>i</sub>(t<sub>1</sub>, ... t<sub>a<sub>i</sub></sub>)

### Function variables declaration
f<sub>1</sub>(x<sub>1</sub>, ..., x<sub>a<sub>1</sub></sub>) = t<sub>1</sub>

...

f<sub>k</sub>(x<sub>1</sub>, ..., x<sub>a<sub>k</sub></sub>) = t<sub>k</sub>

1. two declarations must have different function variables
2. t<sub>i</sub> is the definition of f<sub>i</sub>
3. t<sub>i</sub> can contain f<sub>i</sub> (functions can be recursive)

### Program Examples:
1. **Factorial Program** - main() is the first function that will be executed, on its
left appear the variables declarations, on its right the functions declarations.

```Python
x=4 main() factorial(x) = if x then 1 else x*factorial(x-1) main() = factorial(x+1)
```

2. **Unending cycle**:

```Python
x=2 g(6) g(z) = g(1+z) + 2
```

3. **Multiple lines program**

```Python
x=2
y=1
g(3,z(0))
f(x,y)=4+y 
g(s,longvariable)=f(4,h(s)+1) 
h(p)=if p then 1000 else 1+h(p-1) 
z(x)=z(y)
```

## Semantics
The interpreter is based on **call by name**, **denotational semantics**.
The interpreter *I* is defined as (by the project request):

$I(d, t, p)=[|t|]_{va}\delta_d\rho$

Where
   1. $d=\{f_i (x_1,..., x_{a_i})=t_{i=1}^n\}$ where $\forall i\in 1...a_n.t_i\in REC$ is the declaration of the program's functions;
   2. $\rho \in Env_a$ is the variables enviroment;
   3. $\delta_d=fix(F_d)$ and $F_d$ is the functional induced by $d$:
      1. if $[|t|]_{va}\delta_d\rho=\perp$ then the interpreter does not terminate (with no compiler error);
      2. if $[|t|]_{va}\delta_d\rho=\lfloor n \rfloor \in N_{\perp}$ then terminates and outputs $n$.


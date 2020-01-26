# VerificaSoftware_Parte1
Project 17 -- Interprete per il linguaggio REC (call by name)
## Sintassi
### Considerazioni
1. n: N numeri interi positivi e negativi
2. x: Var variabili
3. f<sub>i</sub>: Fvar function variable
4. a<sub>i</sub>: **arity** numero di parametri della funzione f<sub>i</sub>
5. 0=true; altrimenti=false: valori booleani
   1. disgiunzione: *
   2. negazione: if b then 1 else 0
6. termine **chiuso** quando non contiene variabili in Var


### Termini del linguaggio REC
t ::= n | x | t<sub>1</sub> + t<sub>2</sub> | t<sub>1</sub> * t<sub>2</sub> | if t<sub>0</sub> then t<sub>1</sub> else t<sub>2</sub> | f<sub>i</sub>(t<sub>1</sub>,t<sub>a<sub>i</sub></sub>)

### Dichiarazione di function variables
f<sub>1</sub>(x<sub>1</sub>, ..., x<sub>a<sub>1</sub></sub>) = t<sub>1</sub>

...

f<sub>k</sub>(x<sub>1</sub>, ..., x<sub>a<sub>k</sub></sub>) = t<sub>k</sub>

1. le funzioni sono definite per **dichiarazione**
2. non si possono definire due funzioni con la stessa function variable
3. le funzioni possono essere ricorsive
4. i termini t<sub>i</sub> possono contenere f<sub>i</sub>(ricorsione)
5. t<sub>i</sub> è la definizione di f<sub>i</sub>
6. call by name

### Esempio di programmi:
1. Programma semplice

```Python
x=2 g (1) f (x) = x+20 g (y) = f(y)
```

2. Ciclo infinito:

```Python
inp = "x=2 (g (6)) (g(z) = 3+g(3+z)+3)
```

3. Programma su più righe

```Python
x=2
y=1
g(3,z(0))
f(x,y)=4+y 
g(s,longvariable)=f(4,h(s)+1) 
h(p)=if p then 1000 else 1+h(p-1) 
z(x)=z(y)```

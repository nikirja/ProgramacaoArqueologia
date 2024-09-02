# WORKING BOYS SIMULATION / SIMULAÇÃO MENINOS TRABALHADORES

## WHAT IS IT? / O QUE É?

**EN**
This model was made to try and understand the spatial distribution of artifacts at a place that children both lived and worked under the care of catholic orders, something usual in Brazil during the 20th century.

**BR**
Este modelo foi feito buscando entender a distribuição espacial de artefatos em um ambiente que mistura moradia e trabalho de crianças sob os cuidados de ordens religiosas, uma prática comum no Brasil do século XX.

## HOW IT WORKS / COMO FUNCIONA

**EN**
The boys move between their dorm, workshops, and school. However, because they are children, there is chance that they will wander the grounds. If this happens and they are discovered by a supervisor, the boys are sent to the chapel in penance and from there they will go back to the dorm.
The supervisors move randomly while watching the boys.

**BR**
Os meninos se movimentam entre seu dormitório, as oficinas onde trabalham e escola. Entretanto, por serem crianças, há chances de vagarem pelo terreno. Se isso acontecer e forem encontrados por qualquer supervisor, são mandadas para a capela em penitência e, de lá voltam para o dormitório.
Os supervisorem se movimentam aleatoriamente vigiando os meninos.

## HOW TO USE IT / COMO USAR

**EN**
**setup** creates the world, definig its light green color, spawning randomly one dorm, one chapel, three workshops, one school,  and a number of boys and supervisors defined by their sliders.
**quantosMeninos** is the slider that defines the number of boys, the human shaped purple or magenta turtles. Their minimum number is 10 and their maximum is 50.
**quantosSupervisores** is the slider that defines the number of supervisors, the human shaped black turtles. Their minimum number is 0 and their maximum is 10.
**autoridade** is the slider that defines how much the boys respect (or fear) their supervisors. The higher the authority, the smaller the chance of the boys wander. The minimum is 0% and the maximum is 100%.
**aglomeracao** is the slider that defines how many boys are needed on the same patch to make an artifact drop. The minimum is two and the maximum is 6.
**go** starts the model, make boys and supervisors walk, artifacts drop ans patches change color every 10th artifact droped on the same patch.
**fujoes** monitors how many boys wander.
**artefatos** monitors how many artifacts dropped.

**BR**
**setup** gera o mundo, dando-lhe o fundo na cor verde clara, criando um dormitório, uma capela, três oficinas e uma escola, além das quantidades de meninos e supervisores determinadas pelos sliders.
**quantosMeninos** é o slider que define a quantidade de meninos, as turtles de forma humana nas cores roxa e magenta. O mínimo é 10 e o máximo é 50.
**quantosSupervisores** é o slider que define a quantidade de supervisores, as turtles de forma humana na cor preta. O mínimo é 0 e o máximo é 10.
**autoridade** é o slider que define o quanto os meninos respeitam (ou temem) seus supervisores. Quanto maior a autoriadade, menor a chance dos meninos vagarem. O mínimo é 0% e o máximo é 100%.
**aglomeracao** é o slider que define quantos meninos são necessários no mesmo patch para que um artefato caia. O mínimo é 2 e o máximo é 6.
**go** inicia o modelo, fazendo os meninos e supervisores andarem, assim como os artefatos caírem e os patches mudarem de cor a cada acumulo de 10 artefatos.
**fujoes** monitora a quantidade de meninos que vagam.
**artefatos** monitora a quantidade de artefatos que caíram.

## THINGS TO NOTICE / COISAS PARA PERCEBER

**EN**
Observe how the random spatial configuration influences the destribution of artifacts.


**BR**
Note como a configuração espacial aleatória influencia na distribuição de artefatos.

## THINGS TO TRY / COISAS PARA TENTAR

**EN**
Try diffent ratios of *autoridade* and *quantosSupervisores* to see which one is more efficient in controling the boys.
Play around with the *aglomeracao* and *quantosMeninos* sliders to observe if more or less artifacts are dropped.
Observe the relationship between *autoridade* and the places in which the artfacts drop.

**BR**
Experimente ver se *autoridade* ou a maior *quantosSupervisores* é mais eficiente para controlar os meninos.
Brinque com os sliders de *aglomeracao* e de *quantosMeninos* para observar a quantidade de artefatos que caem.
Observe a relação entre autoridade e locais de concentração de artefatos.

## EXTENDING THE MODEL / EXPANDINDO O MODELO

**EN**
This model can be adapted to other exploitative and coercive scenarios.

**BR**
Pode ser modificado para pensar outras situação de exploração e coerção.

## CREDITS AND REFERENCES / CRÉDITOS E REFERÊNCIAS

(c) Nicole Dias

**EN**
SOUZA, MA 2001. *As estratégias da pedagogia do assistencialismo em Belo Horizonte, 1930-1990: educação e caridade* [Doctoral thesis, Federal University of Minas Gerais]. Respositório Institucional da UFMG. https://repositorio.ufmg.br/bitstream/1843/FAEC-86PMYU/1/binder1.pdf

**BR**
SOUZA, Marco Antônio de. **As estratégias da pedagogia do assistencialismo em Belo Horizonte, 1930-1990**: educação e caridade. 2001. 427f. Tese (Doutorado) - Faculdade de Educação, Universidade de Minas Gerais, Belo Horizonte, 2001. Disponível em: https://repositorio.ufmg.br/bitstream/1843/FAEC-86PMYU/1/binder1.pdf. Acessado em: 1 dez 2023.

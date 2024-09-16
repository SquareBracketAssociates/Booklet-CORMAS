## Building a Model from Scratch: ECEC Model


The model we present here and that you will build is inspired by a paper by Pepper and Smuts: Evolution of Cooperation in an Ecological Context {!citation|ref=Pepp00a!}.



The model consists of a 2 dimensional grid, wrapped in both axes to avoid edge effects. It contains two kinds of entities: plants and foragers. The main idea is to study the survival of two populations of agents that depend on the spatial configuration.

This implementation of the ECEC model can be found in the GitHub repository of Cormas at https://github.com/cormas/cormas


### Basic description

This model contains two kinds of entities: plants and foragers.

#### The Plants



The Plants are created only once and have a fixed location. They do not move, die or reproduce. A plant's only "behavior" is to grow (and be eaten by foragers). The plants vary only in their biomass, which represents the amount of food energy available to foragers. At each time unit, this biomass level increases according to a logistic growth curve:


$$
x_{t+1} = x_{t}+r_{x_{t}}(1 - \frac{x_{t}}{k})
$$





%  logisticCurves was created with R script available in: script/logisticCurves.R 

![Logistic equation and its sigmoid curves (r = 0.2 and k = 10) % width=100&anchor=sigmoth](figures/logisticCurves.png)


#### The Foragers

At each step, the Foragers burn energy according to their catabolic rate. This rate is the same for all foragers. It is fixed to 2 units of energy per time period.

A forager feeds on the plant in its current location if there is one. It increases its own energy by reducing the same amount of the plant's biomass. Foragers are of two types that differ in their feeding behavior - the amount of biomass they consume, called the _harvest rate_:

* **Restrained foragers** take only 50% of the plant's biomass.

* **Unrestrained foragers** eat 99% of the plant. This harvest rate is less than 100% so that plants can continue to grow after being fed on, rather than being permanently destroyed.

The Foragers do not change their feeding behavior type and their offspring keep the same heritable traits.



**Rules for Foragers' Movements**

Foragers examine their current location and the surrounding cells (8 adjacent cells). From those not occupied by another forager, they choose the one containing the plant with the highest energy.

If the chosen plant would yield enough food to meet their catabolic rate they move there. If not, they move instead to a randomly chosen adjacent free cell (not occupied by another forager). This movement rule leads to the emigration of foragers from depleted patches, and simulates the behavior of individuals exploiting local food sources while they last, but migrating rather than starving in an inadequate food patch.

##### Other Biological Functions of Foragers

Foragers lose energy (catabolic rate, 2 points) regardless of whether or not they move.

If their energy level reaches zero, they die. But they do not have maximum life spans.

If a forager's energy level reaches an upper fertility threshold (fixed to 100), it reproduces asexually, creating an offspring with the same heritable traits as itself (e.g., feeding strategy). At the same time the parent's energy level is reduced by the offspring's initial energy (50). Newborn offspring occupy the nearest free place to their parent. If there is no free space around the forager, it does not reproduce.

### Model formalism in UML

#### Structure of ECEC

The class diagram in Figure *@fig:ecec-UML@* presents the structure of the model.

% maid with argoUML file figure/uml_ecec.zargo

![UML Class diagram % width=100&anchor=fig:ecec-UML](figures/Diagrammedeclasses.png)


The underlined attributes are called "Class variables": their values are equal for all instances. For example, the catabolicRate class variable means that its value (2 units of energy) is identical for every forager, both restrained and unrestrained.



#### Dynamics' description of ECEC

The sequence diagram in Figure *@fig:ecec-MainStepSequenceDiagram@* presents the main time step of ECEC. This is a DTSS ('Discrete Time System Specification', according to the classification proposed by Zeigler et al. {!citation|ref=Zeig00a!}) meaning that, on the contrary of DEVS ('Discrete Event System Specification'), the evolution of the simulation is sliced in time steps.

![The main step sequence diagram % width=70&anchor=fig:ecec-MainStepSequenceDiagram](figures/scheduler-main-step.png)



As the model is purely theoretical, the step duration is not defined. In one step, all entities should evolve: the plants increase their biomass (according to Logistic equation), and the foragers perform their biological functions. To avoid biasing the model by always giving preference to the same agents (the privilege to choose first the best plant), the list of the foragers is randomly mixed at each step.

The diagram presented in Figure *@fig:ecec-ForagerDiagram@* describes the activities performed by foragers at each step.

![Activity diagram of a Forager % width=50&anchor=fig:ecec-ForagerDiagram](figures/forager-step.png)

The sequence diagram in Figure *@fig:ecec-ReproductionDiagram@* shows the reproduction behavior of the foragers.

![Sequence diagram of the reproduction process % width=70&anchor=fig:ecec-ReproductionDiagram](figures/reproduction-diagram.png)



### Adapting ECEC to CORMAS Framework


The diagram in Figure *@fig:ecec-UMLCormas@* is an adaptation of the main class diagram (in design stage, see Figure *@fig:ecec-UML@*) to fit the Cormas framework.

![UML class diagram, adapted to Cormas (implementation stage) % width=100&anchor=fig:ecec-UMLCormas](figures/uml_cormas.png)

ECEC defines 3 kinds of entities: Plants, RestrainedForagers and UnrestrainedForagers.

As the plants are spatially located and can't move, we aggregated the plant with the spatial unit in one entity. Thus, a VegetationUnit is a kind of _SpatialEntityCell_ with an additional attribute: “biomass”.


As the foragers are the located agents of ECEC, the Forager class must inherit from _AgentLocation_ abilities to enable the agents to move and to perceive their neighborhoods.



### Implementing ECEC with CORMAS

The brief introduction to Pharo can be found in Chapter *@chap:pharo@*, the instructions to install Cormas are in Section *@sec:pharo-InstallingCormas@*.


#### Creating a new CORMAS Model. 


You can create a new model by creating a new package using _SystemBrowser_ (`Ctrl+O+B`). It can be done with a mouse right-click or with a shortcut `Ctrl+N+P`.



![Create a new model % anchor=newPackage](figures/cormas_create_package.png)



#### Defining a spatial entity: the "VegetationUnit"



Once you've got a package model, you can start to create classes using UML from Figure. *@fig:ecec-UMLCormas@*.

For example, looking for _vegetationUnit_ it work as Figure *@newclassVeg@*:



```

CMSpatialEntityCell subclass: #CMECECVegetationUnit
	instanceVariableNames: 'biomass'
	classVariableNames: 'K r'
	package: 'Cormas-Model-ECEC'
```

![Create a new class % anchor=newclassVeg](figures/cormas_class.png)


#### Designing the VegetationUnit Behavior

##### Setting the parameters of a logistic growth

The logistic equation needs 2 parameters: the carrying capacity "k" and the growth rate "r".



As the values of these parameters are equals for each Plant instances, they are defined as class variables.

##### Create the K and r class variables

Using right-click you can access to the refactoring tool (Figure *@refactI@*). And use it, to create class variables accessors.

![Generate instance variables %anchor=refactI](figures/refactor_instance_class.png)

It will generate an empty variable in ` read ` and ` write: ` access.

As you can see for access to a variable the accessor us ` : ` .

An accessor readable is defined **without** ` : `

To initialize ` k ` you can define it as :

```
K
	^K ifNil: [ K := 10 ]
```



This lazy definition say : if k is ` null ` our model use ` K := 10 `.

To be able to write/update ` k ` you can conserve the preformated variable description.



```
K: anObject

	K := anObject
```

For ` r ` you can proceed as well



```
r
	^ r ifNil: [ r := 0.2 ]
```

And

```
r: anObject
	r := anObject
```


##### Create the biomass attribute



It's pretty the same for creating  instance variable. You can define:



```
biomass
	^ biomass ifNil: [ biomass := 0 ]

```

and

```
biomass: anObject
	biomass = anObject ifTrue: [^nil].	"for optimization"
	biomass := anObject.
	self changed
```


##### Write a logistic growth method in a new protocol
@sectionBiologie

To code a method, you need to open a browser on the VegetationUnit class. For that, double click on VegetationUnit name of the "entities" interface (or select in the right-click menu, "browse").



![Pharo code browser %anchor=pharo-browser](figures/pharo-browser.png )



By default, the bottom panel displays the code that defines the class. By selecting the biomass method (into the methods panel), the bottom panel will display the code of this accessor method:


![biomass method % anchor=biomass-method](figures/biomass-method.png)



_biomass_ and _biomass:_ are two methods to read and set the biomass value. They have been automatically generated by Cormas. Both methods are stored into the “accessing” protocol. But a protocol is just a way to organize the methods. To create a new protocol, right click on the "protocol" panel and select "Add protocol...". Then write _growth_ as protocol name.



To create a new method into the "growth" protocol, remove the text on the "source" panel (bottom) and write your own method on it:


Enter the following code:


```
logisticGrowth
   self biomass: (Cormas logisticGrowth: self biomass r: self class r K: self class K)

``

Then accept this code: right button "Accept" or Ctrl S.


The logisticGrowth method uses a class method from Cormas class (#logisticGrowth:r:K:).


##### Write the basic step method in the "control" protocol

In the same way as previously, create a new protocol of instance variable called "control" and the #step method in it.

```
step

   self logisticGrowth

```


##### Write a random init method in the “init” protocol

In the same way as previously, create a new protocol called init and the #initRandomBiomass method in it.



```
initBiomassRandomly
   "Set the initial value of biomass, between ]0 ; 1] ."
   
   self biomass: (Cormas randomFloatFrom: 0.01 to: 0.5)
```





##### Assigning a green intensity to the energy level of the plant


At the end of this chapter we want to use a color gradient in order to inform on the biomass available in each cell of our grid. For that you need to initialize a color pallete as a class variable



```

pallete
	^ pallete ifNil: [ pallete := RTMultiLinearColor new
		colors: (RTColorPalette sequential colors: 9 scheme: 'YlGnBu') ].
```


Once is done you need to create also a class method using `= pallete `=. It done here :



```

pov

	^ self class pallete
		rtValue: (self biomass / 10.0)

```

##### Add a "point of view" method named povBiomass


You can now close the browser of "VegetationUnit".



#### Designing an agent foraging the resource





Let us define the Forager agent as a kind of situated agent. As previously you can create it as :



```
CMAgentLocation subclass: #CmEcecForager
	instanceVariableNames: 'energy'
	classVariableNames: 'cataboliticRate fertilityThreshold harvestRate'
	package: 'Cormas-Model-myModel'
```





As the foragers are located, the Forager class must inherit from CMAgentLocation. Our ` #CmEcecForager ` class will be a super class, but before create subclasses we will defined generic methods. As for _VegetationUnit_ you can create accessor with the "right clik" using the refactoring tool.



##### Setting the attributes of the foragers



The values of these parameters are equals for each agent. We can define them as class variables as describe in the class diagram.

You mostly need to modified accessors in ` read `. ` write ` accessors can stay as configured by default.



```
catabolicRate
	"Getter accessor with default value = 2 "

	^ catabolicRate ifNil: [catabolicRate := 2]
```

```

fertilityThreshold
	"Getter accessor with default value = 100 "

	^ fertilityThreshold ifNil: [fertilityThreshold := 100]

```


```
harvestRate

	^ harvestRate
```


#### Create two sub-classes of Forager

As designed in the class diagram, Forager is specialized in two sub-classes: Restrained and Unrestrained. Because Forager is a class of our model.



```
CmEcecForager subclass: #CmEcecRestrained
	instanceVariableNames: ''
	classVariableNames: 'harvestRaste'
	package: 'Cormas-Model-myModel'
```

```

CmEcecForager subclass: #CmEcecUnRestrained
	instanceVariableNames: ''
	classVariableNames: 'harvestRaste'
	package: 'Cormas-Model-myModel'
```


#### Coding the biological methods of Forager


Similarly to the Logistic growth of VegetationUnit, we have to code the biological methods at the forager level. As described in the main class diagram, these methods are equals for both subtypes of foragers. Thus, they have to be defined at superClass Forager level.



Edit the Forager class and create “biology” protocol (see the logisticGrowth methode in *@sectionBiologie@*). Then write the following methods.



```
consumeEnergy
   "Loose energy according to catabolic rate (-2 by time step)"

   self energy: self energy - self class catabolicRate
```


```

move
	"The Forager examines its current location and around. From those not occupied, he chooses the one containing the plant with the highest energy. If the chosen plant would yield enough food to meet their catabolic rate (2 units), he moves there. If not, he moves instead to a randomly chosen adjacent free place (not occupied by another forager)"

	| goodCells |
	goodCells := self patch neighbourhoodAndSelf
		select:
			[:cell | cell biomass > self class catabolicRate and: [cell noOccupant]].
	goodCells isEmpty
		ifTrue: [self randomWalkConstrainedBy: [:c | c noOccupant]]
		ifFalse:
			[self
				moveTo:
					(goodCells asSortedCollection: [:c1 :c2 | c1 biomass > c2 biomass]) first]
```

```
eat
   "Eat a quantity of the biomass of the cell"
   | qty|
   qty := self patch biomass * self class harvestRate.
   self energy: self energy + qty.
   self patch biomass: self patch biomass - qty
```


```
reproduce
	"The forager reproduces asexually, creating an offspring with the same heritable traits as itself (e.g., feeding strategy). At the same time the parent's energy is reduced by the offspring's initial energy (50).  Newborn offspring occupies the nearest free place to its parent. "

	| newForager freePlace |
	freePlace := self nearestEmptyLocationWithinRadius: 1.
	freePlace ifNil: [^nil].
	newForager := self newEntity: self class.
	self energy: self energy - newForager energy.
	newForager moveTo: freePlace
```


```
die
	"set dead attribute to true"

	self dead: true
```

```
isEnergyHigh
	"Tests if energy is upper than the fertilityThreshold (100), in order to reproduce"

	^self energy >= 100
```

```
isEnergyTooLow
	"Tests if energy is 0 or less, so that the forager will die"

	^self energy <= 0
```


```
step
	self consumeEnergy.
	self move.
	self eat.
	self isEnergyHigh ifTrue: [self reproduce].
	self isEnergyTooLow ifTrue:[self die]

```

#### Create an orchestra conductor (scheduler)


You need to create a new class how will conduct all experiments


```
CormasModel subclass: #CmEcecCModel
	instanceVariableNames: 'theCmEcecRestraineds theCmEcecUnRestraineds theCmEcecVegetationUnits'
	classVariableNames: ''
	package: 'Cormas-Model-myModel'
```

Once it's done you can generate accessors for ` theCmEcecRestraineds theCmEcecUnRestraineds theCmEcecVegetationUnits ` as usual (click right -> refactoring -> instance var refactoring). It will create 6 methods in a accessing protocol.



And as usual you need change ` read ` method and provide a lazy initialization.



```

theCmEcecRestraineds
	"Returns a collection of all the instances of the sub classes collected by cormasModel."

	^ theCmEcecRestraineds ifNil:[theCmEcecRestraineds := IndexedSet new]

```
```

theCmEcecUnRestraineds
	"Returns a collection of all the instances of the sub classes collected by cormasModel."

	^ theCmEcecUnRestraineds ifNil:[theCmEcecUnRestraineds := IndexedSet new]
```

```
theCmEcecVegetationUnits
	"Returns a collection of all the instances of the sub classes collected by cormasModel."

	^ theCmEcecVegetationUnits ifNil:[theCmEcecVegetationUnits := IndexedSet new]
```


In this case ` theMyEntitys ` is a way for your #modelClass to dialogue with each entity of your model.

You also needs to provide an ` init ` how will defined at the instance level, how to initialize the simulation. We defined init in two times. First the landscape and after agents. Process like this, you can be a little bit more generic if you want to change the wait to initialize the grid.


```
initLandscaspe
	"create space and inject biomass in each cells"

	self createGridX: 15 Y: 27 neighbourhood: 8 closed: true.
	self theCmEcecVegetationUnits do: [ :c |  c initBiomassRandomly].
```

```

initStandard
	"create space and populate with restraineds and unrestraineds"

	self initLandscape.
	self createN: 10 randomlyLocatedEntities: CMECECUnRestrainedEP.
	self createN: 10 randomlyLocatedEntities: CMECECRestrainedEP

```

Here we defined our grid (space) with dimension and Moore neighborhood (8, but you can also define a von Neumann neighborhood).

For each cells stock in ` c ` temporary and use ` initBiomassRandomly ` method from ` CmEcecVegetationUnit ` class.


You need to provide a time definition in a ` step: ` method.



```
step: t
	"main step: activation of all the plants (Resource dynamics), then activation of the foragers (Agents dynamics)"
	"Resource dynamics   (because the dynamics of the plants are independents, the activation is not mixed)"

	self stepEntities: self theCmEcecVegetationUnits.

	"Agents dynamics    (because the agents may compete for plant access, the activation is randomly mixed)"
	self askRandom: CmEcecForager toDo: #step.
```

#### Observe the entities - create a world



Now you need to orchestrate all those bricks. It's time to see something ! Steel in the  `= CmEcecCModel `= class you can create a class method called `= exemple `=.

![You can run exemple clicking on the green arrow near to the method name % anchor=runExemple)
](figures/run_exemple.png




```
example

	| aModel |
	aModel := self initialize new.
	"define the names of the 2 methods used to init and to run the simulation"
	aModel activeInit: #initStandard ; activeControl: #step:.
	aModel initSimulation.
	(CMSimulationGrid new
		on: aModel
		withCells: aModel theESE
		withSituatedEntities: aModel allTheSituatedEntities) runAndVisualize
```


Each method called `= example `= will be executable in _pharo_ (Figure *@runExemple@*). To do it you only have to click on the green arrow and it will run your model (Figure *@runECEC@*).



![The ECEC model running in Cormas %anchor=runECEC](figures/ececmodel.png)

